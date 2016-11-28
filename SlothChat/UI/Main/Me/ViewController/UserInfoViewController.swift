//
//  UserInfoViewController.swift
//  SlothChat
//
//  Created by fly on 16/10/17.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import PKHUD

class UserInfoViewController: BaseViewController,SDCycleScrollViewDelegate {
    var isEdited = false
    let scrollView = UIScrollView()
    let container = UIView()
    let infoView = UserInfoView()
    let deleteButton = UIButton(type: .custom)

    var bannerView: SDCycleScrollView?
    var editView: UserInfoEditView?
    var shareView: LikeShareView?
    var toolView: UserInfoToolView?

    var isMyselfFlag = false
    
    var bannerList = [AnyObject]()

    var mUserUuid: String?{
        didSet{
            if mUserUuid != nil &&
                mUserUuid == Global.shared.globalProfile?.userUuid{
                isMyselfFlag = true
            }else{
                isMyselfFlag = false
            }
            deleteButton.isHidden = !isMyselfFlag
        }
    }
    var likeSenderUserUuid: String?
    
    var mProfile: UserProfileData?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.mProfile == nil && self.mUserUuid != nil {
            self.getUserProfile(userUuid: self.mUserUuid!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()            
        setupView()
        if isMyselfFlag{
            self.setNavtionConfirm(imageStr: "icon_setting")
        }
        deleteButton.isHidden = !isMyselfFlag
    }
    
    override func confirmClick() {
        print("confirmClick")

        let pushVC = SettingViewController.init()
        self.navigationController?.pushViewController(pushVC, animated: true)
    }
    
    func configRightBarButtonItem() {
        
        let barView = UIView(frame: CGRect.init(x: 0, y: 0, width: 64, height: 44))
        let imgView = UIImageView.init(image: UIImage(named: "icon_setting"))
        imgView.tintColor = UIColor.blue
        let titleLbl = UILabel()
        titleLbl.text = "设置"
        barView.addSubview(imgView)
        barView.addSubview(titleLbl)
        imgView.snp.makeConstraints({ (make) in
            make.left.equalTo(0)
            make.centerY.equalTo(barView.snp.centerY)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        })
        titleLbl.snp.makeConstraints({ (make) in
            make.left.equalTo(imgView.snp.right).offset(8)
            make.centerY.equalTo(barView.snp.centerY)
        })
        let button = UIButton(type: .custom)
        barView.addSubview(button)
        button.addTarget(self, action: #selector(confirmClick), for: .touchUpInside)
        button.snp.makeConstraints({ (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        })
        
        let barItem = UIBarButtonItem.init(customView: barView)
        self.navigationItem.rightBarButtonItem = barItem
    }
    
    func setupView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        scrollView.addSubview(container)
        container.snp.makeConstraints { (make) in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        let w = UIScreen.main.bounds.width
        let h = w

        bannerView = SDCycleScrollView.init(frame: CGRect.init(x: 0, y: 64, width: w, height: h), delegate: self, placeholderImage: nil)
        bannerView?.bannerImageViewContentMode = .scaleAspectFill
        bannerView?.pageControlAliment = SDCycleScrollViewPageContolAlimentLeft
        bannerView?.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated
        bannerView?.pageControlDotSize = CGSize.init(width: 8, height: 8)
        bannerView?.pageControlBottomOffset = h - 30
        container.addSubview(bannerView!)
        bannerView?.delegate = self
        bannerView?.autoScroll = false
        refreshBannerView()
        
        bannerView?.snp.makeConstraints({ (make) in
            make.left.top.right.equalTo(0)
            make.height.equalTo((bannerView?.snp.width)!)
        })
        
        deleteButton.setImage(UIImage.init(named: "trash-can"), for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonClick), for: .touchUpInside)
        container.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { (make) in
            make.top.right.equalTo(0)
            make.size.equalTo(CGSize.init(width: 46, height: 52))
        }
        

        if isMyselfFlag {
            shareView = LikeShareView()
            shareView?.setActionInfoValue(temClosure: { 
                let pushVC = LikeUsersViewController()
                pushVC.isLikeMeUsers = true
                let userUuid = Global.shared.globalProfile?.uuid
                pushVC.likeSenderUserUuid = userUuid
                self.navigationController?.pushViewController(pushVC, animated: true)
            })
            container.addSubview(shareView!)
            if mProfile != nil{
                shareView?.configLikeLabel(count: (mProfile?.likesCount)!)
            }
            shareView?.snp.makeConstraints({ (make) in
                make.left.right.equalTo(0)
                make.top.equalTo(bannerView!.snp.bottom)
                make.height.equalTo(52)
            })
        } else{
            toolView = UserInfoToolView()
            toolView?.chatButton.addTarget(self, action:#selector(chatButtonClick), for: .touchUpInside)
            toolView?.likeButton.addTarget(self, action:#selector(likeButtonClick), for: .touchUpInside)
            
            container.addSubview(toolView!)
            toolView?.snp.makeConstraints({ (make) in
                make.left.right.equalTo(0)
                make.top.equalTo(bannerView!.snp.bottom).offset(-22)
                make.height.equalTo(44)
            })
        }
        configUserInfoView()
    }
    
    func configUserInfoView() {
        
        container.addSubview(infoView)
        toolView?.bringSubview(toFront: infoView)
        
        infoView.setUserEntity(isMyself: isMyselfFlag)
        infoView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            if shareView == nil{
                make.top.equalTo(bannerView!.snp.bottom).offset(19)
            }else{
                make.top.equalTo(shareView!.snp.bottom)
            }
//            make.height.equalTo(180)
        }
        if self.mProfile != nil{
            infoView.configViewWihObject(userObj: mProfile!)
        }
        infoView.setEditUserInfoValue {
            self.configEditUserInfoView()
        }
        
        container.snp.makeConstraints { (make) in
            make.bottom.equalTo(infoView.snp.bottom).offset(10)
        }
    }
    
    func configEditUserInfoView() {
        self.infoView.isHidden = true

        if (self.editView != nil) {
            self.editView?.isHidden = false
            if self.mProfile != nil{
                editView!.configViewWihObject(userObj: self.mProfile!)
            }
            container.snp.remakeConstraints { (make) in
                make.edges.equalTo(scrollView)
                make.width.equalTo(scrollView)
                make.bottom.equalTo(editView!.snp.bottom).offset(10)
            }
            
            return
        }
        
        self.editView = UserInfoEditView()
        editView?.showVC = self
        container.addSubview(editView!)
        if self.mProfile != nil{
            editView!.configViewWihObject(userObj: self.mProfile!)
        }

        editView!.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            if shareView == nil{
                make.top.equalTo(bannerView!.snp.bottom)
            }else{
                make.top.equalTo(shareView!.snp.bottom)
            }
//            make.height.equalTo(380)
        }
        container.snp.remakeConstraints { (make) in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
            make.bottom.equalTo(editView!.snp.bottom).offset(10)
        }
        
        editView?.setDoneUserInfoValue(temClosure: { (_ editUserObj) in
            self.updateProfile(editProfile: editUserObj)
        })
    }
    
    //MARK:- Network
    
    func getUserProfile(userUuid: String) {
        let engine = NetworkEngine()
        if !isMyselfFlag{
            HUD.show(.labeledProgress(title: nil, subtitle: nil))
        }
        engine.getUserProfile(userUuid: userUuid) { (profile) in
            HUD.hide()
            if profile?.status == ResponseError.SUCCESS.0 {
                if (profile?.data) != nil{
                    self.mProfile = profile?.data
                    if self.isMyselfFlag{
                        Global.shared.globalProfile = profile?.data
                        self.shareView?.configLikeLabel(count: (profile?.data?.likesCount)!)
                    }else{
                        self.toolView?.refreshLikeButtonStatus(isLike: (profile?.data?.currentVisitorLiked)!)
                    }
                    let list = profile?.data?.getBannerAvatarList(isMyself: self.isMyselfFlag)
                    for string in list!{
                        self.bannerList.append(string as AnyObject)
                    }
                    self.refreshBannerView()
                    if let tmpProfile = profile{
                        self.navigationItem.title = profile?.data?.nickname
                        self.infoView.configViewWihObject(userObj: (tmpProfile.data)!)
                    }
                }else{
                    SGLog(message: "返回的数据为空")
                }
            }else{
                HUD.flash(.label(profile?.msg), delay: 2)
            }
        }
    }
    
    func updateProfile(editProfile: UserProfileData)  {
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        engine.postUserProfile(nickname: editProfile.nickname!, sex: editProfile.sex!, birthdate: editProfile.birthdate!, university: editProfile.university!, personalProfile: editProfile.personalProfile!) { (userProfile) in
            HUD.hide()
            self.container.snp.remakeConstraints { (make) in
                make.edges.equalTo(self.scrollView)
                make.width.equalTo(self.scrollView)
                make.bottom.equalTo(self.infoView.snp.bottom).offset(10)
            }
            
            if userProfile?.status == ResponseError.SUCCESS.0 {
                self.mProfile = editProfile
                editProfile.caheForUserProfile()
                if self.mProfile != nil {
                    self.infoView.configViewWihObject(userObj: self.mProfile!)
                }
                self.editView?.isHidden = true
                self.infoView.isHidden = false
                self.shareView?.isHidden = false
                
            }else{
                HUD.flash(.label(userProfile?.msg), delay: 2)
            }
        }
    }
    
    func likeSomeBody()  {
        
        self.mProfile?.currentVisitorLiked = !(self.mProfile?.currentVisitorLiked)!
        self.toolView?.refreshLikeButtonStatus(isLike: (self.mProfile?.currentVisitorLiked)!)
        
        let engine = NetworkEngine()
        let likeUuid = self.mProfile?.uuid
        
        engine.post_likeProfile(userProfileUuid: likeUuid) { (response) in
            if response?.status == ResponseError.SUCCESS.0 {
                
            }else{
                HUD.flash(.label(response?.msg), delay: 2)
            }
        }
    }
    
    func deletePhoto(at: Int) {
        if at < (bannerList.count - 1) && at > 0 {
            bannerList[at ..< at + 1] = [DefaultBannerImgName as AnyObject]
            refreshBannerView()
        }
        
        let obj = self.bannerList[at]
        if obj is String {
            let imgName = obj as! String
            if imgName == DefaultBannerImgName
                && at > ((self.mProfile?.userPhotoList?.count)! - 1){
                SGLog(message: "越界")
                return
            }
        }
        
        let userPhoto = self.mProfile?.userPhotoList?[at]
        
        let engine = NetworkEngine()
        engine.deleteUserPhoto(photoUuid: (userPhoto?.uuid)!) { (response) in
            if response?.status == ResponseError.SUCCESS.0 {

                self.mProfile?.deleteAvatar(at: at)
                self.mProfile?.caheForUserProfile()
                
                self.bannerList.removeAll()
                let list = self.mProfile?.getBannerAvatarList(isMyself: self.isMyselfFlag)
                for string in list!{
                    self.bannerList.append(string as AnyObject)
                }
                self.refreshBannerView()
                self.bannerView?.scroll(to: Int32((self.mProfile!.userPhotoList?.count)!) - 1)
            }else{
                HUD.flash(.label(response?.msg), delay: 2)
            }
        }
    }
    
    func uploadPhoto(uploadImage: UIImage,at: Int) {
    
        if at < (bannerList.count - 1) && at > 0{
            bannerList[at ..< at + 1] = [uploadImage]
            refreshBannerView()
        }
        
        let engine = NetworkEngine()
        engine.postUserPhoto(image: uploadImage) { (userPhoto) in
            if userPhoto?.status == ResponseError.SUCCESS.0 {
                let newPhoto = UserPhotoList.init()
                newPhoto.profileBigPicUrl = userPhoto?.data?.profileBigPicUrl
                newPhoto.uuid = userPhoto?.data?.uuid
                self.mProfile?.setNewAvatar(newAvatar: newPhoto, at: at)
                self.mProfile?.caheForUserProfile()
                
                self.bannerList.removeAll()
                let list = self.mProfile?.getBannerAvatarList(isMyself: self.isMyselfFlag)
                for string in list!{
                    self.bannerList.append(string as AnyObject)
                }
                self.refreshBannerView()
                self.bannerView?.scroll(to: Int32((self.mProfile!.userPhotoList?.count)!) - 1)
            }else{
                if userPhoto?.status == ResponseError.PROFILE_PIC_NOT_VERIFIED.0{
                    self.bannerList[at ..< at + 1] = [DefaultBannerImgName as AnyObject]
                    self.refreshBannerView()
                }
                HUD.flash(.label(userPhoto?.msg), delay: 2)
            }
        }
    }

    
    //MARK:- Action
    func chatButtonClick() {
        
        
        
        
        SGLog(message: "")
        guard let myProfile = Global.shared.globalProfile,
              let canTalk = Global.shared.globalLogin?.canTalk,
              let otherProfile = self.mProfile,
              let isAcceptPrivateChat =  otherProfile.isAcceptPrivateChat else {
                SGLog(message: "数据不全")
                return
        }
        
        if let viewControllers = navigationController?.viewControllers{
            for VC in viewControllers {
                if VC.isKind(of: SCConversationViewController.self) {
                    let chatVC = VC as! SCConversationViewController
                    if chatVC.conversationType == .ConversationType_PRIVATE &&
                        chatVC.privateUserUuid == otherProfile.userUuid {
                        _ = navigationController?.popToViewController(chatVC, animated: true)
                        SGLog(message: "已有该用户的聊天记录")
                        return
                    }
                }
            }
        }
        
        if otherProfile.userUuid == myProfile.userUuid {
            HUD.flash(.label("自己不能和自己聊天哦~"), delay: 2)
            return
        }
        
        if !canTalk {
            HUD.flash(.label("请设置您的个人资料第一张是真人照片~"), delay: 2)
            return
        }
        
        if !isAcceptPrivateChat {
            HUD.flash(.label("对方未开启一对一私聊"), delay: 2)
            return
        }
        
        let userUuidA = myProfile.userUuid
        let userUuidB = otherProfile.userUuid
        
        self.postPrivateChat(nameA: Global.shared.globalProfile?.nickname, nameB: otherProfile.nickname, userUuidA: userUuidA, userUuidB: userUuidB)
    }
    
    func likeButtonClick() {
        SGLog(message: "")
        self.likeSomeBody()
    }
    
    func deleteButtonClick() {
        let at = self.bannerView?.currentPage()
        
        let obj = self.bannerList[at!]
        if obj is String {
            if (self.mProfile?.userPhotoList?.count)! <= 1{
                HUD.flash(.label("至少要有一张照片"), delay: 2)
                return
            }
            
            let imgName = obj as! String
            if imgName == DefaultBannerImgName
            && at! > ((self.mProfile?.userPhotoList?.count)! - 1){
                SGLog(message: "越界")
                return
            }
        }
        
        
        let alertController = UIAlertController(title: "您确定要删除这张图片？", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler:nil)
        let okAction = UIAlertAction(title: "确定", style: .default, handler:{ (action) in
            self.deletePhoto(at: at!)
        })
        okAction.setValue(SGColor.SGMainColor(), forKey: "_titleTextColor")
        cancelAction.setValue(SGColor.black, forKey: "_titleTextColor")
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        if isMyselfFlag == false {
            return
        }
        let titleStr = "选择头像"
        let obj = cycleScrollView.localizationImageNamesGroup[index]  as AnyObject
        
        if obj.isMember(of: UIImage.self) {
            let browser = ImageScrollViewController()
            browser.disPlay(image: obj as! UIImage)
            browser.isShowLikeButton(isShow: false)
            browser.isShowDeleteButton(isShow: false)
            self.present(browser, animated: true, completion: nil)
            return
        }
        
//        if obj.isMember(of: String.self) {
//            return
//        }
        
        let avatar = (cycleScrollView.localizationImageNamesGroup[index] as! String)
        
        if avatar.hasPrefix("http://") ||
            avatar.hasPrefix("https://") {
            let browser = ImageScrollViewController()
            browser.disPlay(imageUrl: avatar)
            self.present(browser, animated: true, completion: nil)
            browser.isShowLikeButton(isShow: false)
            browser.isShowDeleteButton(isShow: false)
            return
        }
        UIAlertController.photoPicker(withTitle: titleStr, showIn: self.view, presentVC: self, onPhotoPicked: { (avatar) in
            self.uploadPhoto(uploadImage: avatar!, at: index)
        }, onCancel:{
        }, allowsEditing: true)
    }
    
    func refreshBannerView() {
        bannerView?.localizationImageNamesGroup = bannerList
    }
}

private extension UserInfoViewController {
    
    func setupPullToRefresh() {
        scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.getUserProfile(userUuid: self.mUserUuid!)
        })
        scrollView.mj_header.isAutomaticallyChangeAlpha = true
    }
}
