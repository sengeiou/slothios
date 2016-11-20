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
        
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.textColor = SGColor.SGTextColor()
        descLabel.font = UIFont.systemFont(ofSize: 12)
        descLabel.textColor = SGColor.SGBgGrayColor()
        badgeView.backgroundColor = SGColor.SGMainColor()
        
        lastUserImgView.layer.cornerRadius = 16
        lastUserImgView.layer.masksToBounds = true
        

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
//        let screenWidth = UIScreen.main.bounds.width
//        let width = (screenWidth - CGFloat(12) * 6) / 7.0
        let width = 32
        
        layout.itemSize = CGSize.init(width: width, height: width)
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView?.register(SCChatGroupMemberCell.self, forCellWithReuseIdentifier: "SCChatGroupMemberCell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = UIColor.white
        
        contentView.addSubview(collectionView!)
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
            make.right.equalTo(-100)
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
            make.top.equalTo(self.nameLabel.snp.bottom).offset(10)
            make.right.lessThanOrEqualTo(-10)
        }
        
        collectionView?.isUserInteractionEnabled = false
        collectionView?.register(SCChatGroupMemberCell.self, forCellWithReuseIdentifier: "SCChatGroupMemberCell")
        collectionView?.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(self.descLabel.snp.bottom).offset(10)
            make.height.equalTo(32)
        }
        
        lastUserImgView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo((self.collectionView?.snp.bottom)!).offset(10)
            make.size.equalTo(CGSize.init(width: 32, height: 32))
        }
        
        contentLabel.textColor = SGColor.SGTextColor()
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.lastUserImgView.snp.right).offset(10)
            make.centerY.equalTo(self.lastUserImgView.snp.centerY)
            make.right.lessThanOrEqualTo(-60)
        }
    }
    
    public func configCellWithObject(officialGroup: ChatOfficialGroupVo,model: RCConversationModel){
        
        nameLabel.text = officialGroup.officialGroupName
        dataSource = officialGroup.officialGroupMemberVos!
        collectionView?.reloadData()
        
        if let member = officialGroup.getChatMemberInfo(userUuid: model.senderUserId) {
            configCellObject(model: model, member: member)
        }else{
            configCellObject(model: model)
        }
    }
    
    public func configCellWithObject(userGroup: ChatUserGroupVo,model: RCConversationModel){
        
        nameLabel.text = userGroup.userGroupName
        dataSource = userGroup.userGroupMemberVos!
        collectionView?.reloadData()
        
        if let member = userGroup.getChatMemberInfo(userUuid: model.senderUserId) {
            configCellObject(model: model, member: member)
        }else{
            configCellObject(model: model)
        }
    }
    
    func configCellObject(model: RCConversationModel,member: ChatMemberInfo) {
        configCellObject(model: model)
        
        let avatarUrl = URL(string: member.profilePicUrl!)
        self.lastUserImgView.kf.setImage(with: avatarUrl, placeholder: UIImage(named: "icon"), options: nil, progressBlock: nil, completionHandler: nil)
        
        if model.lastestMessage.isKind(of: RCTextMessage.self) {
            self.contentLabel.text = model.lastestMessage.value(forKey: "content") as! String?
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
        return dataSource.count
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SCChatGroupMemberCell", for: indexPath) as! SCChatGroupMemberCell
        let chatUser = dataSource[indexPath.row]
        cell.configCellObject(chatUser:chatUser)
        return cell
    }
    
}
