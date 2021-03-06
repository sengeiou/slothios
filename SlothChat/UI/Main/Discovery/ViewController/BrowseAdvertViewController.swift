//
//  BrowseAdvertViewController.swift
//  SlothChat
//
//  Created by Fly on 16/10/23.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import SDWebImage

class BrowseAdvertViewController: BaseViewController {
    let scrollView = UIScrollView()
    let container = UIView()
    
    let mainImgView = UIImageView()
    let usersListView = LikeUsersView()
    let contentLabel = UILabel()

    var isFollow = false{
        didSet{
            configNavigationRightItem()
        }
    }
    
    var photoObj: DisplayOrderPhoto?{
        didSet{
            if photoObj != nil{
                isFollow = (photoObj?.currentVisitorLiked)!
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sentupView()
        configNavigationRightItem()
    }
    
    func sentupView() {
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        scrollView.addSubview(container)
        container.snp.makeConstraints { (make) in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        mainImgView.contentMode = .scaleAspectFill
        mainImgView.clipsToBounds = true
        container.addSubview(mainImgView)
        container.addSubview(usersListView)
        container.addSubview(contentLabel)

        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byCharWrapping
        
        let w = UIScreen.main.bounds.width
        contentLabel.preferredMaxLayoutWidth = w - 8 * 2
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.textColor = SGColor.SGTextColor()
        
        mainImgView.isUserInteractionEnabled = true
        var tap = UITapGestureRecognizer.init(target: self, action: #selector(tapMainImgView))
        mainImgView.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer.init(target: self, action: #selector(likeUsersClick))
        usersListView.addGestureRecognizer(tap)
        
        mainImgView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.height.equalTo((w * 288.0) / 375.0)
        }
        usersListView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(mainImgView.snp.bottom)
            make.height.equalTo(44)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.right.equalTo(-8)
            make.top.equalTo(usersListView.snp.bottom).offset(24)
        }
        
        container.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentLabel.snp.bottom).offset(20)
        }
    }
    
    func configWithObject(photoObj: DisplayOrderPhoto?) {
        SGLog(message: photoObj)
        if photoObj == nil{
            return
        }
        self.photoObj = photoObj
        
        let mainImgUrl = URL(string: (photoObj?.bigPicUrl)!)
        
        self.mainImgView.sd_setImage(with: mainImgUrl, placeholderImage: UIImage(named: "placeHolder_image1.jpg"))
        
        if let avatarList = photoObj?.getLikeGallerySliceUrlList() {
            usersListView.configViewWithObject(avatarList: avatarList, totalCount: (photoObj?.likesCount)!)
        }
        
        let string1 = "这是一个广告\n\n"
        let string2 = "您在发照片时，可以通过选择是否参与付费竞价，以赢得此广告位。\n竞价结果每周公布一次，如果您竞价成功，可获得该广告位一星期"
        
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        
        let attributedText = NSMutableAttributedString.init(string: string1 + string2)
        let range = NSRange.init(location: 0, length: string1.characters.count)
        attributedText.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 17), range: range)
        self.contentLabel.attributedText = attributedText
    }
    
    //MARK:- Action

    override func confirmClick() {
        SGLog(message: "")
        likeGallery()
    }
    
    func configNavigationRightItem() {
        if isFollow {
            setNavtionConfirm(imageStr: "heart-solid")
        }else{
            setNavtionConfirm(imageStr: "heart-hollow")
        }
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.red
    }
    
    func tapMainImgView() {
        
        let browser = ImageScrollViewController()
        browser.photoObj = photoObj
        browser.disPlay(imageUrl: (photoObj?.hdPicUrl)!)
        browser.isShowDeleteButton(isShow: false)
        self.present(browser, animated: true, completion: nil)
        
    }
    
    func likeUsersClick()  {
        let pushVC = LikeUsersViewController()
        pushVC.galleryUuid = photoObj?.uuid
        pushVC.likeSenderUserUuid = photoObj?.userUuid
        navigationController?.pushViewController(pushVC, animated: true)
    }
    
    //MARK:- NetWork
    
    func likeGallery() {
        if self.photoObj == nil {
            return
        }
        self.photoObj?.currentVisitorLiked = !(self.photoObj?.currentVisitorLiked)!
        self.isFollow = !self.isFollow
        
        let engine = NetworkEngine()
        self.showNotificationProgress()
        let userUuid = Global.shared.globalProfile?.userUuid
        engine.postLikeGalleryList(likeSenderUserUuid: userUuid, galleryUuid: photoObj?.uuid) { (response) in
            self.hiddenNotificationProgress(animated: false)
            if response?.status == ResponseError.SUCCESS.0 {
                
            }else{
                self.showNotificationError(message: response?.msg)
            }
        }
    }

}
