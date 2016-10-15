//
//  RegisterViewController.swift
//  Chat
//
//  Created by Fly on 16/10/13.
//  Copyright © 2016年 Fly. All rights reserved.
//

import UIKit
import SnapKit

class RegisterViewController: BaseViewController {
    let codeView = SingleInputView.init(type : .button)
    let phoneView = SingleInputView.init()
    let passwordView = SingleInputView.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sentupViews()
    }

    func sentupViews() {
        let iconImgView = UIImageView.init(image: UIImage.init(named: ""))
        view.addSubview(iconImgView)
        
        let titleLabel = UILabel.init()
//        titleLabel.text = "树懒"
        titleLabel.font = UIFont.systemFont(ofSize: 24)
        titleLabel.textColor = UIColor.red
        view.addSubview(titleLabel)
        
        iconImgView.snp.makeConstraints { (make) in
            make.top.equalTo(100)
            make.centerX.equalTo(self.view).offset(-40)
        }
        titleLabel.snp.makeConstraints  { (make) in
            make.left.equalTo(iconImgView.snp.right).offset(40)
            make.centerY.equalTo(iconImgView.snp.centerY)
        }
        
       
        codeView.setClosurePass {
            self.pushCountryCode()
        }
        codeView.configInputView(titleStr: "国家区号:", contentStr: "+1")
        view.addSubview(codeView)
        
        phoneView.configInputView(titleStr: "手机号:", contentStr: "")
        view.addSubview(phoneView)
        
        passwordView.configInputView(titleStr: "密码:", contentStr: "")
        passwordView.inputTextfield.isSecureTextEntry = true
        view.addSubview(passwordView)
        
        codeView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(180)
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
            make.left.equalTo(4)
            make.bottom.equalTo(-4)
            make.height.equalTo(44)
            make.right.equalTo(loginButton.snp.left).offset(4)
            make.width.equalTo(loginButton.snp.width).dividedBy(0.668)
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(-4)
            make.height.equalTo(44)
            make.right.equalTo(registerButton.snp.right).offset(-4)
        }
    }
    
    //MARK:- Action
    func registerButtonClick() {
        print("registerButtonClick")
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
        let pushVC  = PerfectionInfoViewController.init()
        navigationController?.pushViewController(pushVC, animated: true)
    }
    
    func loginButtonClick() {
        print("loginButtonClick")
        let pushVC  = LoginViewController.init()
        navigationController?.pushViewController(pushVC, animated: true)
    }
    
    func pushCountryCode() {
        let pushVC  = CountryCodeViewController.init()
        navigationController?.pushViewController(pushVC, animated: true)
        pushVC.setClosurePass { (code) in
            self.codeView.configInputView(titleStr: "国家区号:", contentStr: code)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    
}
