//
//  ChatGroupViewController.swift
//  SlothChat
//
//  Created by fly on 2016/11/12.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import PKHUD

class ChatGroupViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    var dataSource = ChatManager.shared.groupArray
    
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我的群组"
        self.setNavtionConfirm(titleStr: "创建讨论组")
        sentupView()
    }
    
    func sentupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.rowHeight = 75
        view.addSubview(tableView)
        tableView.register(ChatFriendCell.self, forCellReuseIdentifier: "ChatFriendCell")
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChatFriendCell = tableView.dequeueReusableCell(withIdentifier: "ChatFriendCell", for: indexPath) as! ChatFriendCell
        let userObj = dataSource[indexPath.row]
        cell.configCellWithObj(groupObj: userObj)
        cell.indexPath = indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        self.performCellAction( indexPath: indexPath)
        
    }
    
    func pushGroup(groupId: String?) {
        guard let groupId = groupId else {
            return
        }
        SGLog(message: groupId)
        
        guard let chat = SCConversationViewController(conversationType: RCConversationType.ConversationType_GROUP, targetId: groupId) else {
            return
        }
        navigationController?.pushViewController(chat, animated: true)
    }
    
    override func confirmClick() {
        self.createDiscussion()
    }
    
    func createDiscussion() {
        var IDS = [String]()
        for userInfo in ChatManager.shared.friendArray {
            IDS.append(userInfo.userId)
        }
        
        if !IDS.contains(RCIM.shared().currentUserInfo.userId) {
            IDS.append(RCIM.shared().currentUserInfo.userId)
        }
        RCIMClient.shared().createDiscussion("树懒学习讨论组", userIdList: IDS, success:{ discussion in
            SGLog(message: discussion?.discussionName)
            SGLog(message: discussion?.discussionId)
            
            DispatchQueue.main.sync {
                HUD.flash(.label("成功加入讨论组"), delay: 2, completion: { (result) in
                    self.pushGroup(groupId: discussion?.discussionId)
                })
            }
            }, error:{ errorCode in
                SGLog(message: errorCode)
                HUD.show(.labeledProgress(title: "创建讨论组失败", subtitle: nil))
        })
    }
}
