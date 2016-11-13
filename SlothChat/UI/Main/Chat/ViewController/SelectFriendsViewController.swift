//
//  SelectFriendsViewController.swift
//  SlothChat
//
//  Created by fly on 2016/11/13.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import PKHUD

class SelectFriendsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var dataSource = ChatManager.shared.friendArray
    var selectRows = Set<Int>()
    
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "选择好友"
        self.setNavtionBack(imageStr: "close")
        self.setNavtionConfirm(titleStr: "完成")
        sentupView()
    }
    
    func sentupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.rowHeight = 75
        view.addSubview(tableView)
        tableView.register(SelectFriendsCell.self, forCellReuseIdentifier: "SelectFriendsCell")
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SelectFriendsCell = tableView.dequeueReusableCell(withIdentifier: "SelectFriendsCell", for: indexPath) as! SelectFriendsCell
        let userObj = dataSource[indexPath.row]
        cell.configCellWithObj(userObj: userObj)
        cell.configFlagView(selected: selectRows.contains(indexPath.row))
        cell.indexPath = indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if selectRows.contains(indexPath.row) {
            selectRows.remove(indexPath.row)
        }else{
            selectRows.insert(indexPath.row)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func performCellAction( indexPath: IndexPath) {
        SGLog(message: indexPath.row)
        
        let userObj = dataSource[indexPath.row]
        
        guard let chat = SCConversationViewController(conversationType: RCConversationType.ConversationType_PRIVATE, targetId: userObj.userId) else {
            return
        }
        navigationController?.pushViewController(chat, animated: true)
    }
    
    override func backClick() {
        dismiss(animated: true, completion: nil)
    }
    
    override func confirmClick() {
        var idList = [String]()
        for value in selectRows {
            let userInfo = dataSource[value]
            idList.append(userInfo.userId)
        }
        if !idList.contains(RCIM.shared().currentUserInfo.userId) {
            idList.append(RCIM.shared().currentUserInfo.userId)
        }
        SGLog(message: idList)
        createDiscussion(IDS: idList)
    }
    
    func createDiscussion(IDS: [String]) {
        
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
}
