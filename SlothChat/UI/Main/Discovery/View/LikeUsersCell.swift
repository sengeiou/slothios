//
//  LikeUsersCell.swift
//  SlothChat
//
//  Created by Fly on 16/10/22.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import Kingfisher

class LikeUsersCell: UITableViewCell {
    
    let avatarImgView = UIImageView()
    let nameLabel = UILabel()
    let lookButton = UIButton(type: .custom)
    
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
        self.contentView.addSubview(lookButton)
        
        avatarImgView.layer.cornerRadius = 18
        avatarImgView.layer.masksToBounds = true
        avatarImgView.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.size.equalTo(CGSize.init(width: 36, height: 36))
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImgView.snp.right).offset(20)
            make.centerY.equalTo(self.contentView.snp.centerY)
        }
        lookButton.setTitle("查看", for: .normal)
        lookButton.setTitleColor(SGColor.SGMainColor(), for: .normal)
        lookButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        lookButton.addTarget(self, action: #selector(lookButtonClick), for: .touchUpInside)
        lookButton.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.width.equalTo(60)
            make.top.bottom.equalTo(0)
        }
    }
    
    func configCellWithObj(userObj: UserObj) {
        let avatarUrl = URL(string: (userObj.avatarList?.first)!)
        self.avatarImgView.kf.setImage(with: avatarUrl, placeholder: UIImage.init(named: "icon"), options: nil, progressBlock: nil, completionHandler: nil)
        self.nameLabel.text = userObj.name
    }
    
    func lookButtonClick() {
        
    }
}
