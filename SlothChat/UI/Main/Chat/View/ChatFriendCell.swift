//
//  ChatFriendCell.swift
//  SlothChat
//
//  Created by fly on 2016/11/12.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class ChatFriendCell: UITableViewCell {

    let avatarImgView = UIImageView()
    let nameLabel = UILabel()
    
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
        
        avatarImgView.layer.cornerRadius = 20
        avatarImgView.layer.masksToBounds = true
        avatarImgView.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.size.equalTo(CGSize.init(width: 40, height: 40))
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

    func configCellWithObj(groupObj: RCGroup) {
        let avatarUrl = URL(string: groupObj.portraitUri)
        self.avatarImgView.kf.setImage(with: avatarUrl, placeholder: UIImage(named: "icon"), options: nil, progressBlock: nil, completionHandler: nil)
        
        self.nameLabel.text = groupObj.groupName
    }
}
