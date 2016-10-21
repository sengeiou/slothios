//
//  MeViewController.swift
//  SlothChat
//
//  Created by fly on 16/10/17.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

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
    var userObj = UserObj.UserInfoFromCache()
    
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
            make.height.equalTo(330)
        }
        if self.userObj != nil{
            infoView.configViewWihObject(userObj: self.userObj!)
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
            if self.userObj != nil{
                editView!.configViewWihObject(userObj: self.userObj!)
            }
            return
        }
        self.infoView.isHidden = true
        
        self.editView = UserInfoEditView()
        editView?.showVC = self
        container.addSubview(editView!)
        if self.userObj != nil{
            editView!.configViewWihObject(userObj: self.userObj!)
        }

        editView!.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            if shareView == nil{
                make.top.equalTo(bannerView!.snp.bottom)
            }else{
                make.top.equalTo(shareView!.snp.bottom)
            }
            make.height.equalTo(330)
        }
        container.snp.makeConstraints { (make) in
            make.bottom.equalTo(editView!.snp.bottom)
        }
        
        editView?.setDoneUserInfoValue(temClosure: { (_ editUserObj) in
            self.userObj = editUserObj
            editUserObj.caheForUserInfo()
            if self.userObj != nil {
                self.infoView.configViewWihObject(userObj: self.userObj!)
            }
            self.editView?.isHidden = true
            self.infoView.isHidden = false
            self.shareView?.isHidden = false
        })
    }
    
    //MARK:- Action
    func chatButtonClick() {
        SGLog(message: "")
    }
    
    func likeButtonClick() {
        SGLog(message: "")
    }
    
    func deleteButtonClick() {
        let page = bannerView?.currentPage()
        SGLog(message: page)
        self.userObj?.deleteAvatar(at: page!)
        self.refreshBannerView()
        self.userObj?.caheForUserInfo()
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
            cycleScrollView.play()
            self.userObj?.setNewAvatar(newAvatar: "http://e.hiphotos.baidu.com/zhidao/pic/item/3b292df5e0fe992580c7009035a85edf8cb17122.jpg",at: index)
            self.userObj?.caheForUserInfo()
            
            self.refreshBannerView()
//            self.selectedAvatar = avatar
//            self.avatarButton.setImage(avatar, for: .normal)
            }, onCancel:{
                cycleScrollView.play()
            }, allowsEditing: true)
    }
    
    func refreshBannerView() {
        let imagesURLStrings = self.userObj?.getBannerAvatarList()
        bannerView?.localizationImageNamesGroup = imagesURLStrings
    }
}
