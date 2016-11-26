//
//  ChatGroupInfoViewController.swift
//  SlothChat
//
//  Created by Fly on 16/11/15.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import PKHUD

private let PageSize = 20

class ChatGroupInfoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var dataSource = [ChatMemberInfo]()
    var groupUuid: String?
    var groupName: String?
    var myMemberInfo: ChatMemberInfo?
    var isGroupOwner = false
    var pageNum = 1

    let headerView = ChatGroupInfoHeaderView()
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "群信息"
        sentupView()
        setupPullToRefresh()
        setNavtionBack(imageStr: "go-back")
        tableView.mj_header.beginRefreshing()
    }
    
    func sentupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.rowHeight = 58
        view.addSubview(tableView)
        tableView.register(ChatGroupInfoCell.self, forCellReuseIdentifier: "ChatGroupInfoCell")
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        let screenWidth = UIScreen.main.bounds.size.width
        headerView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 88)
        headerView.groupUuid = groupUuid
        headerView.groupName = groupName
        tableView.tableHeaderView = headerView
        headerView.configWithObject(tmpGroupName: groupName,isGroupOwner: false,memberInfo: nil)
        tableView.tableFooterView = UIView()
    }
    
    func addBottomView(isGroupOwner: Bool) {
        tableView.snp.remakeConstraints{ (make) in
            make.left.top.right.equalTo(0)
            make.bottom.equalTo(-56)
        }
        
        let bottomView = UIView()
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(0)
            make.height.equalTo(56)
        }

        let exitButton = UIButton.init(type: .custom)
        exitButton.layer.cornerRadius = 23
        exitButton.setTitle("退出群", for: .normal)
        exitButton.backgroundColor = SGColor.SGMainColor()
        exitButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        exitButton.addTarget(self, action:#selector(exitButtonClick), for: .touchUpInside)
        bottomView.addSubview(exitButton)
        
        if isGroupOwner {
            let deleteButton = UIButton.init(type: .custom)
            deleteButton.setTitle("删除群", for: .normal)
            deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            deleteButton.setTitleColor(SGColor.SGMainColor(), for: .normal)
            deleteButton.addTarget(self, action:#selector(deleteButtonClick), for: .touchUpInside)
            
            bottomView .addSubview(deleteButton)
            
            exitButton.snp.makeConstraints { (make) in
                make.left.equalTo(8)
                make.bottom.equalTo(-10)
                make.height.equalTo(46)
                make.right.equalTo(deleteButton.snp.left)
                make.width.equalTo(deleteButton.snp.width).dividedBy(0.668)
            }
            
            deleteButton.snp.makeConstraints { (make) in
                make.right.equalTo(-8)
                make.bottom.equalTo(-10)
                make.height.equalTo(46)
                make.right.equalTo(exitButton.snp.right)
            }
        }else{
            exitButton.snp.makeConstraints { (make) in
                make.left.lessThanOrEqualTo(80)
                make.right.greaterThanOrEqualTo(-80)
                make.bottom.equalTo(-10)
                make.height.equalTo(46)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChatGroupInfoCell = tableView.dequeueReusableCell(withIdentifier: "ChatGroupInfoCell", for: indexPath) as! ChatGroupInfoCell
        cell.titleLabel.isHidden = (indexPath.row != 0)
        
        let userObj = dataSource[indexPath.row]
        cell.configCellWithObj(userObj: userObj)
        if !self.isGroupOwner {
            cell.removeButton.isHidden = true
        }
        cell.indexPath = indexPath
        
        cell.setClosurePass { (actionIndexPath) in
            let actionUserObj = self.dataSource[actionIndexPath.row]
            self.deleteUserGroupMember(member: actionUserObj, indexPath: actionIndexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let userObj = dataSource[indexPath.row]
        
        let userUuidA = Global.shared.globalProfile?.userUuid
        let userUuidB = userObj.userUuid
        
        let pushVC = UserInfoViewController()
        
        pushVC.mUserUuid = userUuidB
        pushVC.likeSenderUserUuid = userUuidA
        self.navigationController?.pushViewController(pushVC, animated: true)
    }
    
    //MARK:- Action
    override func confirmClick() {
    }
    
    func exitButtonClick() {
        var member = myMemberInfo
        let memberUuid = myMemberInfo?.memberUuid
        
        var row = -1
        for i in 0..<dataSource.count {
            let userInfo = dataSource[i]
            if userInfo.memberUuid == memberUuid {
                member = userInfo
                row = i
                break
            }
        }
        if row < 0 {
            SGLog(message: "不存在用户")
            return
        }
        
        deleteUserGroupMember(member: member,indexPath: IndexPath(row: row, section: 0))
    }
    
    func deleteButtonClick() {
        deleteUserGroup()
    }
    
    
    func getMemberList(at: Position) {
        if at == .top {
            pageNum = 1
        }else{
            pageNum += 1
        }
        if (groupUuid?.hasPrefix("officialGroup"))! {
            getOfficialGroupMember(at: at)
        }else{
            getUserGroupMemberList(at: at)
        }
    }
    
    
    func handleResponse(list: [ChatMemberInfo]) {
        for member in list{
            if member.isAdmin! &&
                member.userUuid == Global.shared.globalProfile?.userUuid{
                self.isGroupOwner = true
            }
        }
        self.headerView.configWithObject(tmpGroupName: self.groupName,isGroupOwner: self.isGroupOwner,memberInfo: self.myMemberInfo)
        if !(self.groupUuid?.hasPrefix("officialGroup"))!{
            self.addBottomView(isGroupOwner: self.isGroupOwner)
        }
        self.dataSource.append(contentsOf: list)
        self.tableView.reloadData()
    }
    
    //MARK:- NetWork
    func getUserGroupMemberList(at: Position) {
        guard let groupUuid = groupUuid else {
            SGLog(message: "groupUuid为空")
            return
        }
        
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        
        engine.getGroupMemberUserList(userGroupUuid: groupUuid, pageNum: String(pageNum), pageSize: String(PageSize)){ (response) in
            HUD.hide()
            if at == .top {
                self.tableView.mj_header.endRefreshing()
            }else{
                self.tableView.mj_footer.endRefreshing()
            }
            
            if response?.status == ResponseError.SUCCESS.0 {
                if let list = response?.data?.list{
                    self.tableView.mj_footer?.isHidden = (list.count < PageSize)

                    if at == .top {
                        self.dataSource.removeAll()
                    }
                    if self.pageNum == 1{
                        self.myMemberInfo = response?.data?.getMemberInfo()
                    }
                    self.handleResponse(list: list)
                }
            }else{
                HUD.flash(.label(response?.msg), delay: 2)
            }
        }
    }
    
    func getOfficialGroupMember(at: Position) {
        guard let officialGroupUuid = groupUuid else {
            SGLog(message: "officialGroupUuid 为空")
            return
        }
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        engine.getOfficialGroupMember(officialGroupUuid: officialGroupUuid,pageNum: String(pageNum), pageSize: String(PageSize)){ (response) in
            HUD.hide()
            if at == .top {
                self.tableView.mj_header.endRefreshing()
            }else{
                self.tableView.mj_footer.endRefreshing()
            }
            if response?.status == ResponseError.SUCCESS.0 {
                if let list = response?.data?.list{
                    self.tableView.mj_footer?.isHidden = (list.count < PageSize)

                    if at == .top {
                        self.dataSource.removeAll()
                    }
                    if self.pageNum == 1{
                        self.myMemberInfo = response?.data?.getMemberInfo()
                    }
                    self.handleResponse(list: list)
                }
            }else{
                HUD.flash(.label(response?.msg), delay: 2)
            }
        }
    }
    
    func deleteUserGroup() {
        guard let groupUuid = groupUuid else {
            SGLog(message: "groupUuid为空")
            return
        }
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        
        engine.deleteUserGroup(userGroupUuid: groupUuid){ (response) in
            HUD.hide()
            RCIMClient.shared().remove(.ConversationType_GROUP, targetId: groupUuid)

            if response?.status == ResponseError.SUCCESS.0 {
                HUD.flash(.label("解散群成功"), delay: 2, completion: { (result) in
                    //如果是移出的自己
                    _ = self.navigationController?.popToRootViewController(animated: true)
                })
            }else{
                HUD.flash(.label(response?.msg), delay: 2)
            }
        }
    }
    
    func deleteUserGroupMember(member: ChatMemberInfo?,indexPath: IndexPath?) {
        guard let groupUuid = groupUuid,
              let member = member,
              let memberUuid = member.memberUuid,
              let indexPath = indexPath else {
            SGLog(message: "groupUuid为空")
            return
        }
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        
        engine.deleteUserGroupMember(userGroupUuid: groupUuid, userGroupMemberUuid: memberUuid){ (response) in
            HUD.hide()
            if response?.status == ResponseError.SUCCESS.0 {
                
                if member.isAdmin! || self.dataSource.count <= 3{
                    RCIMClient.shared().remove(.ConversationType_GROUP, targetId: groupUuid)
                    HUD.flash(.label("移除成功"), delay: 2, completion: { (result) in
                        _ = self.navigationController?.popToRootViewController(animated: true)
                    })
                }else{
                    HUD.flash(.label("移除成功"), delay: 2)
                }
                self.dataSource.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }else{
                HUD.flash(.label(response?.msg), delay: 2)
            }
        }
    }
}

private extension ChatGroupInfoViewController {
    
    func setupPullToRefresh() {
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.getMemberList(at: .top)
        })
        tableView.mj_header.isAutomaticallyChangeAlpha = true
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self.getMemberList(at: .bottom)
        })
    }
}
