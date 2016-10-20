//
//  UserInfoToolView.swift
//  SlothChat
//
//  Created by fly on 2016/10/20.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class UserInfoToolView: BaseView {

    let chatButton = UIButton()
    let likeButton = UIButton()
    
    override init(frame: CGRect ){
        super.init(frame: frame)
        sentupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func sentupView() {
//        likeButton.backgroundColor = SGColor.SGRedColor()
        likeButton.setImage(UIImage.init(named: "heart-solid"), for: .normal)
//        chatButton.backgroundColor = SGColor.SGMainColor()
        chatButton.setImage(UIImage.init(named: "send-message"), for: .normal)
        addSubview(chatButton)
        addSubview(likeButton)
        
        likeButton.snp.makeConstraints { (make) in
            make.right.equalTo(-4)
            make.centerY.equalTo(self.snp.centerY)
            make.size.equalTo(CGSize.init(width: 44, height: 44))
        }
        
        chatButton.snp.makeConstraints { (make) in
            make.right.equalTo(likeButton.snp.left).offset(-24)
            make.centerY.equalTo(self.snp.centerY)
            make.size.equalTo(CGSize.init(width: 44, height: 44))
        }
    }
}
