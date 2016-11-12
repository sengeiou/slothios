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
            make.right.lessThanOrEqualTo(-60)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.avatarImgView.snp.right).offset(10)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(6)
            make.right.lessThanOrEqualTo(-60)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-8)
            make.top.equalTo(self.nameLabel.snp.top)
        }
        
        badgeView.layer.cornerRadius = 4
        badgeView.snp.makeConstraints { (make) in
            make.right.equalTo(timeLabel.snp.left).offset(-10)
            make.centerY.equalTo(self.timeLabel.snp.centerY)
            make.size.equalTo(CGSize.init(width: 8, height: 8))
        }
    }
//    -(NSString *)stringFromDate:(NSDate *)date
//    {
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *destDateString = [dateFormatter stringFromDate:date];
//    return destDateString;
//    }
    
    func configCellWithObject(model: RCConversationModel) {
        
        let unreadCount = model.unreadMessageCount
        badgeView.isHidden = unreadCount <= 0
        
        nameLabel.text = model.objectName
                
        let date = Date(timeIntervalSince1970: TimeInterval(model.receivedTime / 1000))
        timeLabel.text = date.timeAgo
        
        if model.conversationType == RCConversationType.ConversationType_DISCUSSION {
            contentLabel.text = model.lastestMessage.value(forKey: "content") as! String?
             nameLabel.text = model.objectName
            return
        }
        guard let userInfo = ChatDataManager.userInfoWidthID(model.targetId)  else {
            SGLog(message: "未查找到数据~~~")
            return
        }
        let showUserInfo = getShowUserInfo(model: model, userInfo: userInfo)
        
        if model.lastestMessage.isKind(of: RCTextMessage.self) {
            contentLabel.text = model.lastestMessage.value(forKey: "content") as! String?
        }else if model.lastestMessage.isKind(of: RCImageMessage.self){
            contentLabel.text = showUserInfo.name + "：[图片]"
        }else if model.lastestMessage.isKind(of: RCVoiceMessage.self){
            contentLabel.text = showUserInfo.name + "：[语音]"
        }else if model.lastestMessage.isKind(of: RCLocationMessage.self){
            contentLabel.text = showUserInfo.name + "：[位置]"
        }
        
        nameLabel.text = userInfo.name
        let avatarUrl = URL(string: userInfo.portraitUri)
        avatarImgView.kf.setImage(with: avatarUrl, placeholder: UIImage.init(named: "icon"), options: nil, progressBlock: nil, completionHandler: nil)
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
