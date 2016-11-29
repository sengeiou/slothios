//
//  ChatGroupCell.swift
//  SlothChat
//
//  Created by fly on 2016/11/12.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class SCChatGroupCell: RCConversationBaseCell,UICollectionViewDelegate,UICollectionViewDataSource {

    let nameLabel = UILabel()
    let descLabel = UILabel()
    let timeLabel = UILabel()
    let badgeView = UIView()
    
    var collectionView: UICollectionView?
    var dataSource = [ChatMemberInfo]()
    
    let lastUserImgView = UIImageView()
    let contentLabel = UILabel()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        sentupView()
    }

    fileprivate func sentupView() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(badgeView)
        contentView.addSubview(descLabel)
        contentView.addSubview(lastUserImgView)
        contentView.addSubview(contentLabel)
        
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.textColor = SGColor.black
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.textColor = SGColor.SGTextColor()
        badgeView.backgroundColor = SGColor.SGMainColor()
        
        lastUserImgView.layer.cornerRadius = 16
        lastUserImgView.layer.masksToBounds = true
        

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
//        let screenWidth = UIScreen.main.bounds.width
//        let width = (screenWidth - CGFloat(12) * 6) / 7.0
        let width = 42
        
        layout.itemSize = CGSize.init(width: width, height: width)
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView?.register(SCChatGroupMemberCell.self, forCellWithReuseIdentifier: "SCChatGroupMemberCell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = UIColor.white
        
        contentView.addSubview(collectionView!)
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(18)
            make.right.equalTo(-140)
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
        
        descLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(12)
            make.right.lessThanOrEqualTo(-10)
        }
        
        collectionView?.isUserInteractionEnabled = false
        collectionView?.register(SCChatGroupMemberCell.self, forCellWithReuseIdentifier: "SCChatGroupMemberCell")
        collectionView?.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(self.descLabel.snp.bottom).offset(16)
            make.height.equalTo(44)
        }
        
        lastUserImgView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo((self.collectionView?.snp.bottom)!).offset(10)
            make.size.equalTo(CGSize.init(width: 32, height: 32))
        }
        
        contentLabel.textColor = SGColor.SGTextColor()
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.lastUserImgView.snp.right).offset(12)
            make.centerY.equalTo(self.lastUserImgView.snp.centerY)
            make.right.lessThanOrEqualTo(-60)
        }
    }
    
    public func configCellWithConversationModel(model: RCConversationModel){
        ChatDataManager.userInfoWidthID(model.targetId){ (userInfo) in
            if let userInfo = userInfo {
                self.contentLabel.text = userInfo.name
                let avatarUrl = URL(string: userInfo.portraitUri)
                self.lastUserImgView.kf.setImage(with: avatarUrl, placeholder: UIImage(named: "icon"), options: nil, progressBlock: nil, completionHandler: nil)
            }
        }
    }
    
    public func configCellWithObject(lastUserAvatarUrl: String, lastUserName: String,model: RCConversationModel){
        let avatarUrl = URL(string: lastUserAvatarUrl)
        self.lastUserImgView.kf.setImage(with: avatarUrl, placeholder: UIImage(named: "icon"), options: nil, progressBlock: nil, completionHandler: nil)
        
        
        let unreadCount = model.unreadMessageCount
        badgeView.isHidden = unreadCount <= 0
        let date = Date(timeIntervalSince1970: TimeInterval(model.receivedTime / 1000))
        timeLabel.text = date.timeAgo
        
        if model.lastestMessage.isKind(of: RCTextMessage.self) {
            if let content = model.lastestMessage.value(forKey: "content") as! String? {
                self.contentLabel.text = content
            }else{
                self.contentLabel.text = "[已销毁]"
            }
        }else if model.lastestMessage.isKind(of: RCImageMessage.self){
            self.contentLabel.text = lastUserName + "：[图片]"
        }else if model.lastestMessage.isKind(of: RCVoiceMessage.self){
            self.contentLabel.text = lastUserName + "：[语音]"
        }else if model.lastestMessage.isKind(of: RCLocationMessage.self){
            self.contentLabel.text = lastUserName + "：[位置]"
        }else if model.lastestMessage.isKind(of: RCDiscussionNotificationMessage.self){
            self.contentLabel.text = model.lastestMessage.value(forKey: "extension") as! String?
        }
    }
    
    public func configCellWithObject(officialGroup: ChatOfficialGroupVo,model: RCConversationModel){
        
        nameLabel.text = officialGroup.officialGroupName
        descLabel.text = officialGroup.topicMsg
        dataSource = officialGroup.officialGroupMemberVos!
        collectionView?.reloadData()
        
        if let member = officialGroup.getChatMemberInfo(userUuid: model.senderUserId) {
            configCellWithObject(lastUserAvatarUrl: member.profilePicUrl!, lastUserName: member.userDisplayName!, model: model)
        }else{
            
            let userInfo = RCIM.shared().getUserInfoCache(model.senderUserId)
            
            if userInfo == nil {
                ChatDataManager.userInfoWidthID(model.senderUserId){ (userInfo) in
                    if let userInfo = userInfo {
                        self.configCellWithObject(lastUserAvatarUrl: userInfo.portraitUri!, lastUserName: userInfo.name!, model: model)
                    }else{
                        self.configCellWithObject(lastUserAvatarUrl: "", lastUserName: "", model: model)
                    }
                }
            }else{
                self.configCellWithObject(lastUserAvatarUrl: (userInfo?.portraitUri!)!, lastUserName: (userInfo?.name)!, model: model)
            }
        }
    }
    
    public func configCellWithObject(userGroup: ChatUserGroupVo,model: RCConversationModel){
        
        nameLabel.text = userGroup.userGroupName
        descLabel.text = ""
        dataSource = userGroup.userGroupMemberVos!
        collectionView?.reloadData()
        
        if let member = userGroup.getChatMemberInfo(userUuid: model.senderUserId) {
            configCellObject(model: model, member: member)
        }else{
            self.lastUserImgView.image = nil
            self.contentLabel.text = ""
            configCellObject(model: model)
        }
    }
    
    func configCellObject(model: RCConversationModel,member: ChatMemberInfo) {
        configCellObject(model: model)
        
        let avatarUrl = URL(string: member.profilePicUrl!)
        self.lastUserImgView.kf.setImage(with: avatarUrl, placeholder: UIImage(named: "icon"), options: nil, progressBlock: nil, completionHandler: nil)
        
        let unreadCount = model.unreadMessageCount
        badgeView.isHidden = unreadCount <= 0
        
        let date = Date(timeIntervalSince1970: TimeInterval(model.receivedTime / 1000))
        timeLabel.text = date.timeAgo
        
        if model.lastestMessage.isKind(of: RCTextMessage.self) {
            if let content = model.lastestMessage.value(forKey: "content") as! String? {
                self.contentLabel.text = content
            }else{
                self.contentLabel.text = "[已销毁]"
            }
        }else if model.lastestMessage.isKind(of: RCImageMessage.self){
            self.contentLabel.text = member.userDisplayName! + "：[图片]"
        }else if model.lastestMessage.isKind(of: RCVoiceMessage.self){
            self.contentLabel.text = member.userDisplayName! + "：[语音]"
        }else if model.lastestMessage.isKind(of: RCLocationMessage.self){
            self.contentLabel.text = member.userDisplayName! + "：[位置]"
        }else if model.lastestMessage.isKind(of: RCDiscussionNotificationMessage.self){
            self.contentLabel.text = model.lastestMessage.value(forKey: "extension") as! String?
        }
    }
    
    
    func configCellObject(model: RCConversationModel){
        let unreadCount = model.unreadMessageCount
        badgeView.isHidden = unreadCount <= 0
        
        let date = Date(timeIntervalSince1970: TimeInterval(model.receivedTime / 1000))
        timeLabel.text = date.timeAgo
    }
    
    
    
    //MARK:- UICollectionViewDelegate,UICollectionViewDataSource

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count + 1
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SCChatGroupMemberCell", for: indexPath) as! SCChatGroupMemberCell
        if indexPath.row < dataSource.count {
            let chatUser = dataSource[indexPath.row]
            cell.configCellObject(chatUser:chatUser)
        }else{
            cell.imgView.image = UIImage(named: "icon-etcetera")
        }

        return cell
    }
    
}
