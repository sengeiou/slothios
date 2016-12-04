    //
//  MyPhotosViewController.swift
//  SlothChat
//
//  Created by Fly on 16/10/22.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import Kingfisher

private let PageSize = 20

class MyPhotosViewController: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    var collectionView: UICollectionView?
    let bgImgView = UIImageView.init()
    var dataSource = [UserGalleryPhoto]()
    var pageNum = 1
    var discoverVC: DiscoveryViewController?
    ///临时上传图片的接口，上传成功后需要删除
    var tmpUploadImgList = [UIImage]()
    
    var refreshUI = true

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if refreshUI {
            refreshUI = false
            collectionView?.mj_header.beginRefreshing()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        configCollectionView()
        setupPullToRefresh()
        collectionView?.mj_header.beginRefreshing()
        
        self.configNotice()
    }
    
    func configNotice() {
        NotificationCenter.default.addObserver(forName: SGGlobalKey.DiscoveryDataDidChange, object: nil, queue: OperationQueue.main, using: { (notice) in
            if self.isMyselfShow{
                self.collectionView?.mj_header.beginRefreshing()
            }else{
                self.refreshUI = true
            }
        })
    }
    
    func isShowMyself() {
        
    }

    fileprivate func configCollectionView() {
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
    
    public func addTmpUploadImage(uploadImage: UIImage) {
        let tmpImg = uploadImage.resizedImage(CGSize.init(width: 120, height: 120), interpolationQuality: .default)
        if tmpImg != nil {
            tmpUploadImgList.append(tmpImg!)
            self.collectionView?.reloadData()
        }
    }
    
    public func clearTmpUploadImage() {
        tmpUploadImgList.removeAll()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (dataSource.count + tmpUploadImgList.count + 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : MyPhotosCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPhotosCell", for: indexPath as IndexPath) as! MyPhotosCell
        
        if isAppendIndexPath(indexPath: indexPath) {
            cell.imgView.image = UIImage.init(named: "select_photoBg")
            cell.isShowFlagView(isShow: false)
            return cell
        }
        //如果是临时的图片
        if isImageIndexPath(indexPath: indexPath) {
            let tmpUploadImg = tmpUploadImgList[indexPath.row - 1]
            cell.imgView.image = tmpUploadImg
            return cell
        }
        let galleryPhoto = dataSource[indexPath.row - tmpUploadImgList.count - 1]

        cell.configCellObject(photo: galleryPhoto)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isAppendIndexPath(indexPath: indexPath) {
            if let actionVC = discoverVC {
                UIAlertController.photoPicker(withTitle: nil, showIn: self.view, presentVC: self, onPhotoPicked: { (avatar) in
                    actionVC.uploadPhotoToGallery(uploadImage: avatar)
                }, onCancel:nil)
            }
            return
        }
        if isImageIndexPath(indexPath: indexPath) {
            let tmpUploadImg = tmpUploadImgList[indexPath.row - 1]
            let browser = ImageScrollViewController()
            browser.disPlay(image: tmpUploadImg)
            browser.isShowLikeButton(isShow: false)
            browser.isShowDeleteButton(isShow: false)
            self.present(browser, animated: true, completion: nil)
            
            return
        }
        
        let galleryPhoto = dataSource[indexPath.row - tmpUploadImgList.count - 1]
        
        if galleryPhoto.participateBidAds! == true ||
            galleryPhoto.displayAsBidAds! == true {
            let pushVC = BiddingStatusViewController()
            pushVC.userUuid = galleryPhoto.userUuid
            pushVC.galleryUuid = galleryPhoto.uuid
            pushVC.configWithObject(imageUrl: galleryPhoto.bigPicUrl)
            navigationController?.pushViewController(pushVC, animated: true)
            return
        }
        if galleryPhoto.bigPicUrl != nil {
            let browser = ImageScrollViewController()
            browser.galleryPhotoObj = galleryPhoto
            browser.disPlay(galleryPhoto: galleryPhoto)
            browser.isShowLikeButton(isShow: false)
            self.present(browser, animated: true, completion: nil)
        }
       
    }
    
    func isAppendIndexPath(indexPath: IndexPath) -> Bool {
        return (indexPath.row == 0)
    }
    
    func isImageIndexPath(indexPath: IndexPath) -> Bool {
        if tmpUploadImgList.count > 0 &&
            indexPath.row <= tmpUploadImgList.count {
            return true
        }
        return false
    }

    //MARK: - NetWork
    
    func getGalleryPhoto(at: Position) {
        let engine = NetworkEngine()
        if at == .top {
            pageNum = 1
        }else{
            pageNum += 1
        }
        
        let userUuid = Global.shared.globalProfile?.userUuid
        engine.getPhotoGallery(userUuid: userUuid, pageNum: String(pageNum), pageSize: String(PageSize)) { (response) in
            if at == .top {
                self.collectionView?.mj_header.endRefreshing()
            }else{
                self.collectionView?.mj_footer.endRefreshing()
            }
            if response?.status == ResponseError.SUCCESS.0 {
                if at == .top {
                    self.dataSource.removeAll()
                }
                if let list = response?.data?.list{
                    self.collectionView?.mj_footer?.isHidden = (list.count < PageSize)
                    self.dataSource.append(contentsOf: list)
                }
                self.collectionView?.reloadData()
            }else{
                self.showNotificationError(message: response?.msg)
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

