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
        likeButton.setBackgroundImage(UIImage.init(named: "follow_button"), for: .normal)
//        chatButton.backgroundColor = SGColor.SGMainColor()
        chatButton.setBackgroundImage(UIImage.init(named: "chat_button"), for: .normal)
        addSubview(chatButton)
        addSubview(likeButton)
        
        likeButton.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.centerY.equalTo(self.snp.centerY)
            make.size.equalTo(CGSize.init(width: 60, height: 60))
        }
        
        chatButton.snp.makeConstraints { (make) in
            make.right.equalTo(likeButton.snp.left).offset(-24)
            make.centerY.equalTo(self.snp.centerY)
            make.size.equalTo(CGSize.init(width: 60, height: 60))
        }
    }
    
    
    func refreshLikeButtonStatus(isLike: Bool) {
        if isLike {
            likeButton.backgroundColor = UIColor.red
        }else{
            likeButton.backgroundColor = UIColor.clear
        }
    }
}

private extension MyPhotosViewController {
    
    func setupPullToRefresh() {
        collectionView?.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.getGalleryPhoto(at: .top)
        })
        collectionView?.mj_header.isAutomaticallyChangeAlpha = true
        
    }
}
