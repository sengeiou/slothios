//
//  SCConversationListViewController.swift
//  SlothChat
//
//  Created by Fly on 16/11/9.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class SCConversationListViewController: RCConversationListViewController,RCIMReceiveMessageDelegate,RCIMConnectionStatusDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.conversationListTableView.reloadData()
    }
    override func viewDidLoad() {
        //重写显示相关的接口，必须先调用super，否则会屏蔽SDK默认的处理
        super.viewDidLoad()
        navigationItem.title = "聊"
        
        //设置需要显示哪些类型的会话
        self.setDisplayConversationTypes([RCConversationType.ConversationType_PRIVATE.rawValue,
                                          RCConversationType.ConversationType_DISCUSSION.rawValue,
                                          RCConversationType.ConversationType_CHATROOM.rawValue,
                                          RCConversationType.ConversationType_GROUP.rawValue,
                                          RCConversationType.ConversationType_APPSERVICE.rawValue,
                                          RCConversationType.ConversationType_SYSTEM.rawValue])
        //设置需要将哪些类型的会话在会话列表中聚合显示
        self.setCollectionConversationType([RCConversationType.ConversationType_DISCUSSION.rawValue,
                                            RCConversationType.ConversationType_GROUP.rawValue])
        self.conversationListTableView.register(SCConversationListCell.self, forCellReuseIdentifier: "SCConversationListCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMessageNotification(_:)), name: NSNotification.Name.RCKitDispatchMessage, object: nil)
        
        RCIM.shared().receiveMessageDelegate = self
        RCIM.shared().connectionStatusDelegate = self
        self.setNavtionConfirm(titleStr: "我的好友")
    }
    
    //MARK: - Action
    
    override func confirmClick(){
        let pushVC = ChatFriendViewController()
        navigationController?.pushViewController(pushVC, animated: true)
    }
    
    //MARK: - RCIMReceiveMessageDelegate
    /*!
     接收消息的回调方法
     
     @param message     当前接收到的消息
     @param left        还剩余的未接收的消息数，left>=0
     
     @discussion 如果您设置了IMKit消息监听之后，SDK在接收到消息时候会执行此方法（无论App处于前台或者后台）。
     其中，left为还剩余的、还未接收的消息数量。比如刚上线一口气收到多条消息时，通过此方法，您可以获取到每条消息，left会依次递减直到0。
     您可以根据left数量来优化您的App体验和性能，比如收到大量消息时等待left为0再刷新UI。
     */
    public func onRCIMReceive(_ message: RCMessage!, left: Int32) {
        SGLog(message: message.content)
        ChatDataManager.shared.refreshBadgeValue()
        
        if left <= 0 {
            self.conversationListTableView.reloadData()
        }
    }
    
    //MARK: - RCIMConnectionStatusDelegate
    
    public func onRCIMConnectionStatusChanged(_ status: RCConnectionStatus) {
        SGLog(message: "RCConnectionStatus" + String(status.rawValue))
        if status == RCConnectionStatus.ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT {
            
            let alertController = UIAlertController(title: nil, message: "您的帐号已在别的设备上登录，\n您被迫下线！", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "知道了", style: .cancel, handler: { (action) in
                RCIMClient.shared().disconnect(true)
            })
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    //MARK: - TableViewDelegate TableViewDataSource

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: .default, title: "删除", handler: {
            (action, indexPath) in
            self.removeIndexPath(indexPath: indexPath)
        })
            
        action.backgroundColor = SGColor.SGMainColor()
        
        return [action]
    }
    
    func removeIndexPath(indexPath: IndexPath) {
        let model = self.conversationListDataSource[indexPath.row] as! RCConversationModel
        
        RCIMClient.shared().remove(model.conversationType, targetId: model.targetId)
        self.conversationListDataSource.remove(model)
        self.conversationListTableView.reloadData()
        ChatDataManager.shared.refreshBadgeValue()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.conversationListDataSource.count > 0 && indexPath.row < self.conversationListDataSource.count {
            let model = self.conversationListDataSource[indexPath.row] as! RCConversationModel
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SCConversationListCell", for: indexPath) as! SCConversationListCell
            cell.configCellWithObject(model: model)
            return cell
        }
        let cell = UITableViewCell()
        return cell
    }
        
    override func rcConversationListTableView(_ tableView: UITableView!, cellForRowAt indexPath: IndexPath!) -> RCConversationBaseCell! {
        if self.conversationListDataSource.count > 0 && indexPath.row < self.conversationListDataSource.count {
            let model = self.conversationListDataSource[indexPath.row] as! RCConversationModel
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SCConversationListCell", for: indexPath) as! SCConversationListCell
            cell.configCellWithObject(model: model)
            return cell
        }
        let cell = RCConversationBaseCell()
        return cell
    }
    
    override func willReloadTableData(_ dataSource: NSMutableArray!) -> NSMutableArray! {
        
        for model in dataSource {
            if let tmpModel = model as? RCConversationModel {
                if tmpModel.conversationType == RCConversationType.ConversationType_PRIVATE{
                    tmpModel.conversationModelType = RCConversationModelType.CONVERSATION_MODEL_TYPE_CUSTOMIZATION
                }
            }
        }
        return dataSource;
    }
    
    override func didReceiveMessageNotification(_ notification: Notification!) {
        
        let message = notification.object as! RCMessage
        
        if message.content.isMember(of: RCMessageContent.self) {
            if message.conversationType == RCConversationType.ConversationType_PRIVATE {
                SGLog(message: "好友消息要发系统消息！！！")
                let customModel = RCConversationModel()
                customModel.conversationModelType = RCConversationModelType.CONVERSATION_MODEL_TYPE_CUSTOMIZATION
                customModel.senderUserId = message.senderUserId
                customModel.lastestMessage = message.content
                DispatchQueue.main.async {
                    self.refreshConversationTableView(with: customModel)
                    super.didReceiveMessageNotification(notification)
                    self.notifyUpdateUnreadMessageCount()
                }
            }else if message.conversationType == RCConversationType.ConversationType_PRIVATE {
                let receivedConversation = RCIMClient.shared().getConversation(message.conversationType, targetId: message.targetId)
                let customModel = RCConversationModel.init(RCConversationModelType.CONVERSATION_MODEL_TYPE_CUSTOMIZATION, conversation: receivedConversation, extend: nil)
                DispatchQueue.main.async {
                    self.refreshConversationTableView(with: customModel)
                    self.notifyUpdateUnreadMessageCount()
                    
                    if let left = notification.userInfo?["left"] as? Int {
                        if left <= 0{
                            super.refreshConversationTableViewIfNeeded()
                        }
                    }
                }
            }
        }else{
            DispatchQueue.main.async {
                super.didReceiveMessageNotification(notification)
                self.notifyUpdateUnreadMessageCount()
            }
        }
        
        self.refreshConversationTableViewIfNeeded()
    }
    
    //重写RCConversationListViewController的onSelectedTableRow事件
    override func onSelectedTableRow(_ conversationModelType: RCConversationModelType, conversationModel model: RCConversationModel!, at indexPath: IndexPath!) {
        
        guard let chat = SCConversationViewController(conversationType: model.conversationType, targetId: model.targetId) else {
            return
        }
        
        if model.conversationType == RCConversationType.ConversationType_PRIVATE {
            let userInfo = ChatDataManager.userInfoWidthID(model.targetId)
            chat.title = userInfo?.name
        }else if model.conversationType == RCConversationType.ConversationType_GROUP ||
            model.conversationType == RCConversationType.ConversationType_DISCUSSION{
            chat.title = model.conversationTitle;
        }
        navigationController?.pushViewController(chat, animated: true)
    }
    
    override func didTapCellPortrait(_ model: RCConversationModel!) {
        print("tap portrait \(model.senderUserId)")
        
//        let pushVC = UserInfoViewController()
//        pushVC.mUserUuid = model.targetId
//        
//        let userUuid = Global.shared.globalProfile?.userUuid
//        pushVC.likeSenderUserUuid = userUuid
//        navigationController?.pushViewController(pushVC, animated: true)
    }
}
