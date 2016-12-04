//
//  ModifyPasswordViewController.swift
//  SlothChat
//
//  Created by Fly on 16/10/18.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class ModifyPasswordViewController: BaseViewController {
    
    let oldPassordView = SingleInputView.init()
    let new1PasswordView = SingleInputView.init()
    let new2PasswordView = SingleInputView.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        sentupViews()
    }
    
    func sentupViews() {
        
        oldPassordView.titleLabel.font = UIFont.systemFont(ofSize: 17)
        oldPassordView.inputTextfield.font = UIFont.systemFont(ofSize: 17)
        oldPassordView.setInputTextfieldLeftMagin(left: 142)
        oldPassordView.configInputView(titleStr: "请输入原密码:", contentStr: "")
        oldPassordView.inputTextfield.isSecureTextEntry = true
        view.addSubview(oldPassordView)
        
        oldPassordView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(64 + 16)
            make.height.equalTo(52)
        }
        
        new1PasswordView.titleLabel.font = UIFont.systemFont(ofSize: 17)
        new1PasswordView.inputTextfield.font = UIFont.systemFont(ofSize: 17)
        new1PasswordView.setInputTextfieldLeftMagin(left: 142)
        new1PasswordView.configInputView(titleStr: "请输入新密码:", contentStr: "")
        new1PasswordView.inputTextfield.isSecureTextEntry = true
        view.addSubview(new1PasswordView)
        
        new1PasswordView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(oldPassordView.snp.bottom).offset(16)
            make.height.equalTo(52)
        }
        
        new2PasswordView.titleLabel.font = UIFont.systemFont(ofSize: 17)
        new2PasswordView.inputTextfield.font = UIFont.systemFont(ofSize: 17)
        new2PasswordView.setInputTextfieldLeftMagin(left: 142)
        new2PasswordView.configInputView(titleStr: "请再次输入密码:", contentStr: "")
        new2PasswordView.inputTextfield.isSecureTextEntry = true
        view.addSubview(new2PasswordView)
        
        new2PasswordView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(new1PasswordView.snp.bottom).offset(16)
            make.height.equalTo(52)
        }
        
        let confirmButton = UIButton.init(type: .custom)
        confirmButton.setTitle("确定", for: .normal)
        confirmButton.layer.cornerRadius = 22
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        confirmButton.backgroundColor = SGColor.SGMainColor()
        confirmButton.addTarget(self, action:#selector(confirmButtonClick), for: .touchUpInside)
        view.addSubview(confirmButton)

        confirmButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(-8)
            make.height.equalTo(44)
            make.left.lessThanOrEqualTo(80)
            make.right.greaterThanOrEqualTo(-80)
        }
    }
    
    //MARK:- NetWork
    
    func modifyUserPassword(oldPwd: String,newPwd: String)  {
        let engine = NetworkEngine()
        engine.putUpdatePwd(oldPwd: oldPwd, newPwd: newPwd) { (response) in
            if response?.status == ResponseError.SUCCESS.0 {
                self.showAlertView(message: "修改密码成功")
            }else{
                self.showNotificationError(message: response?.msg)
            }
        }
    }
    
    //MARK:- Action
    func confirmButtonClick() {
        print("confirmButtonClick")
        if !checkSubmitValid() {
            return
        }
        let oldPwd = oldPassordView.getInputContent()
        let newPwd = new1PasswordView.getInputContent()

        self.modifyUserPassword(oldPwd: oldPwd!, newPwd: newPwd!)
    }

    func checkSubmitValid() -> Bool {
        if !oldPassordView.getSumbitValid() {
            showNotificationError(message: "请输入原始密码")
            return false
        }
        
        if !new1PasswordView.getSumbitValid() {
            showNotificationError(message: "请输入新密码")
            return false
        }
        
        if !new2PasswordView.getSumbitValid() {
            showNotificationError(message: "请输入新密码")
            return false
        }
        
        if !(oldPassordView.getInputContent()?.validString())!{
            showNotificationError(message: "旧密码需要6位字母数字组合并且至少包含1个大写字母")
            return false
        }
        
        if !(new1PasswordView.getInputContent()?.validString())!{
            showNotificationError(message: "新密码需要6位字母数字组合并且至少包含1个大写字母")
            return false
        }
        
        if !(new2PasswordView.getInputContent()?.validString())!{
            showNotificationError(message: "新密码需要6位字母数字组合并且至少包含1个大写字母")
            return false
        }
        
        if new1PasswordView.getInputContent() != new2PasswordView.getInputContent() {
            showNotificationError(message: "两次密码不一致")
            return false
        }

        return true
    }
}
