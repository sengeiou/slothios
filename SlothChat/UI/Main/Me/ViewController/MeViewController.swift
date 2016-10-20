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
        
        let imagesURLStrings = [
            "https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
             "https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
              "http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
        ]
        
        let w = UIScreen.main.bounds.width
        bannerView = SDCycleScrollView.init(frame: CGRect.init(x: 0, y: 64, width: w, height: 180), delegate: self, placeholderImage: nil)
        bannerView?.infiniteLoop = true
        bannerView?.pageControlAliment = SDCycleScrollViewPageContolAlimentLeft
        bannerView?.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated
        bannerView?.pageControlDotSize = CGSize.init(width: 12, height: 12)
        bannerView?.pageControlBottomOffset = 150
        bannerView?.localizationImageNamesGroup = imagesURLStrings
        container.addSubview(bannerView!)
        
        bannerView?.snp.makeConstraints({ (make) in
            make.left.top.right.equalTo(0)
            make.height.equalTo(180)
        })

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
        }
        infoView.configViewWihObject(userObj: "" as NSObject)
        
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
            self.shareView?.isHidden = true
            editView!.configViewWihObject(userObj: "" as NSObject)
            return
        }
        self.shareView?.isHidden = true
        self.infoView.isHidden = true
        
        self.editView = UserInfoEditView()
        editView?.showVC = self
        container.addSubview(editView!)
        editView!.configViewWihObject(userObj: "" as NSObject)

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
        
        editView!.setDoneUserInfoValue {
            self.editView?.isHidden = true
            self.infoView.isHidden = false
            self.shareView?.isHidden = false
            self.container.snp.makeConstraints { (make) in
                make.bottom.equalTo(self.infoView.snp.bottom)
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
    
    

}
