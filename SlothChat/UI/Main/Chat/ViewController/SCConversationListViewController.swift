//
//  SCConversationListViewController.swift
//  SlothChat
//
//  Created by Fly on 16/11/9.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import PKHUD


class SCConversationListViewController: RCConversationListViewController,RCIMReceiveMessageDelegate,RCIMConnectionStatusDelegate {
    
    var search = UISearchController()
    var searchArray = [RCConversationModel]()
    var chatList = ChatList.ModelFromCache()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getChatList()
        ChatDataManager.shared.refreshBadgeValue()
        self.conversationListTableView.reloadData()
    }
    override func viewDidLoad() {
        //重写显示相关的接口，必须先调用super，否则会屏蔽SDK默认的处理
        super.viewDidLoad()
        navigationItem.title = "聊"
        setNavtionConfirm(imageStr: "button-group")
        navigationItem.rightBarButtonItem?.tintColor = SGColor.black

        self.search = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self   //两个样例使用不同的代理
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.searchBarStyle = .prominent
            controller.searchBar.sizeToFit()
            controller.searchBar.placeholder = "搜索个人/群"
            self.conversationListTableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        //设置需要显示哪些类型的会话
        self.setDisplayConversationTypes([RCConversationType.ConversationType_PRIVATE.rawValue,
                                          RCConversationType.ConversationType_DISCUSSION.rawValue,
                                          RCConversationType.ConversationType_CHATROOM.rawValue,
                                          RCConversationType.ConversationType_GROUP.rawValue,
                                          RCConversationType.ConversationType_APPSERVICE.rawValue,
                                          RCConversationType.ConversationType_SYSTEM.rawValue])
        //设置需要将哪些类型的会话在会话列表中聚合显示
//        self.setCollectionConversationType([RCConversationType.ConversationType_DISCUSSION.rawValue,
//                                            RCConversationType.ConversationType_GROUP.rawValue])
        self.conversationListTableView.register(SCChatGroupCell.self, forCellReuseIdentifier: "SCChatGroupCell")
        self.conversationListTableView.register(SCConversationListCell.self, forCellReuseIdentifier: "SCConversationListCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMessageNotification(_:)), name: NSNotification.Name.RCKitDispatchMessage, object: nil)
        
        RCIM.shared().receiveMessageDelegate = self
        RCIM.shared().connectionStatusDelegate = self
        self.conversationListTableView.tableFooterView = UIView()
    }
    
    //MARK: - Action
    
    override func confirmClick(){
        
        guard let groupId = self.chatList?.data?.chatOfficialGroupVo?.officialGroupUuid else {
            SGLog(message: "officialGroupUuid")
            return
        }
        
        let tmpVC = SelectChatFriendsViewController()
        tmpVC.dependVC = self
        
        tmpVC.officialGroupUuid = groupId
        let nav = BaseNavigationController(rootViewController: tmpVC)
        present(nav, animated: true, completion: nil)
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
    
    func getTableViewModel(indexPath: IndexPath) -> RCConversationModel{
        if search.isActive {
            return self.searchArray[indexPath.row]
        }
        return self.conversationListDataSource[indexPath.row] as! RCConversationModel
    }
    
    func removeIndexPath(indexPath: IndexPath) {
        
        SGLog(message: "")
        let model = self.conversationListDataSource[indexPath.row] as! RCConversationModel
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        
        if model.conversationType == .ConversationType_PRIVATE{
            engine.deletePrivateChat(uuid: model.targetId){ (response) in
                HUD.hide()
                if response?.status == ResponseError.SUCCESS.0{
                    self.doneDeleteChat(model:model,indexPath:indexPath)
                }else{
                    HUD.flash(.label(response?.msg), delay: 2)
                }
            }
        } else {
            engine.deleteUserGroup(userGroupUuid: model.targetId){ (response) in
                HUD.hide()
                if response?.status == ResponseError.SUCCESS.0 {
                    self.doneDeleteChat(model:model,indexPath:indexPath)
                }else{
                    HUD.flash(.label(response?.msg), delay: 2)
                }
            }
        }
    }
    
    func doneDeleteChat(model: RCConversationModel, indexPath: IndexPath) {
        RCIMClient.shared().remove(model.conversationType, targetId: model.targetId)
        self.conversationListDataSource.remove(model)
        self.conversationListTableView.reloadData()
        ChatDataManager.shared.refreshBadgeValue()
    }
    
    
    //MARK: - TableViewDelegate TableViewDataSource
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        let model = getTableViewModel(indexPath: indexPath)
        if model.targetId.hasPrefix("officialGroup"){
            return .none
        }
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if search.isActive {
            return nil
        }
        let model = getTableViewModel(indexPath: indexPath)
        if model.targetId.hasPrefix("officialGroup"){
            return nil
        }
        let action = UITableViewRowAction(style: .default, title: "删除", handler: {
            (action, indexPath) in
            self.removeIndexPath(indexPath: indexPath)
        })
        
        action.backgroundColor = SGColor.SGMainColor()
        return [action]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = getTableViewModel(indexPath: indexPath)
        
        if model.conversationType == .ConversationType_DISCUSSION ||
            model.conversationType == .ConversationType_GROUP{
            return 184
        }
        return 106
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if search.isActive {
            return searchArray.count
        }
        return conversationListDataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row >= self.conversationListDataSource.count {
            return UITableViewCell()
        }
        let model = getTableViewModel(indexPath: indexPath)
        
        if model.conversationType == .ConversationType_PRIVATE{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SCConversationListCell", for: indexPath) as! SCConversationListCell
            if let privateChat = self.chatList?.data?.getPrivateChatVo(privateChatId: model.targetId) {
                cell.configCellWithObject(privateChat: privateChat,model:model)
            }else{
                cell.configCellWithModel(model:model)
            }
            return cell
        }
        
        if model.conversationType == .ConversationType_DISCUSSION ||
            model.conversationType == .ConversationType_GROUP {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SCChatGroupCell", for: indexPath) as! SCChatGroupCell
            if let group = self.chatList?.data?.getChatUserGroupVo(groupId: model.targetId) {
                if group.isKind(of: ChatUserGroupVo.self) {
                    let userGroup = group as! ChatUserGroupVo
                    cell.configCellWithObject(userGroup: userGroup,model:model)
                }else if group.isKind(of: ChatOfficialGroupVo.self){
                    let officialGroup = group as! ChatOfficialGroupVo
                    cell.configCellWithObject(officialGroup: officialGroup,model:model)
                }else{
                    cell.configCellObject(model:model)
                }
            }
            
            return cell
        }
        return UITableViewCell()
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
        self.conversationListTableView.deselectRow(at: indexPath, animated: true)
        
        let tmpModel = getTableViewModel(indexPath: indexPath)
        search.isActive = false
        
        guard let target = self.chatList?.data?.getTargetModel(targetId: tmpModel.targetId) else {
            return
        }
        
        guard let chat = SCConversationViewController(conversationType: tmpModel.conversationType, targetId: tmpModel.targetId) else {
            return
        }
        
        if tmpModel.targetId.hasPrefix("officialGroup") {
            chat.officialGroup = self.chatList?.data?.chatOfficialGroupVo
        }
        
        chat.title = target.targetName
        chat.officialGroupUuid = self.chatList?.data?.chatOfficialGroupVo?.officialGroupUuid
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

extension SCConversationListViewController: UISearchResultsUpdating{
    //实时进行搜索
    func updateSearchResults(for searchController: UISearchController) {
        //RCConversationModel
        self.searchArray.removeAll()
        guard let searchText = searchController.searchBar.text else {
            return
        }
        SGLog(message: searchText)
        
        for tmpModel in self.conversationListDataSource {
            let model = tmpModel as! RCConversationModel
            var title = ""
            if let target = self.chatList?.data?.getTargetModel(targetId: model.targetId) {
                title = target.targetName!
            }
            if title.contains(searchText) {
                searchArray.append(model)
            }
        }
        
        self.conversationListTableView.reloadData()
    }
}

extension SCConversationListViewController{
    func getChatList() {
        let engine = NetworkEngine()
        
        engine.getChatList { (response) in
            if response?.status == ResponseError.SUCCESS.0 {
                self.chatList = response
                self.chatList?.caheForModel()
                self.conversationListTableView.reloadData()
            }else{
                HUD.flash(.label(response?.msg), delay: 2)
            }
        }
    }
}
