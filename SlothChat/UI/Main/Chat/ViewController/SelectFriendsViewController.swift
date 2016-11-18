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
    var dataSource = [ChatMemberInfo]()
    
    var selectRows = Set<String>()
    
    var search = UISearchController()
    var searchArray = [ChatMemberInfo]()
    
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "选择好友"
        self.setNavtionBack(imageStr: "close")
        self.setNavtionConfirm(titleStr: "完成")
        sentupView()
        getOfficialGroupMember()
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
    
    func getTableViewModel(indexPath: IndexPath) -> ChatMemberInfo{
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
        let memberInfo = getTableViewModel(indexPath: indexPath)
        cell.configCellWithObj(memberInfo: memberInfo)
        cell.configFlagView(selected: selectRows.contains(memberInfo.memberUuid!))
        cell.indexPath = indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let userObj = getTableViewModel(indexPath: indexPath)

        if selectRows.contains(userObj.memberUuid!) {
            selectRows.remove(userObj.memberUuid!)
        }else{
            selectRows.insert(userObj.memberUuid!)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func performCellAction( indexPath: IndexPath) {
        SGLog(message: indexPath.row)
        
        let userObj = dataSource[indexPath.row]
        
        guard let chat = SCConversationViewController(conversationType: RCConversationType.ConversationType_PRIVATE, targetId: userObj.memberUuid) else {
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
            if selectRows.contains(userInfo.memberUuid!) {
                idList.append(userInfo.memberUuid!)
                groupName.append(userInfo.userDisplayName!)
            }
        }
        if !idList.contains(RCIM.shared().currentUserInfo.userId) {
            idList.append(RCIM.shared().currentUserInfo.userId)
            groupName.append(RCIM.shared().currentUserInfo.name)
        }
        SGLog(message: idList)
        createPrivateGroup(IDS: idList, groupName: groupName)
    }
    
    func getOfficialGroupMember() {
        
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        engine.getOfficialGroupMember(officialGroupUuid: "officialGroup20161119005225b86ca6f51c8d49bf9e"){ (response) in
            HUD.hide()
            if response?.status == ResponseError.SUCCESS.0 {
                self.dataSource.removeAll()
                if let list = response?.data?.list{
                    self.dataSource.append(contentsOf: list)
                    self.tableView.reloadData()
                }
            }else{
                HUD.flash(.label(response?.msg), delay: 2)
            }
        }
    }
    
    func createPrivateGroup(IDS: [String], groupName: String) {
        
        if IDS.count <= 0 {
            HUD.flash(.label("请先选择好友"), delay: 2)
            return
        }
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        
        engine.postCreateGroup(memberUserUuidList: IDS, groupDisplayName: groupName) { (response) in
            if response?.status == ResponseError.SUCCESS.0 {
                HUD.flash(.label("创建群组成功"), delay: 2 , completion: { (result) in
                    self.pushGroupViewController(group: response?.data)
                })
            }else{
                HUD.flash(.label(response?.msg), delay: 2)
            }
        }
    }
    
    func pushGroupViewController(group: GroupInfoData?) {
        guard let group = group,
              let groupId = group.uuid,
              let groupName = group.groupDisplayName else {
            return
        }
        SGLog(message: groupId)
        
        guard let chat = SCConversationViewController(conversationType: RCConversationType.ConversationType_GROUP, targetId: groupId) else {
            return
        }
        chat.title = groupName
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
            if (userInfo.userDisplayName?.contains(searchText))! {
                searchArray.append(userInfo)
            }
        }
        self.tableView.reloadData()
    }
}

