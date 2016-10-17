//
//  UIViewController+Extension.swift
//  SlothChat
//
//  Created by fly on 16/10/17.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import Foundation

extension UIViewController{
    func setNavtionConfirm(titleStr: String?) {
        let barItem = UIBarButtonItem.init(title: titleStr, style: .plain, target: self, action: #selector(confirmClick))
        self.navigationItem.rightBarButtonItem = barItem
    }
    
    func setNavtionConfirm(imageStr: String?) {
        if let imageStr = imageStr {
            let barItem = UIBarButtonItem.init(image: UIImage.init(named: imageStr), style: .plain, target: self, action: #selector(confirmClick))
            self.navigationItem.leftBarButtonItem = barItem
        }
    }

    func confirmClick() {
        print("confirmClick")
    }
}
