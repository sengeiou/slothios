//
//  NewestViewController.swift
//  SlothChat
//
//  Created by Fly on 16/10/22.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class NewestViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    let dataSource = DiscoveryUserObj.getDiscoveryUserList()
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.rowHeight = 260
        view.addSubview(tableView)
        tableView.register(DiscoveryCell.self, forCellReuseIdentifier: "DiscoveryCell")
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : DiscoveryCell = tableView.dequeueReusableCell(withIdentifier: "DiscoveryCell", for: indexPath) as! DiscoveryCell
        let userObj = dataSource[indexPath.row]
        cell.configCellWithObj(userObj: userObj)
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }


}
