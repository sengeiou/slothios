//
//  SCChatGroupMemberCell.swift
//  SlothChat
//
//  Created by Fly on 16/11/16.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class SCChatGroupMemberCell: UICollectionViewCell {
    let imgView = UIImageView.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sentupView()
    }
    
    func sentupView()  {
        self.clipsToBounds = true
        imgView.frame = self.bounds
        contentView.addSubview(imgView)
        
        imgView.layer.cornerRadius = 16
        imgView.layer.masksToBounds = true
        imgView.snp.makeConstraints { (make) in
            make.center.equalTo(self.contentView)
            make.size.equalTo(CGSize.init(width: 32, height: 32))
        }
    }
    
    func configCellObject(chatUser: ChatMemberInfo) {
        if chatUser.profilePicUrl != nil {
            let url = URL(string: chatUser.profilePicUrl!)
            imgView.kf.setImage(with: url, placeholder: UIImage(named: "icon"), options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
