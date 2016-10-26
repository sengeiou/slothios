//
//  MeViewController.swift
//  SlothChat
//
//  Created by fly on 16/10/17.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import PKHUD

class MeViewController: BaseViewController,SDCycleScrollViewDelegate {
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
                mUserUuid == Global.shared.globalLogin?.user?.uuid{
                isMyselfFlag = true
            }
        }
    }
    var mProfile: UserProfileData?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.mProfile == nil && self.mUserUuid != nil {
            self.getUserProfile(userUuid: self.mUserUuid!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我"
            
        self.setNavtionConfirm(titleStr: "设置")
//        isMyselfFlag = true

        if isMyselfFlag{
            let userUuid = Global.shared.globalLogin?.user?.uuid
            mProfile = Global.shared.globalProfile
            self.getUserProfile(userUuid: userUuid!)
        }else{
            let userUuid = Global.shared.globalLogin?.user?.uuid
            self.getUserProfile(userUuid: userUuid!)
        }
        setupView()
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
        let h = (w * 156.0 / 187.0)
        
        bannerView = SDCycleScrollView.init(frame: CGRect.init(x: 0, y: 64, width: w, height: h), delegate: self, placeholderImage: nil)
        bannerView?.pageControlAliment = SDCycleScrollViewPageContolAlimentLeft
        bannerView?.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated
        bannerView?.pageControlDotSize = CGSize.init(width: 8, height: 8)
        bannerView?.pageControlBottomOffset = 150
        container.addSubview(bannerView!)
        bannerView?.delegate = self
        
        refreshBannerView()
        
        bannerView?.snp.makeConstraints({ (make) in
            make.left.top.right.equalTo(0)
            make.height.equalTo(180)
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
                make.top.equalTo(bannerView!.snp.bottom).offset(12)
            }else{
                make.top.equalTo(shareView!.snp.bottom)
            }
            make.height.equalTo(380)
        }
        if self.mProfile != nil{
            infoView.configViewWihObject(userObj: mProfile!)
        }
        infoView.setEditUserInfoValue {
            self.configEditUserInfoView()
        }
        
        container.snp.makeConstraints { (make) in
            make.bottom.equalTo(infoView.snp.bottom)
        }
    }
    
    func configEditUserInfoView() {
        if (self.editView != nil) {
            self.editView?.isHidden = false
            self.infoView.isHidden = true
            if self.mProfile != nil{
                editView!.configViewWihObject(userObj: self.mProfile!)
            }
            return
        }
        self.infoView.isHidden = true
        
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
            make.height.equalTo(380)
        }
        container.snp.makeConstraints { (make) in
            make.bottom.equalTo(editView!.snp.bottom)
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
            if !self.isMyselfFlag{
                HUD.hide()
            }
            if profile?.status == ResponseError.SUCCESS.0 {
                self.mProfile = profile?.data
                if self.isMyselfFlag{
                    Global.shared.globalProfile = profile?.data
                    self.shareView?.configLikeLabel(count: (profile?.data?.likesCount)!)

                }else{
                }
                self.infoView.configViewWihObject(userObj: (profile?.data)!);

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
        let uuid = Global.shared.globalProfile?.userUuid
        
        engine.putUserProfileLike(uuid: uuid!) { (response) in
            HUD.hide()
            if response?.status == ResponseError.SUCCESS.0 {
                
            }else{
                HUD.flash(.label(response?.msg), delay: 2)
            }
        }
    }
    
    func deletePhoto(at: Int) {
        self.bannerView?.pause()

        let userPhoto = self.mProfile?.userPhotoList?[at]
        
        let engine = NetworkEngine()
        
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        engine.deleteUserPhoto(photoUuid: (userPhoto?.uuid)!) { (response) in
            HUD.hide()
            self.bannerView?.play()
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
        self.bannerView?.pause()
        
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        engine.postUserPhoto(image: image) { (userPhoto) in
            HUD.hide()
            if userPhoto?.status == ResponseError.SUCCESS.0 {
                let newPhoto = UserPhotoList.init()
                newPhoto.profilePicUrl = userPhoto?.data?.profilePicUrl
                newPhoto.uuid = userPhoto?.data?.uuid
                self.mProfile?.setNewAvatar(newAvatar: newPhoto, at: at)
                self.mProfile?.caheForUserProfile()
                self.refreshBannerView()

            }else{
                HUD.flash(.label("添加照片失败"), delay: 2)
            }
            self.bannerView?.play()
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
        let at = bannerView?.currentPage()
        self.deletePhoto(at: at!)
    }
    
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        cycleScrollView.pause()
        var titleStr = "选择头像"
        let avatar = (cycleScrollView.localizationImageNamesGroup[index] as! String)
        
        if avatar.hasPrefix("http://") ||
            avatar.hasPrefix("https://") {
            titleStr = "替换头像"
        }
        UIActionSheet.photoPicker(withTitle: titleStr, showIn: self.view, presentVC: self, onPhotoPicked: { (avatar) in
                self.uploadPhoto(image: avatar!, at: index)
            }, onCancel:{
                cycleScrollView.play()
            }, allowsEditing: true)
    }
    
    func refreshBannerView() {
        let imagesURLStrings = self.mProfile?.getBannerAvatarList()
        bannerView?.localizationImageNamesGroup = imagesURLStrings
    }
}
