//
//  BaseViewController.swift
//  Chat
//
//  Created by Fly on 16/10/13.
//  Copyright © 2016年 Fly. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        if (self.navigationController?.viewControllers.count)! > 1 {
            self.hidesBottomBarWhenPushed = true
            self.setNavtionBack(imageStr: "go-back")
        }
        
    }
    
    func showAlertView(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler:nil)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        }

}
