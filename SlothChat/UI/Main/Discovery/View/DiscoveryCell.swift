//
//  HotestCell.swift
//  SlothChat
//
//  Created by Fly on 16/10/22.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import Kingfisher

enum DiscoveryActionType {
    case likeType
    case mainImgType
    case likeUsersType
}
typealias DiscoveryClosureType = (_ actionType: DiscoveryActionType, _ indexPatch: IndexPath) -> Void

class DiscoveryCell: UITableViewCell {
    let avatarImgView = UIImageView()
    let nameLabel = UILabel()
    let locationImgView = UIImageView()
    let locationLabel = UILabel()
    
    let likeButton = UIButton(type: .custom)
    let mainImgView = UIImageView()
    let likeUsersView = LikeUsersView()
    
    var indexPath: IndexPath?

    var selectPassValue: DiscoveryClosureType?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        sentupView()
    }
    
    func sentupView()  {
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        locationLabel.textColor = SGColor.SGLineColor()
        locationLabel.font = UIFont.systemFont(ofSize: 11)
        avatarImgView.layer.cornerRadius = 16
        avatarImgView.layer.masksToBounds = true
        
        self.contentView.addSubview(avatarImgView)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(locationImgView)
        self.contentView.addSubview(locationLabel)
        self.contentView.addSubview(likeButton)
        self.contentView.addSubview(mainImgView)
        self.contentView.addSubview(likeUsersView)
        
        self.addCellAction()
        
        avatarImgView.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.top.equalTo(20)
            make.size.equalTo(CGSize.init(width: 32, height: 32))
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImgView.snp.right).offset(12)
            make.top.equalTo(avatarImgView.snp.top)
            make.right.lessThanOrEqualTo(-44)
        }
        
        locationImgView.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImgView.snp.right).offset(10)
            make.bottom.equalTo(avatarImgView.snp.bottom)
            make.size.equalTo(CGSize.init(width: 8, height: 8))
        }
        
        locationLabel.snp.makeConstraints { (make) in
            make.left.equalTo(locationImgView.snp.right).offset(4)
            make.top.equalTo(locationImgView.snp.top)
            make.right.lessThanOrEqualTo(-44)
        }
        
        likeButton.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.top.equalTo(20)
            make.size.equalTo(CGSize.init(width: 44, height: 44))
        }
        
        mainImgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(avatarImgView.snp.bottom).offset(10)
            make.height.equalTo(150)
        }
        
        likeUsersView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(mainImgView.snp.bottom).offset(4)
            make.height.equalTo(44)
        }
    }
    
    func addCellAction() {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(likeUsersClick))
        likeUsersView.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer.init(target: self, action: #selector(mainImgClick))
        mainImgView.addGestureRecognizer(tap1)
        mainImgView.isUserInteractionEnabled = true
        
        likeButton.addTarget(self, action: #selector(likeButtonClick), for: .touchUpInside)
    }
    
    func configCellWithObj(userObj: DiscoveryUserObj) {
        let avatarUrl = URL(string: userObj.avatar)
        self.avatarImgView.kf.setImage(with: avatarUrl, placeholder: UIImage.init(named: "icon"), options: nil, progressBlock: nil, completionHandler: nil)
    
        let mainImgUrl = URL(string: userObj.mainImgUrl)
        self.mainImgView.kf.setImage(with: mainImgUrl, placeholder: UIImage.init(named: "icon"), options: nil, progressBlock: nil, completionHandler: nil)
        
        self.nameLabel.text = userObj.name
        self.locationLabel.text = userObj.location
        if userObj.isLike {
            likeButton.setImage(UIImage.init(named: ""), for: .normal)
        }else{
            likeButton.setImage(UIImage.init(named: ""), for: .normal)
        }
        likeUsersView.configViewWithObject(userObj: userObj)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Mark: - Action
    
    func likeButtonClick() {
        if let sp = self.selectPassValue {
            sp(.likeType,self.indexPath!)
        }
    }
    
    func setClosurePass(temClosure: @escaping DiscoveryClosureType){
        self.selectPassValue = temClosure
    }
    
    func mainImgClick() {
        if let sp = self.selectPassValue {
            sp(.mainImgType,self.indexPath!)
        }
    }
    
    func likeUsersClick() {
        if let sp = self.selectPassValue {
            sp(.likeUsersType,self.indexPath!)
        }
    }
    
}
