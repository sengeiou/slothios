//
//  MeViewController.swift
//  SlothChat
//
//  Created by fly on 16/10/17.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class MeViewController: BaseViewController {
    var isEdited = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "我"
        self.setNavtionConfirm(titleStr: "设置")
    }
    
    override func confirmClick() {
        if isEdited {
            self.setNavtionConfirm(titleStr: "设置")
        }else{
            self.setNavtionConfirm(titleStr: "编辑")
        }
    }

}
