//
//  SettingViewController.swift
//  SlothChat
//
//  Created by Fly on 16/10/17.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import AwesomeCache

class SettingViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    let dataSource = SettingObj.getSettingList()
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "设置"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.rowHeight = 74
        view.addSubview(tableView)
        tableView.register(SettingCell.self, forCellReuseIdentifier: "SettingCell")
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        let screenWidth = UIScreen.main.bounds.size.width

        let footerView = UIView(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 100))
        let exitButton = UIButton(type: .custom)
        exitButton.layer.cornerRadius = 22
        exitButton.setTitle("退出", for: .normal)
        exitButton.backgroundColor = SGColor.SGMainColor()
        exitButton.addTarget(self, action: #selector(exitButtonClick), for: .touchUpInside)
        footerView.addSubview(exitButton)
        exitButton.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(40)
            make.height.equalTo(44)
        }
        tableView.tableFooterView = footerView
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
    
    //Mark:- Action
    
    func charge() {
        self.purchaseForProduct()
    }
    
    func exitButtonClick() {
        
        let alertController = UIAlertController(title: "是否退出树懒", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler:nil)
        let exitAction = UIAlertAction(title: "退出", style: .default, handler:{ (action) in
            do {
                let cache = try Cache<NSString>(name: SGGlobalKey.SCCacheName)
                cache.removeObject(forKey: SGGlobalKey.SCLoginStatusKey)
                NotificationCenter.default.post(name: SGGlobalKey.LoginStatusDidChange, object: nil)
            } catch _ {
                print("Something went wrong :(")
            }
        })

        alertController.addAction(cancelAction)
        alertController.addAction(exitAction)

        self.present(alertController, animated: true, completion: nil)
        
       
        
    }

}
