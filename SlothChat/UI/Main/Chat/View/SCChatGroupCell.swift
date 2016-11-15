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
        
        lastUserImgView.layer.cornerRadius = 24
        lastUserImgView.layer.masksToBounds = true
        

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let screenWidth = UIScreen.main.bounds.width
        let width = (screenWidth - CGFloat(12) * 6) / 7.0
        layout.itemSize = CGSize.init(width: width, height: width)
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView?.register(MyPhotosCell.self, forCellWithReuseIdentifier: "MyPhotosCell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = UIColor.white
        
        contentView.addSubview(collectionView!)
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
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
        
        descLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(10)
            make.right.lessThanOrEqualTo(-10)
        }
        
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView?.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(self.descLabel.snp.bottom).offset(10)
            make.height.equalTo(30)
        }
        
        lastUserImgView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo((self.collectionView?.snp.bottom)!).offset(10)
            make.size.equalTo(CGSize.init(width: 48, height: 48))
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.lastUserImgView.snp.right).offset(10)
            make.centerY.equalTo(self.lastUserImgView.snp.centerY)
            make.right.lessThanOrEqualTo(-60)
        }
    }
    
    public func configCellWithObject(model: RCConversationModel) {
        
        let unreadCount = model.unreadMessageCount
        badgeView.isHidden = unreadCount <= 0
        
        nameLabel.text = model.objectName
        
        let date = Date(timeIntervalSince1970: TimeInterval(model.receivedTime / 1000))
        timeLabel.text = date.timeAgo
        
        if model.conversationType == .ConversationType_DISCUSSION{
            self.nameLabel.text = "讨论组标题123"
            self.contentLabel.text = "讨论组内容123"
            return
        }
        if model.conversationType == .ConversationType_GROUP{
            self.nameLabel.text = "群聊标题"
            self.contentLabel.text = "群聊内容"
            return
        }
    }
    
    //MARK:- UICollectionViewDelegate,UICollectionViewDataSource

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        return cell
    }
    
}
