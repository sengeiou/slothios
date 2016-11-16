//
//  ChatGroupInfoCell.swift
//  SlothChat
//
//  Created by Fly on 16/11/15.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class ChatGroupInfoCell: UITableViewCell {

    let titleLabel = UILabel()
    
    let avatarImgView = UIImageView()
    let nameLabel = UILabel()
    let removeButton = UIButton()
    
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
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(avatarImgView)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(removeButton)
        
        titleLabel.text = "群成员"
        titleLabel.textColor = SGColor.SGTextColor()
        titleLabel.isHidden = true
        
        avatarImgView.layer.cornerRadius = 20
        avatarImgView.layer.masksToBounds = true
        avatarImgView.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.size.equalTo(CGSize.init(width: 40, height: 40))
        }
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImgView.snp.right).offset(18)
            make.right.lessThanOrEqualTo(-68)
            make.centerY.equalTo(self.contentView.snp.centerY)
        }
        removeButton.setTitle("移除", for: .normal)
        removeButton.setTitleColor(SGColor.SGMainColor(), for: .normal)
        removeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        removeButton.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.top.bottom.equalTo(0)
            make.width.equalTo(60)
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
