//
//  SCConversationListCell.swift
//  SlothChat
//
//  Created by Fly on 16/11/10.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import Kingfisher

class SCConversationListCell: RCConversationBaseCell {
    
    let avatarImgView = UIImageView()
    let nameLabel = UILabel()
    let timeLabel = UILabel()
    let contentLabel = UILabel()
    let badgeView = UIView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        sentupView()
        
    }
    
    func sentupView() {
        contentView.addSubview(avatarImgView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(badgeView)
        
        badgeView.backgroundColor = SGColor.SGMainColor()

        avatarImgView.layer.cornerRadius = 24
        avatarImgView.layer.masksToBounds = true
        
        avatarImgView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalTo(self.snp.centerY)
            make.size.equalTo(CGSize.init(width: 48, height: 48))
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.avatarImgView.snp.right).offset(10)
            make.top.equalTo(self.avatarImgView.snp.top).offset(4)
            make.right.lessThanOrEqualTo(timeLabel.snp.left).offset(-10)
        }
        contentLabel.textColor = SGColor.SGTextColor()
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.avatarImgView.snp.right).offset(10)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(6)
            make.right.lessThanOrEqualTo(-60)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-8).priority(1000)
            make.top.equalTo(self.nameLabel.snp.top)
        }
        
        badgeView.layer.cornerRadius = 4
        badgeView.snp.makeConstraints { (make) in
            make.right.equalTo(timeLabel.snp.left).offset(-10)
            make.centerY.equalTo(self.timeLabel.snp.centerY)
            make.size.equalTo(CGSize.init(width: 8, height: 8))
        }
    }
    
    func configCellWithObject(model: RCConversationModel) {
        
        let unreadCount = model.unreadMessageCount
        badgeView.isHidden = unreadCount <= 0
        
        nameLabel.text = model.objectName
                
        let date = Date(timeIntervalSince1970: TimeInterval(model.receivedTime / 1000))
        timeLabel.text = date.timeAgo
        
        
    }
    
    public func configCellWithObject(privateChat: PrivateChatVo,model: RCConversationModel){
        
        let unreadCount = model.unreadMessageCount
        badgeView.isHidden = unreadCount <= 0
        
        let date = Date(timeIntervalSince1970: TimeInterval(model.receivedTime / 1000))
        timeLabel.text = date.timeAgo
        
        nameLabel.text = privateChat.nickname
        var showUserInfo = RCUserInfo()
        
        ChatDataManager.userInfoWidthID(privateChat.userUuid!){ (userInfo) in
            if let userInfo = userInfo {
                showUserInfo = self.getShowUserInfo(model: model, userInfo: userInfo)
                self.nameLabel.text = userInfo.name
                let avatarUrl = URL(string: userInfo.portraitUri)
                self.avatarImgView.kf.setImage(with: avatarUrl, placeholder: UIImage(named: "icon"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            
            if model.lastestMessage.isKind(of: RCTextMessage.self) {
                self.contentLabel.text = model.lastestMessage.value(forKey: "content") as! String?
            }else if model.lastestMessage.isKind(of: RCImageMessage.self){
                self.contentLabel.text = showUserInfo.name + "：[图片]"
            }else if model.lastestMessage.isKind(of: RCVoiceMessage.self){
                self.contentLabel.text = showUserInfo.name + "：[语音]"
            }else if model.lastestMessage.isKind(of: RCLocationMessage.self){
                self.contentLabel.text = showUserInfo.name + "：[位置]"
            }else if model.lastestMessage.isKind(of: RCDiscussionNotificationMessage.self){
                self.contentLabel.text = model.lastestMessage.value(forKey: "extension") as! String?
            }
        }
    }
    
    func getShowUserInfo(model: RCConversationModel, userInfo: RCUserInfo) -> RCUserInfo {
        let myself = RCIMClient.shared().currentUserInfo
        
        if model.senderUserId == myself?.userId {
            return myself!
        }
        return userInfo
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
