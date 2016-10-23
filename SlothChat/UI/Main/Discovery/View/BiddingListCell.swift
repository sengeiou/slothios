//
//  BiddingListCell.swift
//  SlothChat
//
//  Created by Fly on 16/10/23.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import Kingfisher

class BiddingListCell: UITableViewCell {
    
    let indexLabel = UILabel()
    let avatarImgView = UIImageView()
    let nameLabel = UILabel()
    let priceLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        sentupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sentupView() {
        self.contentView.addSubview(indexLabel)
        self.contentView.addSubview(avatarImgView)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(priceLabel)

        indexLabel.font = UIFont.systemFont(ofSize: 14)
        indexLabel.textColor = SGColor.SGTextColor()
        
        
        avatarImgView.layer.cornerRadius = 18
        avatarImgView.layer.masksToBounds = true
        
        indexLabel.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.width.equalTo(12)
        }

        avatarImgView.snp.makeConstraints { (make) in
            make.left.equalTo(indexLabel.snp.right).offset(10)
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
        }
        
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImgView.snp.right).offset(20)
            make.centerY.equalTo(self.contentView.snp.centerY)
        }
        
        priceLabel.font = UIFont.systemFont(ofSize: 14)
        priceLabel.snp.makeConstraints { (make) in
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

}
