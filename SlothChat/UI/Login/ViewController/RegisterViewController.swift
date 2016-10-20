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
        let iconView = IconTitleView.init(frame: CGRect.zero)
        view.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(60)
            make.top.equalTo(100)
        }
        
       
        codeView.setClosurePass {
            self.pushCountryCode()
        }
        codeView.configInputView(titleStr: "国家区号:", contentStr: "+1")
        view.addSubview(codeView)
        
        phoneView.configInputView(titleStr: "手机号:", contentStr: "")
        phoneView.inputTextfield.keyboardType = .numberPad

        view.addSubview(phoneView)
        
        passwordView.configInputView(titleStr: "密码:", contentStr: "")
        passwordView.inputTextfield.isSecureTextEntry = true
        view.addSubview(passwordView)

        
        
        codeView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(iconView.snp.bottom).offset(100)
            make.height.equalTo(44)
        }
        
        phoneView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(codeView.snp.bottom).offset(24)
            make.height.equalTo(44)
        }
        
        passwordView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(phoneView.snp.bottom).offset(24)
            make.height.equalTo(44)
        }
        
        let registerButton = UIButton.init(type: .custom)
        registerButton.setTitle("注册", for: .normal)
        registerButton.layer.cornerRadius = 20
        registerButton.backgroundColor = SGColor.SGMainColor()
        registerButton.addTarget(self, action:#selector(registerButtonClick), for: .touchUpInside)
        view.addSubview(registerButton)
        
        let loginButton = UIButton.init(type: .custom)
        loginButton.setTitle("登录", for: .normal)
        loginButton.setTitleColor(SGColor.SGMainColor(), for: .normal)
        loginButton.addTarget(self, action:#selector(loginButtonClick), for: .touchUpInside)

        view.addSubview(loginButton)
        
        registerButton.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.bottom.equalTo(-10)
            make.height.equalTo(44)
            make.right.equalTo(loginButton.snp.left).offset(10)
            make.width.equalTo(loginButton.snp.width).dividedBy(0.668)
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(-10)
            make.height.equalTo(44)
            make.right.equalTo(registerButton.snp.right).offset(-10)
        }
    }
    
    //MARK:- Action
    func registerButtonClick() {
        print("registerButtonClick")
        let codeStr = codeView.getInputContent()
        if (codeStr?.isEmpty)! {
            HUD.flash(.label("请选择国家码"), delay: 2)
            return
        }
        
        let phoneStr = phoneView.getInputContent()
        if (phoneStr?.isEmpty)! {
            HUD.flash(.label("请输入手机号"), delay: 2)
            return
        }
        
        let passwordStr = passwordView.getInputContent()
        if (passwordStr?.isEmpty)! {
            HUD.flash(.label("请输入密码"), delay: 2)
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
            self.codeView.configContent(contentStr: "+" + code)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    
}
