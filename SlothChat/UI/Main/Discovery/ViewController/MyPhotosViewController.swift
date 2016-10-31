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

class MyPhotosViewController: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    var collectionView: UICollectionView?
    let bgImgView = UIImageView.init()
    var dataSource = [UserGalleryPhoto]()
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        configCollectionView()
        getGalleryPhoto()
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
            let pushVC = BiddingStatusViewController()
            pushVC.configWithObject(imgUrl: galleryPhoto.bigPicUrl!)
            self.navigationController?.pushViewController(pushVC, animated: true)
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
                HUD.flash(.label("添加照片成功"), delay: 2)
            }else{
                HUD.flash(.label("添加照片失败"), delay: 2)
            }
        }
    }
    
    func getGalleryPhoto() {
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        let userUuid = Global.shared.globalProfile?.userUuid
        engine.getPhotoGallery(userUuid: userUuid, pageNum: "1", pageSize: "20") { (gallery) in
            HUD.hide()
            if gallery?.status == ResponseError.SUCCESS.0 {
                if let list = gallery?.data?.list{
                    self.dataSource.append(contentsOf: list)
                    self.collectionView?.reloadData()
                }
            }else{
                HUD.flash(.label("获取照片列表失败"), delay: 2)
            }
        }
    }
    
}

