//
//  SCConversationListCell.swift
//  SlothChat
//
//  Created by Fly on 16/11/10.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import SDWebImage

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
        
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        timeLabel.font = UIFont.systemFont(ofSize: 12)

        badgeView.backgroundColor = SGColor.SGMainColor()

        avatarImgView.layer.cornerRadius = 30
        avatarImgView.layer.masksToBounds = true
        
        avatarImgView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalTo(self.snp.centerY)
            make.size.equalTo(CGSize.init(width: 60, height: 60))
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.avatarImgView.snp.right).offset(18)
            make.top.equalTo(self.avatarImgView.snp.top).offset(10)
            make.right.equalTo(-120)
        }
        contentLabel.textColor = SGColor.SGTextColor()
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.avatarImgView.snp.right).offset(18)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(18)
            make.right.lessThanOrEqualTo(-60)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-8).priority(1000)
            make.top.equalTo(self.nameLabel.snp.top)
        }
        
        badgeView.layer.cornerRadius = 4
        badgeView.snp.makeConstraints { (make) in
            make.right.equalTo(timeLabel.snp.left).offset(-14)
            make.centerY.equalTo(self.timeLabel.snp.centerY)
            make.size.equalTo(CGSize.init(width: 8, height: 8))
        }
    }
    
    public func configCellWithModel(model: RCConversationModel){
        ChatDataManager.userInfoWidthID(model.targetId){ (userInfo) in
            if let userInfo = userInfo {
                self.nameLabel.text = userInfo.name
                let avatarUrl = URL(string: userInfo.portraitUri)
                self.avatarImgView.sd_setImage(with: avatarUrl, placeholderImage: UIImage(named: "icon"))
            }
        }
        configWithModel(model: model)
    }
    func getShowUserInfo(model: RCConversationModel, userInfo: RCUserInfo) -> RCUserInfo {
        let myself = RCIMClient.shared().currentUserInfo
        
        if model.senderUserId == myself?.userId {
            return myself!
        }
        return userInfo
    }
    
    public func configCellWithObject(privateChat: PrivateChatVo,model: RCConversationModel){
        
        nameLabel.text = privateChat.nickname
        self.nameLabel.text = privateChat.nickname
        let avatarUrl = URL(string: privateChat.profilePicUrl!)
        
        self.avatarImgView.sd_setImage(with: avatarUrl, placeholderImage: UIImage(named: "icon"))
        configWithModel(model: model)
    }
    
    func configWithModel(model: RCConversationModel) {
        let unreadCount = model.unreadMessageCount
        badgeView.isHidden = unreadCount <= 0
        if model.receivedTime == 0 {
            timeLabel.text = ""
        }
        else {
            let date = Date(timeIntervalSince1970: TimeInterval(model.receivedTime / 1000))
            timeLabel.text = date.timeAgo
        }
        
        guard let lastMessage = model.lastestMessage else {
            self.contentLabel.text = " "
            return
        }
        if lastMessage.isKind(of: RCTextMessage.self) {
            if let content = model.lastestMessage.value(forKey: "content") as! String? {
                self.contentLabel.text = content
            }else{
                self.contentLabel.text = "[已销毁]"
            }
        }else if lastMessage.isKind(of: RCImageMessage.self){
            self.contentLabel.text = "[图片]"
        }else if lastMessage.isKind(of: RCVoiceMessage.self){
            self.contentLabel.text = "[语音]"
        }else if lastMessage.isKind(of: RCLocationMessage.self){
            self.contentLabel.text = "[位置]"
        }else if lastMessage.isKind(of: RCDiscussionNotificationMessage.self){
            self.contentLabel.text = model.lastestMessage.value(forKey: "extension") as! String?
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
