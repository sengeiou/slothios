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
        
        avatarImgView.layer.cornerRadius = 21
        avatarImgView.layer.masksToBounds = true
        avatarImgView.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.size.equalTo(CGSize.init(width: 42, height: 42))
        }
        flagImgView.snp.makeConstraints { (make) in
            make.right.equalTo(-8)
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImgView.snp.right).offset(16)
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.right.lessThanOrEqualTo(-60)
        }
    }
    
    func configCellWithObj(userObj: RCUserInfo) {
        let avatarUrl = URL(string: userObj.portraitUri)
        
        self.avatarImgView.sd_setImage(with: avatarUrl, placeholderImage: UIImage(named: "icon"))
        self.nameLabel.text = userObj.name
    }
    
    func configCellWithObj(memberInfo: ChatMemberInfo) {
        let avatarUrl = URL(string: memberInfo.profilePicUrl!)
        self.avatarImgView.sd_setImage(with: avatarUrl, placeholderImage: UIImage(named: "icon"))
        
        self.nameLabel.text = memberInfo.userDisplayName
    }
    
    func configFlagView(selected: Bool) {
        if !selected {
            flagImgView.image = UIImage(named: "button-uncheck")
        }else{
            flagImgView.image = UIImage(named: "button-checked")
        }
    }
    
    func configCellWithObj(groupObj: RCGroup) {
        let avatarUrl = URL(string: groupObj.portraitUri)
        self.avatarImgView.sd_setImage(with: avatarUrl, placeholderImage: UIImage(named: "icon"))
        
        self.nameLabel.text = groupObj.groupName
    }
    

}
