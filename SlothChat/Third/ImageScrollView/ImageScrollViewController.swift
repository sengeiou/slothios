//
//  ImageScrollViewController.swift
//  SlothChat
//
//  Created by Fly on 16/10/29.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import PKHUD

enum ImageActionType: Int {
    case likeImg
    case deleteImg
}

typealias ImageScrollClosureType = (_ type: ImageActionType) -> Void

class ImageScrollViewController: BaseViewController {
    private let imageScroller = ImageScrollView(frame: CGRect.init(x: 0, y: 55, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 55))
    
    private let toolBar = UIView()
    private let deleteButton = UIButton(type: .custom)
    private let likeButton = UIButton(type: .custom)
    
    var actionValue: ImageScrollClosureType?
    
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
        sentupToolBar()
        sentupView()
    }
    
    func sentupToolBar() {
        
        view.addSubview(toolBar)
        toolBar.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.height.equalTo(55)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = SGColor.SGLineColor()
        toolBar.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(1)
        }
        
        
        let closeButton = UIButton(type: .custom)
        toolBar.addSubview(closeButton)
        closeButton.snp.makeConstraints{ (make) in
            make.left.equalTo(10)
            make.size.equalTo(CGSize.init(width: 42, height: 42))
            make.centerY.equalTo(toolBar.snp.centerY)
        }
        
        closeButton.setImage(UIImage.init(named: "close"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonClick), for: .touchUpInside)
        
        
        toolBar.addSubview(deleteButton)
        deleteButton.snp.makeConstraints{ (make) in
            make.right.equalTo(-8)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
            make.centerY.equalTo(toolBar.snp.centerY)
        }
        
        deleteButton.setImage(UIImage.init(named: "trash-can"), for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonClick), for: .touchUpInside)
        
        
        toolBar.addSubview(likeButton)
        likeButton.snp.makeConstraints{ (make) in
            if deleteButton.isHidden{
                make.right.equalTo(-8)
            }else{
                make.right.equalTo(deleteButton.snp.left).offset(-26)
            }
            make.size.equalTo(CGSize.init(width: 32, height: 32))
            make.centerY.equalTo(toolBar.snp.centerY)
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
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(55)
        }
    }
    
    
    func setActionClosure(temClosure: @escaping ImageScrollClosureType){
        self.actionValue = temClosure
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
        if let picUrl = galleryPhoto.hdPicUrl {
            imageScroller.display(imageUrl: picUrl)
        }
    }
    
    //MARK:- NetWork
    func likeGallery() {
        
        if (!isMyself && self.photoObj == nil) {
            return
        }
        
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        let userUuid = Global.shared.globalProfile?.userUuid
        engine.postLikeGalleryList(likeSenderUserUuid: userUuid, galleryUuid: photoObj?.uuid) { (response) in
            HUD.hide()
            if response?.status == ResponseError.SUCCESS.0 {
                self.photoObj?.currentVisitorLiked = true
                self.isFollow = !self.isFollow
                if let sp = self.actionValue {
                    sp(.likeImg)
                }
            }else{
                HUD.flash(.label("点赞失败"), delay: 2)
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
                if let sp = self.actionValue {
                    sp(.deleteImg)
                }
                HUD.flash(.label("已成功删除"), delay: 2, completion: { (result) in
                    self.dismiss(animated: true, completion: { 
                        
                    })
                })
            }else{
                HUD.flash(.label("删除失败"), delay: 2)
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
