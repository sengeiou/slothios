//
//  SCConversationListViewController.swift
//  SlothChat
//
//  Created by Fly on 16/11/9.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
//,RCIMReceiveMessageDelegate,RCIMConnectionStatusDelegate

class SCConversationListViewController: RCConversationListViewController {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
//        RCIM.shared().receiveMessageDelegate = self
//        RCIM.shared().connectionStatusDelegate = self
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: .default, title: "删除", handler: {
            (action, indexPath) in
            self.conversationListDataSource.remove(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        })
            
        action.backgroundColor = SGColor.SGMainColor()
        
        return [action]
    }
    
    override func willDisplayConversationTableCell(_ cell: RCConversationBaseCell!, at indexPath: IndexPath!) {
//        let model = self.conversationListDataSource[indexPath.row]
        
    }
    
    override func rcConversationListTableView(_ tableView: UITableView!, heightForRowAt indexPath: IndexPath!) -> CGFloat {
        return 100
    }
    
    override func didReceiveMessageNotification(_ notification: Notification!) {
        
    }
    
    override func rcConversationListTableView(_ tableView: UITableView!, cellForRowAt indexPath: IndexPath!) -> RCConversationBaseCell! {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleMessageCell", for: indexPath)
        return cell as! RCConversationBaseCell
    }
    
    //重写RCConversationListViewController的onSelectedTableRow事件
    override func onSelectedTableRow(_ conversationModelType: RCConversationModelType, conversationModel model: RCConversationModel!, at indexPath: IndexPath!) {
        guard let chat = SCConversationViewController(conversationType: model.conversationType, targetId: model.targetId) else {
            return
        }
        chat.title = model.senderUserId
        navigationController?.pushViewController(chat, animated: true)
    }
    
    override func didTapCellPortrait(_ model: RCConversationModel!) {
        print("tap portrait \(model.senderUserId)")

    }
}
