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
        self.title = "我"
            
        self.setNavtionConfirm(titleStr: "设置")
        
        setupView()
    }
    
    override func confirmClick() {
        print("confirmClick")
        let pushVC = SettingViewController.init()
        self.navigationController?.pushViewController(pushVC, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let pushVC = SettingViewController.init()
        self.navigationController?.pushViewController(pushVC, animated: true)
    }
    
    func setupView() {
        
    }

}
