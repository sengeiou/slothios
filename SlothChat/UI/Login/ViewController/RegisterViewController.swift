//
//  RegisterViewController.swift
//  Chat
//
//  Created by Fly on 16/10/13.
//  Copyright © 2016年 Fly. All rights reserved.
//

import UIKit
import SnapKit
import PKHUD

class RegisterViewController: BaseViewController {
    let codeView = SingleInputView.init(type : .button)
    let phoneView = SingleInputView.init()
    let passwordView = SingleInputView.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sentupViews()
    }

    func sentupViews() {
        view.backgroundColor = UIColor.white

        let iconView = IconTitleView.init(frame: CGRect.zero)
        view.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(100)
            make.size.equalTo(CGSize.init(width: 184, height: 55))
        }
       
        codeView.setClosurePass {
            self.pushCountryCode()
        }
        
        codeView.titleLabel.font = UIFont.systemFont(ofSize: 17)
        codeView.inputTextfield.font = UIFont.systemFont(ofSize: 17)
        codeView.setInputTextfieldLeftMagin(left: 106)
        codeView.configInputView(titleStr: "国家区号:", contentStr: "86")
        view.addSubview(codeView)
        
        phoneView.titleLabel.font = UIFont.systemFont(ofSize: 17)
        phoneView.inputTextfield.font = UIFont.systemFont(ofSize: 17)
        phoneView.setInputTextfieldLeftMagin(left: 106)
        phoneView.configInputView(titleStr: "手机号:", contentStr: "18667931202")
        phoneView.inputTextfield.keyboardType = .numberPad

        view.addSubview(phoneView)
        
        passwordView.titleLabel.font = UIFont.systemFont(ofSize: 17)
        passwordView.inputTextfield.font = UIFont.systemFont(ofSize: 17)
        passwordView.setInputTextfieldLeftMagin(left: 106)
        passwordView.configInputView(titleStr: "密码:", contentStr: "")
        passwordView.inputTextfield.isSecureTextEntry = true
        view.addSubview(passwordView)

        codeView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(iconView.snp.bottom).offset(88)
            make.height.equalTo(60)
        }
        
        phoneView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(codeView.snp.bottom).offset(19)
            make.height.equalTo(60)
        }
        
        passwordView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(phoneView.snp.bottom).offset(19)
            make.height.equalTo(60)
        }
        
        let registerButton = UIButton.init(type: .custom)
        registerButton.layer.cornerRadius = 23
        registerButton.setTitle("注册", for: .normal)
        registerButton.backgroundColor = SGColor.SGMainColor()
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        registerButton.addTarget(self, action:#selector(registerButtonClick), for: .touchUpInside)
        view.addSubview(registerButton)
        
        let loginButton = UIButton.init(type: .custom)
        loginButton.setTitle("登录", for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        loginButton.setTitleColor(SGColor.SGMainColor(), for: .normal)
        loginButton.addTarget(self, action:#selector(loginButtonClick), for: .touchUpInside)
        
        view.addSubview(loginButton)
        
        registerButton.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.bottom.equalTo(-10)
            make.height.equalTo(46)
            make.right.equalTo(loginButton.snp.left)
            make.width.equalTo(loginButton.snp.width).dividedBy(0.668)
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.right.equalTo(-8)
            make.bottom.equalTo(-10)
            make.height.equalTo(46)
            make.right.equalTo(registerButton.snp.right)
        }
    }
    
    //MARK:- Action
    func registerButtonClick() {
        print("registerButtonClick")
        let codeStr = codeView.getInputContent()
        if (codeStr?.isEmpty)! {
//            HUD.flash(.label("请选择国家码"), delay: 2)
            codeView.setErrorContent(error: "请选择国家码")
            return
        }
        
        let phoneStr = phoneView.getInputContent()
        if (phoneStr?.isEmpty)! {
//            HUD.flash(.label("请输入手机号"), delay: 2)
            phoneView.setErrorContent(error: "请输入手机号")
            return
        }
        
        let passwordStr = passwordView.getInputContent()
        if (passwordStr?.isEmpty)! {
//            HUD.flash(.label("请输入密码"), delay: 2)
            passwordView.setErrorContent(error: "请输入密码")
            return
        }
        
        let pushVC  = CaptchaViewController.init()
        pushVC.phoneNo = codeStr! + phoneStr!
        navigationController?.pushViewController(pushVC, animated: true)
        
    }
    
    func loginButtonClick() {
        print("loginButtonClick")
        var loginVC : UIViewController?
        let arrayOfVCs = navigationController?.viewControllers
        
        for subvc in arrayOfVCs! {
            if subvc.isKind(of: LoginViewController.self) {
                loginVC = subvc
            }
        }
        if loginVC != nil {
            _ = navigationController?.popViewController(animated: true)
        }else{
            let pushVC  = LoginViewController.init()
            navigationController?.pushViewController(pushVC, animated: true)
        }
        
    }
    
    func pushCountryCode() {
        let pushVC  = CountryCodeViewController.init()
        navigationController?.pushViewController(pushVC, animated: true)
        pushVC.setClosurePass { (code) in
            self.codeView.configContent(contentStr: code)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    
}
