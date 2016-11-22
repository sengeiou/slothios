//
//  SelectChatFriendsViewController.swift
//  SlothChat
//
//  Created by fly on 2016/11/13.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import PKHUD

class SelectChatFriendsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var dataSource = [ChatMemberInfo]()
    var dependVC: UIViewController?
    var officialGroupUuid: String?
    
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
            controller.searchBar.placeholder = "搜索"
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
        cell.configFlagView(selected: selectRows.contains(memberInfo.userUuid!))
        cell.indexPath = indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let userObj = getTableViewModel(indexPath: indexPath)

        if selectRows.contains(userObj.userUuid!) {
            selectRows.remove(userObj.userUuid!)
        }else{
            selectRows.insert(userObj.userUuid!)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func performCellAction( indexPath: IndexPath) {
        SGLog(message: indexPath.row)
        
        let userObj = dataSource[indexPath.row]
        
        let userUuidA = Global.shared.globalProfile?.userUuid
        let userUuidB = userObj.userUuid
        
        self.postPrivateChat(nameA: Global.shared.globalProfile?.nickname, nameB: userObj.userDisplayName, userUuidA: userUuidA, userUuidB: userUuidB)
    }
    
    override func backClick() {
        dismiss(animated: true, completion: nil)
    }
    
    override func confirmClick() {
        var idList = [String]()
        var groupName = ""
        for userInfo in dataSource {
            if selectRows.contains(userInfo.userUuid!) {
                idList.append(userInfo.userUuid!)
                groupName.append(userInfo.userDisplayName!)
                groupName.append("、")
            }
        }
        if !idList.contains(RCIM.shared().currentUserInfo.userId) {
            idList.append(RCIM.shared().currentUserInfo.userId)
            groupName.append((Global.shared.globalProfile?.nickname)!)
        }
        SGLog(message: idList)
        SGLog(message: groupName)
        createPrivateGroup(IDS: idList, groupName: groupName)
    }
    
    func getOfficialGroupMember() {
        guard let officialGroupUuid = officialGroupUuid else {
            SGLog(message: "officialGroupUuid 为空")
            return
        }
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        engine.getOfficialGroupMember(officialGroupUuid: officialGroupUuid){ (response) in
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
        if IDS.count < 3 {
            HUD.flash(.label("包括自己在内最少需要3个成员才能新建一个聊天组"), delay: 2)
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
        if let dependVC = dependVC {
            dismiss(animated: true, completion: { 
                dependVC.navigationController?.pushViewController(chat, animated: true)
            })
        }else{
            navigationController?.pushViewController(chat, animated: true)
        }
    }
}

extension SelectChatFriendsViewController: UISearchResultsUpdating{
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

