//
//  SettingViewController.swift
//  SlothChat
//
//  Created by Fly on 16/10/17.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    var dataSource = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "设置"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SettingCell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
        let obj = dataSource[indexPath.row]
        cell.titleLabel.text = obj
        return cell

    }

}
