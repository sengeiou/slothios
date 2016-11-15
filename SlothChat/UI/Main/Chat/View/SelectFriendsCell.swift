//
//  SelectFriendsCell.swift
//  SlothChat
//
//  Created by fly on 2016/11/13.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class SelectFriendsCell: UITableViewCell {

    let avatarImgView = UIImageView()
    let nameLabel = UILabel()
    let flagImgView = UIImageView()

    var indexPath: IndexPath?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        sentupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func sentupView() {
        self.contentView.addSubview(avatarImgView)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(flagImgView)
        configFlagView(selected: false)
        
        avatarImgView.layer.cornerRadius = 20
        avatarImgView.layer.masksToBounds = true
        avatarImgView.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.size.equalTo(CGSize.init(width: 40, height: 40))
        }
        flagImgView.snp.makeConstraints { (make) in
            make.right.equalTo(-8)
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImgView.snp.right).offset(18)
            make.centerY.equalTo(self.contentView.snp.centerY)
        }
    }
    
    func configCellWithObj(userObj: RCUserInfo) {
        let avatarUrl = URL(string: userObj.portraitUri)
        self.avatarImgView.kf.setImage(with: avatarUrl, placeholder: UIImage(named: "icon"), options: nil, progressBlock: nil, completionHandler: nil)
        self.nameLabel.text = userObj.name
    }
    
    func configFlagView(selected: Bool) {
        if !selected {
            flagImgView.image = UIImage(named: "chat-gray")
        }else{
            flagImgView.image = UIImage(named: "chat-champagne")
        }
    }
    
    func configCellWithObj(groupObj: RCGroup) {
        let avatarUrl = URL(string: groupObj.portraitUri)
        self.avatarImgView.kf.setImage(with: avatarUrl, placeholder: UIImage(named: "icon"), options: nil, progressBlock: nil, completionHandler: nil)
        
        self.nameLabel.text = groupObj.groupName
    }

}