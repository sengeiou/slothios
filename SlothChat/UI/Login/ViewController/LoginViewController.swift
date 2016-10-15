//
//  LoginViewController.swift
//  Chat
//
//  Created by Fly on 16/10/13.
//  Copyright © 2016年 Fly. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    let phoneView = SingleInputView.init()
    let passwordView = SingleInputView.init()
    let codeButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sentupViews()
    }
    
    func sentupViews() {
        let iconView = IconTitleView.init(frame: CGRect.zero)
        view.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(60)
            make.top.equalTo(100)
        }
        
        phoneView.configInputView(titleStr: "手机号:", contentStr: "")
        configPhoneInputView(inputView: phoneView)
        phoneView.inputTextfield.keyboardType = .numberPad
        view.addSubview(phoneView)
        
        passwordView.configInputView(titleStr: "密码:", contentStr: "")
        passwordView.inputTextfield.isSecureTextEntry = true
        view.addSubview(passwordView)
        
        let forgetButton = UIButton(type: .custom)
        forgetButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        forgetButton.contentMode = .left
        forgetButton.setTitle("忘记密码?", for: .normal)
        forgetButton.setTitleColor(SGColor.SGMainColor(), for: .normal)
        forgetButton.addTarget(self, action:#selector(forgetButtonClick), for: .touchUpInside)
        
        view.addSubview(forgetButton)
        
        phoneView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(iconView.snp.bottom).offset(100)
            make.height.equalTo(44)
        }
        
        passwordView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(phoneView.snp.bottom).offset(24)
            make.height.equalTo(44)
        }
        
        forgetButton.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.top.equalTo(passwordView.snp.bottom).offset(-4)
            make.height.equalTo(44)
            make.width.equalTo(80)
        }
        
        let loginButton = UIButton.init(type: .custom)
        loginButton.setTitle("登录", for: .normal)
        loginButton.layer.cornerRadius = 20
        loginButton.backgroundColor = SGColor.SGMainColor()
        loginButton.addTarget(self, action:#selector(loginButtonClick), for: .touchUpInside)
        view.addSubview(loginButton)
        
        let registerButton = UIButton.init(type: .custom)
        registerButton.setTitle("注册", for: .normal)
        registerButton.setTitleColor(SGColor.SGMainColor(), for: .normal)
        registerButton.addTarget(self, action:#selector(registerButtonClick), for: .touchUpInside)
        
        view.addSubview(registerButton)
        
        
        
        
        loginButton.snp.makeConstraints { (make) in
            make.left.equalTo(4)
            make.bottom.equalTo(-4)
            make.height.equalTo(44)
            make.right.equalTo(registerButton.snp.left).offset(4)
            make.width.equalTo(registerButton.snp.width).dividedBy(0.668)
        }
        
        registerButton.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(-4)
            make.height.equalTo(44)
            make.right.equalTo(loginButton.snp.right).offset(-4)
        }
    }
    
    func configPhoneInputView(inputView : SingleInputView) {
        let leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 44, height: 44))
        codeButton.frame = leftView.bounds
        codeButton.setTitleColor(UIColor.black, for: .normal)
        codeButton.setTitle("+86", for: .normal)
        codeButton.addTarget(self, action:#selector(codeButtonClick), for: .touchUpInside)
        leftView.addSubview(codeButton)
        
        inputView.inputTextfield.leftView = leftView
        inputView.inputTextfield.leftViewMode = .always
        
    }
    
    //MARK:- Action
    
    func forgetButtonClick() {
        print("forgetButtonClick")

    }
    
    func loginButtonClick() {
        print("loginButtonClick")
        //        let codeStr = codeView.getInputContent()
        //        if (codeStr?.isEmpty)! {
        //            print("请选择国家码")
        //            return
        //        }
        //
        //        let phoneStr = phoneView.getInputContent()
        //        if (phoneStr?.isEmpty)! {
        //            print("请输入手机号")
        //            return
        //        }
        //
        //        let passwordStr = passwordView.getInputContent()
        //        if (passwordStr?.isEmpty)! {
        //            print("请输入密码")
        //            return
        //        }
        print("登录成功")
    }
    
    func registerButtonClick() {
        print("registerButtonClick")
        navigationController?.popViewController(animated: true)
    }
    
    func codeButtonClick() {
        let pushVC  = CountryCodeViewController.init()
        navigationController?.pushViewController(pushVC, animated: true)
        pushVC.setClosurePass { (code) in
            self.codeButton.setTitle("+" + code, for: .normal)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }

}
