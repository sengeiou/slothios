//
//  ChatFriendViewController.swift
//  SlothChat
//
//  Created by fly on 2016/11/12.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class ChatFriendViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    var dataSource = ChatManager.shared.friendArray
    
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我的好友"
        self.setNavtionConfirm(titleStr: "我的群组")
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
        cell.configCellWithObj(userObj: userObj)
        cell.indexPath = indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.performCellAction( indexPath: indexPath)
        
    }
    
    func performCellAction( indexPath: IndexPath) {
        SGLog(message: indexPath.row)
        
        let userObj = dataSource[indexPath.row]

        guard let chat = SCConversationViewController(conversationType: RCConversationType.ConversationType_PRIVATE, targetId: userObj.userId) else {
            return
        }
        navigationController?.pushViewController(chat, animated: true)
    }
    
    override func confirmClick() {
        let pushVC = ChatGroupViewController()
        navigationController?.pushViewController(pushVC, animated: true)
    }
    
}
