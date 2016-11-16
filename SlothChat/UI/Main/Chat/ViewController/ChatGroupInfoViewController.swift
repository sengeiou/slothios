//
//  ChatGroupInfoViewController.swift
//  SlothChat
//
//  Created by Fly on 16/11/15.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import PKHUD

class ChatGroupInfoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var dataSource = [ChatMemberInfo]()
    
    var groupInfo: GroupInfoData?
    
    let headerView = ChatGroupInfoHeaderView()
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "群信息"
        sentupView()
        setNavtionBack(imageStr: "go-back")
        getGroupMemberList()
    }
    
    func sentupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.rowHeight = 75
        view.addSubview(tableView)
        tableView.register(ChatGroupInfoCell.self, forCellReuseIdentifier: "ChatGroupInfoCell")
        tableView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.bottom.equalTo(-46)
        }
        
        let screenWidth = UIScreen.main.bounds.size.width
        headerView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 88)
        tableView.tableHeaderView = headerView
        headerView.configWithObject(tmpGroupInfo: groupInfo)
        tableView.tableFooterView = UIView()

        let bottomView = UIView()
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(0)
            make.height.equalTo(46)
        }

        let exitButton = UIButton.init(type: .custom)
        exitButton.layer.cornerRadius = 23
        exitButton.setTitle("退出群", for: .normal)
        exitButton.backgroundColor = SGColor.SGMainColor()
        exitButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        exitButton.addTarget(self, action:#selector(exitButtonClick), for: .touchUpInside)
        bottomView.addSubview(exitButton)
        
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

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChatGroupInfoCell = tableView.dequeueReusableCell(withIdentifier: "ChatGroupInfoCell", for: indexPath) as! ChatGroupInfoCell
        cell.titleLabel.isHidden = (indexPath.row != 0)
        cell.removeButton.isHidden = (indexPath.row == 0)
        let userObj = dataSource[indexPath.row]
        cell.configCellWithObj(userObj: userObj)
        if indexPath.row == 0 {
            cell.nameLabel.text = userObj.nickname! + " (群主)"
        }
        cell.indexPath = indexPath
        
        cell.setClosurePass { (actionIndexPath) in
            let actionUserObj = self.dataSource[actionIndexPath.row]
            self.deleteUserGroupMember(memberUuid: actionUserObj.userUuid, indexPath: actionIndexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK:- Action
    override func confirmClick() {
    
    }
    
    func exitButtonClick() {
        let memberUuid = Global.shared.globalProfile?.userUuid
        var row = -1
        for i in 0..<dataSource.count {
            let userInfo = dataSource[i]
            if userInfo.userUuid == memberUuid {
                row = i
                break
            }
        }
        if row < 0 {
            SGLog(message: "不存在用户")
            return
        }
        
        deleteUserGroupMember(memberUuid: memberUuid,indexPath: IndexPath(row: row, section: 0))
    }
    
    func deleteButtonClick() {
        deleteUserGroup()
    }
    
    //MARK:- NetWork
    
    func getGroupMemberList() {
        guard let groupUuid = groupInfo?.uuid else {
            SGLog(message: "groupUuid为空")
            return
        }
        
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        
        engine.getGroupMemberUserList(userGroupUuid: groupUuid){ (response) in
            HUD.hide()
            if response?.status == ResponseError.SUCCESS.0 {
                if let list = response?.data?.list{
                    self.dataSource = list
                    self.tableView.reloadData()
                }
            }else{
                HUD.flash(.label(response?.msg), delay: 2)
            }
        }
    }
    
    func deleteUserGroup() {
        guard let groupUuid = groupInfo?.uuid else {
            SGLog(message: "groupUuid为空")
            return
        }
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        
        engine.deleteUserGroup(userGroupUuid: groupUuid){ (response) in
            HUD.hide()
            if response?.status == ResponseError.SUCCESS.0 {
                HUD.flash(.label("解散群成功"), delay: 2)
            }else{
                HUD.flash(.label(response?.msg), delay: 2)
            }
        }
    }
    
    func deleteUserGroupMember(memberUuid: String?,indexPath: IndexPath?) {
        guard let groupUuid = groupInfo?.uuid,
              let memberUuid = memberUuid,
              let indexPath = indexPath else {
            SGLog(message: "groupUuid为空")
            return
        }
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        
        engine.deleteUserGroupMember(userGroupUuid: groupUuid, userGroupMemberUuid: memberUuid){ (response) in
            HUD.hide()
            if response?.status == ResponseError.SUCCESS.0 {
                HUD.flash(.label("移除成功"), delay: 2)
                self.dataSource.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }else{
                HUD.flash(.label(response?.msg), delay: 2)
            }
        }
    }
}
