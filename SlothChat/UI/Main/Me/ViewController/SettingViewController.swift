//
//  SettingViewController.swift
//  SlothChat
//
//  Created by Fly on 16/10/17.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    let dataSource = SettingObj.getSettingList()
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "设置"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = SGColor.SGBgGrayColor()
        tableView.rowHeight = 74
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        tableView.register(SettingCell.self, forCellReuseIdentifier: "SettingCell")
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SettingCell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
        let settingObj = dataSource[indexPath.row]
        cell.configCellWithObj(settingObj: settingObj)
        if indexPath.row == 0 || indexPath.row == 4 {
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
        }else{
            cell.accessoryType = .none
            cell.selectionStyle = .none
        }
        cell.mSwitch.isHidden = !(indexPath.row == 1 || indexPath.row == 2)
        return cell

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var pushVC : UIViewController?
        if indexPath.row == 0 {
            pushVC = ModifyPasswordViewController()
        }else if indexPath.row == 4{
            pushVC = AboutUsViewController()
        }else if indexPath.row == 3{
            charge()
            return
        }
        
        if let pushVC = pushVC {
            self.navigationController?.pushViewController(pushVC, animated: true)
        }
    }
    
    func charge() {
        
    }

}
