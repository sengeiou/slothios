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

    var isMyself = false
    var profile = Global.shared.globalProfile
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我"
            
        self.setNavtionConfirm(titleStr: "设置")
        isMyself = true
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
        bannerView = SDCycleScrollView.init(frame: CGRect.init(x: 0, y: 64, width: w, height: 180), delegate: self, placeholderImage: nil)
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
        

        if isMyself {
            shareView = LikeShareView()
            container.addSubview(shareView!)
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
        
        infoView.setUserEntity(isMyself: isMyself)
        infoView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            if shareView == nil{
                make.top.equalTo(bannerView!.snp.bottom).offset(12)
            }else{
                make.top.equalTo(shareView!.snp.bottom)
            }
            make.height.equalTo(380)
        }
        if self.profile != nil{
            infoView.configViewWihObject(userObj: self.profile!)
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
            if self.profile != nil{
                editView!.configViewWihObject(userObj: self.profile!)
            }
            return
        }
        self.infoView.isHidden = true
        
        self.editView = UserInfoEditView()
        editView?.showVC = self
        container.addSubview(editView!)
        if self.profile != nil{
            editView!.configViewWihObject(userObj: self.profile!)
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
    //MARK:- NetWork
    
    func updateProfile(editProfile: UserProfileData)  {
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        engine.postUserProfile(nickname: editProfile.nickname!, sex: editProfile.sex!, birthdate: editProfile.birthdate!, area: editProfile.area!, commonCities: editProfile.commonCities!, university: editProfile.university!) { (userProfile) in
            HUD.hide()
            if userProfile?.status == ResponseError.SUCCESS.0 {
                self.profile = editProfile
                editProfile.caheForUserProfile()
                if self.profile != nil {
                    self.infoView.configViewWihObject(userObj: self.profile!)
                }
                self.editView?.isHidden = true
                self.infoView.isHidden = false
                self.shareView?.isHidden = false
                
            }else{
                HUD.flash(.label("更新失败"), delay: 2)
            } 
        }
    }
    
    func likeSomeBody(editProfile: UserProfileData)  {
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        engine.postUserProfile(nickname: editProfile.nickname!, sex: editProfile.sex!, birthdate: editProfile.birthdate!, area: editProfile.area!, commonCities: editProfile.commonCities!, university: editProfile.university!) { (userProfile) in
            HUD.hide()
            if userProfile?.status == ResponseError.SUCCESS.0 {
                self.profile = editProfile
                editProfile.caheForUserProfile()
                if self.profile != nil {
                    self.infoView.configViewWihObject(userObj: self.profile!)
                }
                self.editView?.isHidden = true
                self.infoView.isHidden = false
                self.shareView?.isHidden = false
                
            }else{
                HUD.flash(.label("更新失败"), delay: 2)
            }
        }
    }
    
    func deletePhoto(at: Int) {
        let userPhoto = self.profile?.userPhotoList?[at]
        
        let engine = NetworkEngine()
        
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        engine.deleteUserPhoto(photoUuid: (userPhoto?.uuid)!) { (response) in
            HUD.hide()
            if response?.status == ResponseError.SUCCESS.0 {

                self.profile?.deleteAvatar(at: at)
                self.refreshBannerView()
                self.profile?.caheForUserProfile()
                
            }else{
                HUD.flash(.label("删除照片失败"), delay: 2)
            }
        }
    }
    
    func uploadPhoto(image: UIImage,at: Int) {
        
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        engine.postUserPhoto(image: image) { (userPhoto) in
            if userPhoto?.status == ResponseError.SUCCESS.0 {
                let newPhoto = UserPhotoList.init()
                self.profile?.setNewAvatar(newAvatar: newPhoto, at: at)
                self.profile?.caheForUserProfile()
                self.refreshBannerView()
                self.bannerView?.play()

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
        let imagesURLStrings = self.profile?.getBannerAvatarList()
        bannerView?.localizationImageNamesGroup = imagesURLStrings
    }
}
