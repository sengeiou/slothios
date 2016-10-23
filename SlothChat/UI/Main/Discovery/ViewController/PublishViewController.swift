//
//  PublishViewController.swift
//  SlothChat
//
//  Created by Fly on 16/10/23.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class PublishViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    let dataSource = DiscoveryUserObj.getDiscoveryUserList()
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    
    let headerView = PublishHeaderView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sentupView()
        setNavtionConfirm(titleStr: "发送")
    }
    
    func sentupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.rowHeight = 44
        view.addSubview(tableView)
        tableView.register(BiddingListCell.self, forCellReuseIdentifier: "BiddingListCell")
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        tableView.tableHeaderView = headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BiddingListCell = tableView.dequeueReusableCell(withIdentifier: "BiddingListCell", for: indexPath) as! BiddingListCell
//        let userObj = dataSource[indexPath.row]
//        cell.configCellWithObj(userObj: userObj)
//        cell.indexPath = indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func configWithObject(image: UIImage) {
        headerView.configWithObject(image: image)
       
    }
    
    //MARK:- Action
    
    override func confirmClick() {
        
    }
}
