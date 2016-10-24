//
//  UIViewController+Extension.swift
//  SlothChat
//
//  Created by fly on 16/10/17.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import Foundation

extension UIViewController{
    
    func setNavtionBack(titleStr: String?) {
        if titleStr == nil {
            return
        }
        let barItem = UIBarButtonItem.init(title: titleStr, style: .plain, target: self, action: #selector(backClick))
        barItem.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = barItem
    }
    
    func setNavtionBack(imageStr: String?) {
        if imageStr == nil {
            return
        }
        let barItem = UIBarButtonItem.init(image: UIImage.init(named: imageStr!), style: .plain, target: self, action: #selector(backClick))
        barItem.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = barItem
    }
    
    func setNavtionConfirm(titleStr: String?) {
        if titleStr == nil {
            return
        }
        let barItem = UIBarButtonItem.init(title: titleStr, style: .plain, target: self, action: #selector(confirmClick))
        barItem.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem = barItem
    }
    
    func setNavtionConfirm(imageStr: String?) {
        if imageStr == nil {
            return
        }
        if let imageStr = imageStr {
            let barItem = UIBarButtonItem.init(image: UIImage.init(named: imageStr), style: .plain, target: self, action: #selector(confirmClick))
            self.navigationItem.rightBarButtonItem = barItem
        }
    }
    
    func backClick() {
        SGLog(message: "")
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func confirmClick() {
        SGLog(message: "")
    }
}
