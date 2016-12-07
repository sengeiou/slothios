//
//  DebugViewController.swift
//  SlothChat
//
//  Created by fly on 2016/12/6.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class DebugViewController: BaseViewController ,UITableViewDelegate,UITableViewDataSource {
    
    var dataSource = [String]()
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Debug"
        dataSource.append("线上环境")
        dataSource.append("开发环境")
        sentupView()
    }
    
    func sentupView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.rowHeight = 74
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let title = dataSource[indexPath.row]
        cell.textLabel?.text = title
        
        let networkType = GVUserDefaults.standard().networkType.rawValue
        if indexPath.row == networkType {
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let alertController = UIAlertController(title: "立即切换环境，切换环境后APP会强制退出", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler:nil)
        let okAction = UIAlertAction(title: "切换", style: .destructive){ (action) in
            GVUserDefaults.standard().networkType = NetWorkType(rawValue: Int(indexPath.row))!
            Global.shared.logout()
            ItunesCharge.removeFromCache()
            RCIM.shared().disconnect(false)
            
            exit(0)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
}
