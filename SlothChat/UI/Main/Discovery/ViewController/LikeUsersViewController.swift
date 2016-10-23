//
//  LikeUsersViewController.swift
//  SlothChat
//
//  Created by Fly on 16/10/22.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class LikeUsersViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    let dataSource = UserObj.getTestUserList()
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "喜欢的人"
        sentupView()
    }
    
    func sentupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.rowHeight = 44
        view.addSubview(tableView)
        tableView.register(LikeUsersCell.self, forCellReuseIdentifier: "LikeUsersCell")
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LikeUsersCell = tableView.dequeueReusableCell(withIdentifier: "LikeUsersCell", for: indexPath) as! LikeUsersCell
        let userObj = dataSource[indexPath.row]
        cell.configCellWithObj(userObj: userObj)
//        cell.setClosurePass { (actionType, actionIndexPath) in
//            self.performCellAction(actionType: actionType, indexPatch: actionIndexPath)
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func performCellAction(actionType: DiscoveryActionType, indexPatch: NSIndexPath) {
        SGLog(message: actionType)
        SGLog(message: indexPatch.row)
        
        switch actionType {
        case .likeType:
            
            break
        case .mainImgType:
            
            break
        case .likeUsersType:
            let pushVC = LikeUsersViewController()
            _ = navigationController?.popToViewController(pushVC, animated: true)
            break
        }
    }
    
}
