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
    var selectRows = Set<String>()
    
    var search = UISearchController()
    var searchArray = [RCUserInfo]()
    
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
        
        self.search = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self   //两个样例使用不同的代理
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.searchBarStyle = .prominent
            controller.searchBar.sizeToFit()
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
    }
    
    func getTableViewModel(indexPath: IndexPath) -> RCUserInfo{
        if search.isActive {
            return self.searchArray[indexPath.row]
        }
        return self.dataSource[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if search.isActive {
            return searchArray.count
        }
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SelectFriendsCell = tableView.dequeueReusableCell(withIdentifier: "SelectFriendsCell", for: indexPath) as! SelectFriendsCell
        let userObj = getTableViewModel(indexPath: indexPath)
        cell.configCellWithObj(userObj: userObj)
        cell.configFlagView(selected: selectRows.contains(userObj.userId))
        cell.indexPath = indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let userObj = getTableViewModel(indexPath: indexPath)

        if selectRows.contains(userObj.userId) {
            selectRows.remove(userObj.userId)
        }else{
            selectRows.insert(userObj.userId)
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
        var groupName = ""
        for userInfo in dataSource {
            if selectRows.contains(userInfo.userId) {
                idList.append(userInfo.userId)
                groupName.append(userInfo.name)
            }
        }
        if !idList.contains(RCIM.shared().currentUserInfo.userId) {
            idList.append(RCIM.shared().currentUserInfo.userId)
            groupName.append(RCIM.shared().currentUserInfo.name)
        }
        SGLog(message: idList)
        createDiscussion(IDS: idList, groupName: groupName)
    }
    
    func createDiscussion(IDS: [String], groupName: String) {
        
        if IDS.count <= 0 {
            HUD.flash(.label("请先选择好友"), delay: 2)
            return
        }
        let engine = NetworkEngine()
        
        engine.postCreateGroup(memberUserUuidList: IDS, groupDisplayName: groupName) { (response) in
            if response?.status == ResponseError.SUCCESS.0 {
                HUD.flash(.label("创建群组成功"), delay: 2 , completion: { (result) in
                    self.pushGroup(groupId: response?.data?.uuid)
                })
            }else{
                HUD.flash(.label(response?.msg), delay: 2)
            }
        }
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

extension SelectFriendsViewController: UISearchResultsUpdating{
    //实时进行搜索
    func updateSearchResults(for searchController: UISearchController) {
        self.searchArray.removeAll()
        guard let searchText = searchController.searchBar.text else {
            return
        }
        for userInfo in dataSource {
            if userInfo.name.contains(searchText) {
                searchArray.append(userInfo)
            }
        }
        self.tableView.reloadData()
    }
}

