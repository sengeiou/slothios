    //
//  MyPhotosViewController.swift
//  SlothChat
//
//  Created by Fly on 16/10/22.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import PKHUD
import Kingfisher

private let PageSize = 20

class MyPhotosViewController: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    var collectionView: UICollectionView?
    let bgImgView = UIImageView.init()
    var dataSource = [UserGalleryPhoto]()
    var pageNum = 1

    override func viewDidLoad() {
        super.viewDidLoad()        
        configCollectionView()
        setupPullToRefresh()
        getGalleryPhoto(at: .top)
    }

    func configCollectionView() {
        let frame = CGRect.zero
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        let photoMagin = CGFloat(6)
        
        let screenWidth = UIScreen.main.bounds.width
        let width = (screenWidth - photoMagin * 2) / 3.0
        layout.itemSize = CGSize.init(width: width, height: width)
        
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 3
        
        collectionView = UICollectionView.init(frame: frame, collectionViewLayout: layout)
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.register(MyPhotosCell.self, forCellWithReuseIdentifier: "MyPhotosCell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        self.view.addSubview(collectionView!)
        
        collectionView?.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (dataSource.count + 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : MyPhotosCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPhotosCell", for: indexPath as IndexPath) as! MyPhotosCell
        
        if indexPath.row == 0 {
            cell.imgView.image = UIImage.init(named: "select_photoBg")
            cell.isShowFlagView(isShow: false)
            return cell
        }
        
        let galleryPhoto = dataSource[indexPath.row - 1]
        if galleryPhoto.smallPicUrl != nil {
            let url = URL(string: galleryPhoto.smallPicUrl!)
            cell.imgView.kf.setImage(with: url, placeholder: UIImage.init(named: "icon"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            UIAlertController.photoPicker(withTitle: nil, showIn: self.view, presentVC: self, onPhotoPicked: { (avatar) in
                self.uploadPhoto(image: avatar!)
                }, onCancel:nil)
            return
        }
        let galleryPhoto = dataSource[indexPath.row - 1]
        if galleryPhoto.bigPicUrl != nil {
            let browser = ImageScrollViewController()
            browser.galleryPhotoObj = galleryPhoto
            browser.disPlay(galleryPhoto: galleryPhoto)
            browser.isShowLikeButton(isShow: false)
            self.present(browser, animated: true, completion: nil)
            
            browser.setActionClosure(temClosure: { (actionType) in
                if actionType == .deleteImg {
                    self.getGalleryPhoto(at: .top)
                }
            })
        }
       
    }
    
    func publishAdvert(image: UIImage) {
        let pushVC = PublishViewController()
        pushVC.configWithObject(image: image)
        self.navigationController?.pushViewController(pushVC, animated: true)
    }
    
    //MARK: - NetWork
    
    func uploadPhoto(image: UIImage) {
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        engine.postPhotoGallery(picFile: image) { (userPhoto) in
            HUD.hide()
            if userPhoto?.status == ResponseError.SUCCESS.0 {
                self.getGalleryPhoto(at: .top)
                HUD.flash(.label("添加照片成功"), delay: 2)
            }else{
                HUD.flash(.label(userPhoto?.msg), delay: 2)
            }
        }
    }
    
    func getGalleryPhoto(at: Position) {
        let engine = NetworkEngine()
        if at == .top {
            pageNum = 1
        }else{
            pageNum += 1
        }
        
        let userUuid = Global.shared.globalProfile?.userUuid
        engine.getPhotoGallery(userUuid: userUuid, pageNum: String(pageNum), pageSize: String(PageSize)) { (gallery) in
            if at == .top {
                self.collectionView?.mj_header.endRefreshing()
            }else{
                self.collectionView?.mj_footer.endRefreshing()
            }
            if gallery?.status == ResponseError.SUCCESS.0 {
                if let list = gallery?.data?.list{
                    self.collectionView?.mj_footer?.isHidden = (list.count < PageSize)
                    if at == .top {
                        self.dataSource.removeAll()
                    }
                    self.dataSource.append(contentsOf: list)
                    self.collectionView?.reloadData()
                }
            }else{
                HUD.flash(.label("获取照片列表失败"), delay: 2)
            }
        }
    }

}
private extension MyPhotosViewController {
        
    func setupPullToRefresh() {
        collectionView?.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.getGalleryPhoto(at: .top)
        })
        collectionView?.mj_header.isAutomaticallyChangeAlpha = true
        
        collectionView?.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self.getGalleryPhoto(at: .bottom)
        })
    }
}

