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
    var dataSource = ChatManager.shared.friendArray
    
    var groupUuid: String?
    var groupInfo: GroupInfoData?
    
    let headerView = ChatGroupInfoHeaderView()
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "群信息"
        sentupView()
        groupUuid = "userGroup20161115233117d328e9d934dd443f84"

        getGroupInfo()
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
        
        let removeButton = UIButton.init(type: .custom)
        removeButton.setTitle("删除群", for: .normal)
        removeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        removeButton.setTitleColor(SGColor.SGMainColor(), for: .normal)
        removeButton.addTarget(self, action:#selector(removeButtonClick), for: .touchUpInside)
        
        bottomView .addSubview(removeButton)
        
        exitButton.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.bottom.equalTo(-10)
            make.height.equalTo(46)
            make.right.equalTo(removeButton.snp.left)
            make.width.equalTo(removeButton.snp.width).dividedBy(0.668)
        }
        
        removeButton.snp.makeConstraints { (make) in
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
        let userObj = dataSource[indexPath.row]
        cell.configCellWithObj(userObj: userObj)
        cell.indexPath = indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK:- Action
    override func confirmClick() {
    
    }
    
    
    func exitButtonClick() {
        
    }
    
    func removeButtonClick() {
        
    }
    
    //MARK:- NetWork
    
    func getGroupInfo() {
        guard let groupUuid = groupUuid else {
            SGLog(message: "groupUuid为空")
            return
        }
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))

        engine.getUserGroup(userGroupUuid: groupUuid){ (response) in
            HUD.hide()
            if response?.status == ResponseError.SUCCESS.0 {
                self.title = response?.data?.groupDisplayName
                self.headerView.configWithObject(tmpGroupInfo: response?.data)
            }else{
                HUD.flash(.label(response?.msg), delay: 2)
            }
        }
    }
    
    func removeGroupInfo() {
        guard let groupUuid = groupUuid else {
            SGLog(message: "groupUuid为空")
            return
        }
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        
        engine.deleteUserGroup(userGroupUuid: groupUuid){ (response) in
            HUD.hide()
            if response?.status == ResponseError.SUCCESS.0 {
            }else{
                HUD.flash(.label(response?.msg), delay: 2)
            }
        }
    }
}
