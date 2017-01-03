//
//  ChatGroupInfoCell.swift
//  SlothChat
//
//  Created by Fly on 16/11/15.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import SDWebImage

typealias RemoveMemberClosureType = (_ indexPatch: IndexPath) -> Void

class ChatGroupInfoCell: UITableViewCell {

    let titleLabel = UILabel()
    
    let avatarImgView = UIImageView()
    let nameLabel = UILabel()
    let removeButton = UIButton()
    
    var indexPath: IndexPath?
    var selectPassValue: RemoveMemberClosureType?

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
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.isHidden = true
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalTo(self.contentView.snp.centerY)
        }

        avatarImgView.layer.cornerRadius = 21
        avatarImgView.layer.masksToBounds = true
        avatarImgView.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.size.equalTo(CGSize.init(width: 42, height: 42))
        }
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImgView.snp.right).offset(20)
            make.right.lessThanOrEqualTo(-68)
            make.centerY.equalTo(self.contentView.snp.centerY)
        }
        removeButton.setTitle("移除", for: .normal)
        removeButton.setTitleColor(SGColor.SGMainColor(), for: .normal)
        removeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        removeButton.addTarget(self, action: #selector(removeButtonClick), for: .touchUpInside)
        removeButton.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.top.bottom.equalTo(0)
            make.width.equalTo(60)
        }
        
    }
    
    func setClosurePass(temClosure: @escaping RemoveMemberClosureType){
        self.selectPassValue = temClosure
    }

    func configCellWithObj(userObj: ChatMemberInfo) {
        let avatarUrl = URL(string: userObj.profilePicUrl!)
        
        self.avatarImgView.sd_setImage(with: avatarUrl, placeholderImage: UIImage(named: "icon"))
        if userObj.isAdmin!{
            self.nameLabel.text = userObj.userDisplayName! + " (群主)"
            removeButton.isHidden = true
        }else{
            self.nameLabel.text = userObj.userDisplayName
            removeButton.isHidden = false
        }
    }
    
    func configCellWithObj(groupObj: RCGroup) {
        let avatarUrl = URL(string: groupObj.portraitUri)
        
        self.avatarImgView.sd_setImage(with: avatarUrl, placeholderImage: UIImage(named: "icon"))
        self.nameLabel.text = groupObj.groupName
    }
    
    func removeButtonClick() {
        guard let sp = self.selectPassValue,
              let indexPath = self.indexPath else {
            return
        }
        sp(indexPath)
    }

}
