//
//  ImageScrollViewController.swift
//  SlothChat
//
//  Created by Fly on 16/10/29.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import PKHUD

class ImageScrollViewController: BaseViewController {
    private let imageScroller = ImageScrollView(frame: CGRect.init(x: 0, y: 55, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 55 * 2))
    
    private let topToolBar = UIView()
    private let bottomToolBar = UIView()
    private let deleteButton = UIButton(type: .custom)
    private let likeButton = UIButton(type: .custom)
    
    var isFollow = false{
        didSet{
            refreshLikeButton()
        }
    }
    
    var isMyself = false{
        didSet{
            isShowLikeButton(isShow: !isMyself)
            isShowDeleteButton(isShow: isMyself)
        }
    }
    
    var photoObj: DisplayOrderPhoto?{
        didSet{
            if photoObj != nil{
                isFollow = (photoObj?.currentVisitorLiked)!
                isMyself = Global.shared.isMyself(userUuid: photoObj?.userUuid)
            }else{
                isShowLikeButton(isShow: false)
            }
        }
    }
    
    var galleryPhotoObj: UserGalleryPhoto?{
        didSet{
            if galleryPhotoObj != nil{
//                isFollow = (photoObj?.currentVisitorLiked)!
                isFollow = false
                isMyself = Global.shared.isMyself(userUuid: galleryPhotoObj?.userUuid)
            }else{
                isShowLikeButton(isShow: false)
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        sentuptopToolBar()
        sentupView()
    }
    
    func sentuptopToolBar() {
        
        view.addSubview(topToolBar)
        topToolBar.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.height.equalTo(55)
        }
        
        let closeButton = UIButton(type: .custom)
        topToolBar.addSubview(closeButton)
        closeButton.snp.makeConstraints{ (make) in
            make.right.equalTo(-10)
            make.size.equalTo(CGSize.init(width: 42, height: 42))
            make.centerY.equalTo(topToolBar.snp.centerY)
        }
        
        closeButton.setImage(UIImage.init(named: "close"), for: .normal)
        closeButton.tintColor = UIColor.white
        closeButton.addTarget(self, action: #selector(closeButtonClick), for: .touchUpInside)
        
        
        view.addSubview(bottomToolBar)
        bottomToolBar.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(0)
            make.height.equalTo(55)
        }
        
//        let lineView = UIView()
//        lineView.backgroundColor = SGColor.white
//        bottomToolBar.addSubview(lineView)
//        lineView.snp.makeConstraints { (make) in
//            make.left.top.right.equalTo(0)
//            make.height.equalTo(1)
//        }
        
        bottomToolBar.addSubview(deleteButton)
        deleteButton.snp.makeConstraints{ (make) in
            make.size.equalTo(CGSize.init(width: 32, height: 32))
            make.center.equalTo(bottomToolBar)
        }
        
        deleteButton.setImage(UIImage.init(named: "trash-can"), for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonClick), for: .touchUpInside)
        
        
        bottomToolBar.addSubview(likeButton)
        
        likeButton.snp.makeConstraints{ (make) in
            make.size.equalTo(CGSize.init(width: 32, height: 32))
            make.center.equalTo(bottomToolBar)
        }
        //heart-solid
        let followImg = isFollow ? "heart-solid" : "heart-hollow"
        likeButton.setImage(UIImage.init(named: followImg), for: .normal)
        likeButton.addTarget(self, action: #selector(likeButtonClick), for: .touchUpInside)
        
        isShowLikeButton(isShow: !isMyself)
        isShowDeleteButton(isShow: isMyself)
    }
    
    func isShowDeleteButton(isShow: Bool) {
        deleteButton.isHidden = !isShow
    }
    
    func isShowLikeButton(isShow: Bool) {
        likeButton.isHidden = !isShow
    }
    
    func sentupView() {
        view.addSubview(imageScroller)
        imageScroller.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(55)
            make.bottom.equalTo(-55)
        }
    }
    
    func disPlay(imageUrl: String) {
        imageScroller.display(imageUrl: imageUrl)
    }
    
    func disPlay(image: UIImage) {
        imageScroller.display(image: image)
    }
    
    func disPlay(photoObj: DisplayOrderPhoto) {
        if let picUrl = photoObj.hdPicUrl {
            imageScroller.display(imageUrl: picUrl)
        }
    }
    
    func disPlay(galleryPhoto: UserGalleryPhoto) {
        
        imageScroller.display(image: UIImage(named: "icon")!)
        
        if let picUrl = galleryPhoto.hdPicUrl {
            imageScroller.display(imageUrl: picUrl)
        }
    }
    
    //MARK:- NetWork
    func likeGallery() {
        
        if (!isMyself && self.photoObj == nil) {
            return
        }
        self.isFollow = !self.isFollow
        
        let engine = NetworkEngine()
        let userUuid = Global.shared.globalProfile?.userUuid
        engine.postLikeGalleryList(likeSenderUserUuid: userUuid, galleryUuid: photoObj?.uuid) { (response) in
            if response?.status == ResponseError.SUCCESS.0 {
                self.photoObj?.currentVisitorLiked = true
                NotificationCenter.default.post(name: SGGlobalKey.DiscoveryDataDidChange, object: nil)
            }else{
                self.showNotificationError(message: response?.msg)
            }
        }
    }
    
    func deleteGallery() {
        
        var photoUuid = ""
        if self.galleryPhotoObj != nil {
            photoUuid = (self.galleryPhotoObj?.uuid!)!
        }else{
            photoUuid = (self.photoObj?.uuid!)!
        }
        
        if photoUuid.isEmpty{
            return
        }
        
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        engine.deletePhotoFromGallery(photoUuid: photoUuid) { (response) in
            HUD.hide()
            if response?.status == ResponseError.SUCCESS.0 {
                NotificationCenter.default.post(name: SGGlobalKey.DiscoveryDataDidChange, object: nil)
                self.showNotificationSuccess(message: "已成功删除")
                self.dismiss(animated: true, completion: nil)
            }else{
                self.showNotificationError(message: response?.msg)
            }
        }
    }
    
    //MARK: - Action
    
    func closeButtonClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func deleteButtonClick() {
        deleteGallery()
    }
    
    func likeButtonClick() {
        likeGallery()
    }
    
    fileprivate func refreshLikeButton() {
        let followImg = isFollow ? "heart-solid" : "heart-hollow"
        likeButton.setImage(UIImage.init(named: followImg), for: .normal)
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
}
