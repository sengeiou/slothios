//
//  ModifyPasswordViewController.swift
//  SlothChat
//
//  Created by Fly on 16/10/18.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import PKHUD

class ModifyPasswordViewController: BaseViewController {
    
    let oldPassordView = SingleInputView.init()
    let new1PasswordView = SingleInputView.init()
    let new2PasswordView = SingleInputView.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        sentupViews()
    }
    
    func sentupViews() {
        
        oldPassordView.configInputView(titleStr: "请输入原密码:", contentStr: "")
        oldPassordView.inputTextfield.isSecureTextEntry = true
        view.addSubview(oldPassordView)
        
        oldPassordView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(64)
            make.height.equalTo(44)
        }
        
        new1PasswordView.configInputView(titleStr: "请输入新密码:", contentStr: "")
        new1PasswordView.inputTextfield.isSecureTextEntry = true
        view.addSubview(new1PasswordView)
        
        new1PasswordView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(oldPassordView.snp.bottom).offset(24)
            make.height.equalTo(44)
        }
        
        new2PasswordView.configInputView(titleStr: "请再次输入密码:", contentStr: "")
        new2PasswordView.inputTextfield.isSecureTextEntry = true
        view.addSubview(new2PasswordView)
        
        new2PasswordView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(new1PasswordView.snp.bottom).offset(24)
            make.height.equalTo(44)
        }
        
        let confirmButton = UIButton.init(type: .custom)
        confirmButton.setTitle("确定", for: .normal)
        confirmButton.layer.cornerRadius = 20
        confirmButton.backgroundColor = SGColor.SGMainColor()
        confirmButton.addTarget(self, action:#selector(confirmButtonClick), for: .touchUpInside)
        view.addSubview(confirmButton)
        
        
        confirmButton.snp.makeConstraints { (make) in
            make.left.equalTo(4)
            make.bottom.equalTo(-4)
            make.height.equalTo(44)
            make.right.equalTo(-4)
        }
    }
    
    //MARK:- Action
    func confirmButtonClick() {
        print("confirmButtonClick")
        if !checkSubmitValid() {
            return
        }
        HUD.flash(.label("修改密码成功"), delay: 2)
    }

    func checkSubmitValid() -> Bool {
        if !oldPassordView.getSumbitValid() {
            new2PasswordView.setErrorContent(error: "请输入原始密码")
            return false
        }
        
        if !new1PasswordView.getSumbitValid() {
            new1PasswordView.setErrorContent(error: "请输入新密码")
            return false
        }
        
        if !new2PasswordView.getSumbitValid() {
            new2PasswordView.setErrorContent(error: "请输入新密码")
            return false
        }
        
        if new1PasswordView.getInputContent() != new2PasswordView.getInputContent() {
            new1PasswordView.setErrorContent(error: "")
            new2PasswordView.setErrorContent(error: "两次密码不一致")
            return false
        }
        oldPassordView.setErrorContent(error: nil)
        new1PasswordView.setErrorContent(error: nil)
        new2PasswordView.setErrorContent(error: nil)

        return true
    }
}
