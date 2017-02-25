//
//  ConversationListViewController.swift
//  SlothChat
//
//  Created by 王一丁 on 2017/2/19.
//  Copyright © 2017年 ssloth.com. All rights reserved.
//

import UIKit

class ConversationListViewController: UIViewController {
    fileprivate var search = UISearchController();
    fileprivate var searchArray = [RCConversationModel]();
    fileprivate var chatList:ChatList? = nil;
    fileprivate var noteView: CSNotificationView?
    fileprivate var conversationListDataSource:NSMutableArray = NSMutableArray();
    fileprivate let conversationListTableView:UITableView = UITableView.init();
    fileprivate var lastgroupUUID:String? = nil;
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getChatList {
        };
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.title = "聊"
        setNavtionConfirm(imageStr: "button-group")
        navigationItem.rightBarButtonItem?.tintColor = SGColor.black
        
        self.search = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.searchBarStyle = .prominent
            controller.searchBar.sizeToFit()
            controller.searchBar.placeholder = "搜索个人/群"
            self.conversationListTableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        self.conversationListTableView.frame = self.view.bounds;
        self.conversationListTableView.delegate = self;
        self.conversationListTableView.dataSource = self;
        self.view.addSubview(self.conversationListTableView);
        
        self.conversationListTableView.register(SCChatGroupCell.self, forCellReuseIdentifier: "SCChatGroupCell")
        self.conversationListTableView.register(SCConversationListCell.self, forCellReuseIdentifier: "SCConversationListCell")
        
        RCIM.shared().receiveMessageDelegate = self
        RCIM.shared().connectionStatusDelegate = self
        self.conversationListTableView.tableFooterView = UIView()
        
        
    }
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ConversationListViewController: RCIMReceiveMessageDelegate,RCIMConnectionStatusDelegate {
    func onRCIMReceive(_ message: RCMessage!, left: Int32) {
        
        if left <= 0 {
            if message.conversationType == .ConversationType_PRIVATE {
                self.convertToConversationModel();
            }
            else if message.conversationType == .ConversationType_GROUP {
            }
            else {
                self.convertToConversationModel();
            }
        }
    }
    
    func onRCIMConnectionStatusChanged(_ status: RCConnectionStatus) {
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
    
    func didReceiveMessageNotification(_ notification: Notification!) {
    }
}

//MARK: - TableViewDelegate TableViewDataSource

extension ConversationListViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        let model = getTableViewModel(indexPath: indexPath)
        if model.targetId.hasPrefix("officialGroup"){
            return .none
        }
        return .delete
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = getTableViewModel(indexPath: indexPath)
        
        if model.conversationType == .ConversationType_DISCUSSION || model.conversationType == .ConversationType_GROUP {
            return GlobalData.ConversationListConst.conversationGroupCellHeight;
        }
        return GlobalData.ConversationListConst.conversationPrivateCellHeight;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if search.isActive {
            return searchArray.count
        }
        return conversationListDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
                } else if group.isKind(of: ChatOfficialGroupVo.self) {
                    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.chatList?.status != ResponseError.SUCCESS.0 {
            self.showNotificationError(message: self.chatList?.msg)
            return
        }
        self.conversationListTableView.deselectRow(at: indexPath, animated: true)
        
        let tmpModel = getTableViewModel(indexPath: indexPath)
        
        SGLog(message: tmpModel.targetId);
        
        search.isActive = false
        
        guard let target = self.chatList?.data?.getTargetModel(targetId: tmpModel.targetId) else {
            return
        }
        
        guard let chat = SCConversationViewController(conversationType: tmpModel.conversationType, targetId: tmpModel.targetId) else {
            return
        }
        
        if tmpModel.targetId.hasPrefix("officialGroup") {
            chat.officialGroup = self.chatList?.data?.chatOfficialGroupVo
            
        }else if tmpModel.targetId.hasPrefix("privateChatGroup") {
            
            chat.privateUserUuid = target.privateUserUuid
            SGLog(message: chat.privateUserUuid)
        }
        
        chat.title = target.targetName
        chat.officialGroupUuid = self.chatList?.data?.chatOfficialGroupVo?.officialGroupUuid
        navigationController?.pushViewController(chat, animated: true)
        
    }
    
    func getTableViewModel(indexPath: IndexPath) -> RCConversationModel{
        if search.isActive {
            return self.searchArray[indexPath.row]
        }
        return self.conversationListDataSource[indexPath.row] as! RCConversationModel
    }
    
    func removeIndexPath(indexPath: IndexPath) {
        
        let model = self.conversationListDataSource[indexPath.row] as! RCConversationModel
        
        let engine = NetworkEngine()
        self.showNotificationProgress()
        
        if model.conversationType == .ConversationType_PRIVATE{
            
            engine.deletePrivateChat(uuid: model.targetId){ (response) in
                SGLog(message: "deleted")
                
                self.hiddenNotificationProgress(animated: false)
                if response?.status == ResponseError.SUCCESS.0{
                    self.doneDeleteChat(model:model,indexPath:indexPath)
                }else{
                    self.showNotificationError(message: response?.msg)
                }
            }
        } else {
            engine.deleteUserGroup(userGroupUuid: model.targetId){ (response) in
                self.hiddenNotificationProgress(animated: false)
                if response?.status == ResponseError.SUCCESS.0 {
                    self.doneDeleteChat(model:model,indexPath:indexPath)
                }else{
                    self.showNotificationError(message: response?.msg)
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
}


extension ConversationListViewController: UISearchResultsUpdating {
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
    func showNotificationProgress() {
        self.noteView =  self.showNotificationProgress(message: nil)
    }
    func hiddenNotificationProgress(animated: Bool) {
        if let noteView = self.noteView{
            self.hiddenNotificationProgress(noteView: noteView, animated: animated)
        }
    }
}

extension ConversationListViewController {
    func getChatList( completeHandler:@escaping () -> Void) {
        NetworkEngine().getChatList { (response) in
            self.chatList = response
            
            if response?.status == ResponseError.SUCCESS.0 {
                self.convertToConversationModel();
            } else {
                self.showNotificationError(message: response?.msg)
            }
            completeHandler();
        }
    }
    
    func convertToConversationModel() {
        let conversationList:Array = RCIMClient.shared().getConversationList([
            RCConversationType.ConversationType_PRIVATE.rawValue,
            RCConversationType.ConversationType_DISCUSSION.rawValue,
            RCConversationType.ConversationType_CHATROOM.rawValue,
            RCConversationType.ConversationType_GROUP.rawValue,
            RCConversationType.ConversationType_APPSERVICE.rawValue,
            RCConversationType.ConversationType_SYSTEM.rawValue
            ])
        
        self.conversationListDataSource.removeAllObjects();
        
        for conversation in conversationList as! [RCConversation] {
            let model:RCConversationModel = RCConversationModel.init(conversation: conversation, extend: nil);
            if model.conversationType != .ConversationType_GROUP {
                self.conversationListDataSource.add(model);
            }
        }
        
        for chatUserGroupVo:ChatUserGroupVo in (self.chatList?.data?.chatUserGroupVos)! as [ChatUserGroupVo] {
            let model:RCConversationModel = RCConversationModel.init();
            model.targetId = chatUserGroupVo.userGroupUuid;
            model.conversationType = .ConversationType_GROUP;
            model.conversationTitle = chatUserGroupVo.userGroupName;
            self.conversationListDataSource.add(model)
        }
        
        for privateChat:PrivateChatVo in (self.chatList?.data?.privateChatVos)! as [PrivateChatVo] {
            let model:RCConversationModel = RCConversationModel.init();
            model.targetId = privateChat.privateChatUuid;
            model.conversationType = .ConversationType_PRIVATE;
            model.conversationTitle = privateChat.nickname;
            
            var isThere:Bool = false;
            for conversation in conversationList as! [RCConversation] {
                SGLog(message: conversation.targetId);
                SGLog(message: privateChat.userUuid);
                
                if conversation.targetId == privateChat.privateChatUuid {
                    
                    isThere = true;
                }
            }
            
            if isThere {
            }
            else {
                self.conversationListDataSource.add(model)
            }
        }
        
        let chatOfficialGroup:ChatOfficialGroupVo = (self.chatList?.data?.chatOfficialGroupVo)!;
        let model:RCConversationModel = RCConversationModel.init();
        model.targetId = chatOfficialGroup.officialGroupUuid;
        model.conversationType = .ConversationType_GROUP;
        model.conversationTitle = chatOfficialGroup.officialGroupName;
        
       
        self.conversationListDataSource.insert(model, at: 0);
        
        ChatDataManager.shared.refreshBadgeValue();
        self.conversationListTableView.reloadData();
    }
}
