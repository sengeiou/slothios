//
//  BrowseAdvertViewController.swift
//  SlothChat
//
//  Created by Fly on 16/10/23.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import Kingfisher

class BrowseAdvertViewController: BaseViewController,MWPhotoBrowserDelegate {
    let scrollView = UIScrollView()
    let container = UIView()
    
    let mainImgView = UIImageView()
    let usersListView = LikeUsersView()
    let contentLabel = UILabel()

    var isFollow = false
    var userObj: UserObj?
    var photoList = [MWPhoto]()
    
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
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapMainImgView))
        mainImgView.addGestureRecognizer(tap)
        
        mainImgView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.height.equalTo((w * 288.0) / 375.0)
        }
        usersListView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(mainImgView.snp.bottom)
            make.height.equalTo(124)
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
    
    func configWithObject(user: UserObj?) {
        SGLog(message: user)
        if user == nil{
            return
        }
        self.userObj = user
        
        let mainImgUrl = URL(string: (user!.avatarList?.first)!)
        self.mainImgView.kf.setImage(with: mainImgUrl, placeholder: UIImage.init(named: "icon"), options: nil, progressBlock: nil, completionHandler: nil)
        
        usersListView.configViewWithObject(avatarList: user!.avatarList)
        
        let string1 = "这是一个广告\n\n"
        let string2 = "您在发照片时，可以通过选择是否参与f付费竞价，以赢得此广告位。\n竞价结果每周公布一次，如果您竞价成功，可获得该广告位一星期"
        
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        
        let attributedText = NSMutableAttributedString.init(string: string1 + string2)
        let range = NSRange.init(location: 0, length: string1.characters.count)
        attributedText.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 17), range: range)
        self.contentLabel.attributedText = attributedText
    }
    
    //MARK:- Action

    override func confirmClick() {
        SGLog(message: "")
        isFollow = !isFollow
        configNavigationRightItem()
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
        let photoUrl = URL.init(string: (self.userObj!.avatarList?.first)!)
        let photo = MWPhoto(url: photoUrl)
        
        photoList.append(photo!)
        
        let browser = MWPhotoBrowser(delegate: self)
        self.navigationController?.pushViewController(browser!, animated: true)
        
    }
    
    func numberOfPhotos(in photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(photoList.count)
    }
    
    func photoBrowser(_ photoBrowser: MWPhotoBrowser!, photoAt index: UInt) -> MWPhotoProtocol! {
        if (index < UInt(photoList.count)) {
            return photoList[Int(index)]
        }
        return nil;
    }
}
