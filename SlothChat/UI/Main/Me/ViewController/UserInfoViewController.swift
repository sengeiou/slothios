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
    
    var bannerView: SDCycleScrollView?
    var editView: UserInfoEditView?
    var shareView: LikeShareView?
    var toolView: UserInfoToolView?

    var isMyselfFlag = false
    
    var mUserUuid: String?{
        didSet{
            if mUserUuid != nil &&
                mUserUuid == Global.shared.globalProfile?.userUuid{
                isMyselfFlag = true
            }else{
                isMyselfFlag = false
            }
        }
    }
    var likeSenderUserUuid: String?
    
    var mProfile: UserProfileData?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.mProfile == nil && self.mUserUuid != nil {
            if isMyselfFlag{
                let userUuid = Global.shared.globalLogin?.user?.uuid
                self.getUserProfile(userUuid: userUuid!)
            }else{
                self.getUserProfile(userUuid: self.mUserUuid!)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()            
        setupView()
        if isMyselfFlag{
            self.setNavtionConfirm(titleStr: "设置")
        }
    }
    
    override func confirmClick() {
        print("confirmClick")

        let pushVC = SettingViewController.init()
        self.navigationController?.pushViewController(pushVC, animated: true)
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
//        let h = (w * 156.0 / 187.0)
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
        
        let deleteButton = UIButton(type: .custom)
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
        engine.getUserProfile(userUuid: userUuid,likeSenderUserUuid: likeSenderUserUuid) { (profile) in
            HUD.hide()
            if profile?.status == ResponseError.SUCCESS.0 {
                self.mProfile = profile?.data
                if self.isMyselfFlag{
                    Global.shared.globalProfile = profile?.data
                    self.shareView?.configLikeLabel(count: (profile?.data?.likesCount)!)

                }else{
                }
                self.refreshBannerView()
                if let tmpProfile = profile{
                    self.infoView.configViewWihObject(userObj: (tmpProfile.data)!)
                }

            }else{
                HUD.flash(.label(profile?.msg), delay: 2)
            }
        }
    }
    
    func updateProfile(editProfile: UserProfileData)  {
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        engine.postUserProfile(nickname: editProfile.nickname!, sex: editProfile.sex!, birthdate: editProfile.birthdate!, area: editProfile.area!, commonCities: editProfile.commonCities!, university: editProfile.university!) { (userProfile) in
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
                HUD.flash(.label("更新失败"), delay: 2)
            } 
        }
    }
    
    func likeSomeBody()  {
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
//        let uuid = Global.shared.globalProfile?.userUuid
        let likeUuid = self.mUserUuid
        
        engine.post_likeProfile(likeSenderUserUuid:likeUuid) { (response) in
            HUD.hide()
            if response?.status == ResponseError.SUCCESS.0 {
                HUD.flash(.label("谢谢您哦~"), delay: 2)

            }else{
                HUD.flash(.label(response?.msg), delay: 2)
            }
        }
    }
    
    func deletePhoto(at: Int) {

        let userPhoto = self.mProfile?.userPhotoList?[at]
        
        let engine = NetworkEngine()
        
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        engine.deleteUserPhoto(photoUuid: (userPhoto?.uuid)!) { (response) in
            HUD.hide()
            if response?.status == ResponseError.SUCCESS.0 {

                self.mProfile?.deleteAvatar(at: at)
                self.refreshBannerView()
                self.mProfile?.caheForUserProfile()
                
            }else{
                HUD.flash(.label("删除照片失败"), delay: 2)
            }
        }
    }
    
    func uploadPhoto(image: UIImage,at: Int) {
        
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        engine.postUserPhoto(image: image) { (userPhoto) in
            HUD.hide()
            if userPhoto?.status == ResponseError.SUCCESS.0 {
                let newPhoto = UserPhotoList.init()
                newPhoto.profileBigPicUrl = userPhoto?.data?.profileBigPicUrl
                newPhoto.uuid = userPhoto?.data?.uuid
                self.mProfile?.setNewAvatar(newAvatar: newPhoto, at: at)
                self.mProfile?.caheForUserProfile()
                self.refreshBannerView()

            }else{
                HUD.flash(.label("添加照片失败"), delay: 2)
            }
        }
    }

    
    //MARK:- Action
    func chatButtonClick() {
        SGLog(message: "")
    }
    
    func likeButtonClick() {
        SGLog(message: "")
        self.likeSomeBody()
    }
    
    func deleteButtonClick() {
        let at = self.bannerView?.currentPage()
        if at! > ((self.mProfile?.userPhotoList?.count)! - 1) ||
            at! < 0{
            SGLog(message: "越界")
            return
        }
        
        if (self.mProfile?.userPhotoList?.count)! <= 1{
            HUD.flash(.label("至少要有一张照片"), delay: 2)
            return
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
        var titleStr = "选择头像"
        let avatar = (cycleScrollView.localizationImageNamesGroup[index] as! String)
        
        if avatar.hasPrefix("http://") ||
            avatar.hasPrefix("https://") {
            titleStr = "替换头像"
        }
        UIAlertController.photoPicker(withTitle: titleStr, showIn: self.view, presentVC: self, onPhotoPicked: { (avatar) in
                self.uploadPhoto(image: avatar!, at: index)
            }, onCancel:{
            }, allowsEditing: true)
    }
    
    func refreshBannerView() {
        let imagesURLStrings = self.mProfile?.getBannerAvatarList(isMyself: isMyselfFlag)
        bannerView?.localizationImageNamesGroup = imagesURLStrings
    }
}
