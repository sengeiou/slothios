//
//  LoginViewController.swift
//  Chat
//
//  Created by Fly on 16/10/13.
//  Copyright © 2016年 Fly. All rights reserved.
//

import UIKit
import PKHUD
import AwesomeCache

class LoginViewController: BaseViewController {

    let phoneView = SingleInputView.init()
    let passwordView = SingleInputView.init()
    let codeButton = UIButton(type: .custom)
    
    public var countryName = "cn"

    override func viewDidLoad() {
        super.viewDidLoad()
        sentupViews()
    }
    
    func sentupViews() {
        
        let iconView = IconTitleView.init(frame: CGRect.zero)
        view.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(100)
            make.size.equalTo(CGSize.init(width: 184, height: 55))
        }
        
        var phoneStr = GVUserDefaults.standard().lastLoginPhone
        if phoneStr == nil{
            phoneStr = ""
        }
        phoneView.setInputTextfieldLeftMagin(left: 106)
        phoneView.titleLabel.font = UIFont.systemFont(ofSize: 17)
        phoneView.inputTextfield.font = UIFont.systemFont(ofSize: 17)
        phoneView.configInputView(titleStr: "手机号:", contentStr: phoneStr!)
        configPhoneInputView(inputView: phoneView)
        phoneView.inputTextfield.keyboardType = .numberPad
        view.addSubview(phoneView)
        
        passwordView.titleLabel.font = UIFont.systemFont(ofSize: 17)
        passwordView.inputTextfield.font = UIFont.systemFont(ofSize: 17)
        passwordView.setInputTextfieldLeftMagin(left: 106)
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
            make.top.equalTo(iconView.snp.bottom).offset(88)
            make.height.equalTo(60)
        }
        
        passwordView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(phoneView.snp.bottom).offset(19)
            make.height.equalTo(60)
        }
        
        forgetButton.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.top.equalTo(passwordView.snp.bottom)
            make.size.equalTo(CGSize.init(width: 88, height: 38))
        }
        
        let loginButton = UIButton.init(type: .custom)
        loginButton.layer.cornerRadius = 23
        loginButton.setTitle("登录", for: .normal)
        loginButton.backgroundColor = SGColor.SGMainColor()
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        loginButton.addTarget(self, action:#selector(loginButtonClick), for: .touchUpInside)
        view.addSubview(loginButton)
        
        let registerButton = UIButton.init(type: .custom)
        registerButton.setTitle("注册", for: .normal)
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        registerButton.setTitleColor(SGColor.SGMainColor(), for: .normal)
        registerButton.addTarget(self, action:#selector(registerButtonClick), for: .touchUpInside)
        
        view.addSubview(registerButton)
        
        loginButton.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.bottom.equalTo(-10)
            make.height.equalTo(46)
            make.right.equalTo(registerButton.snp.left)
            make.width.equalTo(registerButton.snp.width).dividedBy(0.668)
        }
        
        registerButton.snp.makeConstraints { (make) in
            make.right.equalTo(-8)
            make.bottom.equalTo(-10)
            make.height.equalTo(46)
            make.right.equalTo(loginButton.snp.right)
        }
    }
    
    func configPhoneInputView(inputView : SingleInputView) {
        let leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 48, height: 44))
        codeButton.frame = leftView.bounds
        let codeStr = GVUserDefaults.standard().lastLoginCountry
        if codeStr == nil{
            codeButton.setTitle(codeStr, for: .normal)
        }else{
            codeButton.setTitle("86", for: .normal)
        }
        codeButton.setTitleColor(UIColor.black, for: .normal)
        codeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        codeButton.addTarget(self, action:#selector(codeButtonClick), for: .touchUpInside)
        leftView.addSubview(codeButton)
        
        let line = UIView.init(frame: CGRect.init(x: 44, y: 6, width: 1, height: 32))
        line.backgroundColor = SGColor.SGLineColor()
        leftView.addSubview(line)
        
        inputView.inputTextfield.leftView = leftView
        inputView.inputTextfield.leftViewMode = .always
        
    }
    //MARK:- Network
    
    func getUserProfile(userUuid: String) {
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        engine.getUserProfile(userUuid: userUuid) { (profile) in
            HUD.hide()
            if profile?.status == ResponseError.SUCCESS.0 {
                Global.shared.globalProfile = profile?.data
                self.loginSystem()
            }else{
                HUD.flash(.label("登录失败"), delay: 2)
            }
        }
    }

    
    
    //MARK:- Action
    
    func forgetButtonClick() {
        print("forgetButtonClick")
        let phoneStr = phoneView.getInputContent()
        if (phoneStr?.isEmpty)! {
            phoneView.setErrorContent(error: "请输入手机号")
            return
        }
        
        let code = self.codeButton.title(for: .normal)!
        
        let pushVC  = FindPasswordViewController.init()
        pushVC.phoneNo = code + phoneStr!
        navigationController?.pushViewController(pushVC, animated: true)
    }
    
    func loginButtonClick() {
        print("loginButtonClick")
        if !checkDataValid(){
            return
        }
        let phoneStr = phoneView.getInputContent()!
        let codeStr = self.codeButton.title(for: .normal)!
        let passwordStr = passwordView.getInputContent()!
        
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        engine.postAuthLogin(withMobile: codeStr + phoneStr, passwd: passwordStr) { (loginModel) in
            HUD.hide()
            if  loginModel != nil &&
                loginModel?.token != nil{
                GVUserDefaults.standard().lastLoginPhone = phoneStr
                GVUserDefaults.standard().lastLoginCountry = codeStr
                Global.shared.globalLogin = loginModel!
                self.getUserProfile(userUuid: (loginModel!.user?.uuid)!)
            }else{
                HUD.flash(.label("登录失败"), delay: 2)
            }
        }
    }
    
    func loginSystem() {
        
        do {
            let cache = try Cache<NSString>(name: SGGlobalKey.SCCacheName)
            cache[SGGlobalKey.SCLoginStatusKey] = true.description as NSString?
            NotificationCenter.default.post(name: SGGlobalKey.LoginStatusDidChange, object: nil)
        } catch _ {
            print("Something went wrong :(")
        }
    }
    
    func checkDataValid() -> Bool {
        let phoneStr = phoneView.getInputContent()
        if (phoneStr?.isEmpty)! {
            phoneView.setErrorContent(error: "请输入手机号")
            return false
        }
        
        let code = self.codeButton.title(for: .normal)
        if (code?.isEmpty)! {
            phoneView.setErrorContent(error: "请选择国家码")
            return false
        }
        let passwordStr = passwordView.getInputContent()
        if (passwordStr?.isEmpty)! {
            passwordView.setErrorContent(error: "请输入密码")
            return false
        }
        
        return true
    }
    
    func registerButtonClick() {
        print("registerButtonClick")
        let pushVC  = RegisterViewController.init()
        navigationController?.pushViewController(pushVC, animated: true)
    }
    
    func codeButtonClick() {
        let pushVC  = CountryCodeViewController.init()
        navigationController?.pushViewController(pushVC, animated: true)
        pushVC.setClosurePass { (tmpCountry) in
            self.countryName = tmpCountry.name!
            self.codeButton.setTitle(tmpCountry.telPrefix, for: .normal)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }

}
