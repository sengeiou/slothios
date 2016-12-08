//
//  LoginViewController.swift
//  Chat
//
//  Created by Fly on 16/10/13.
//  Copyright © 2016年 Fly. All rights reserved.
//

import UIKit
import AwesomeCache

class LoginViewController: BaseViewController {

    let phoneView = SingleInputView.init()
    let passwordView = SingleInputView.init()
    let codeButton = UIButton(type: .custom)
    
    var timeout = 0
    
    public var countryName = "CN"
    public var countryCode = "86"{
        didSet{
            codeButton.setTitle("+" + countryCode, for: .normal)
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if let lastCountryName = GVUserDefaults.standard().lastCountryName,
//            let lastCountryCode = GVUserDefaults.standard().lastCountryCode,
//            let lastLoginPhone = GVUserDefaults.standard().lastLoginPhone{
//            countryName = lastCountryName
//            countryCode = lastCountryCode
//            phoneView.configContent(contentStr: lastLoginPhone)
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let lastCountryName = GVUserDefaults.standard().lastCountryName,
           let lastCountryCode = GVUserDefaults.standard().lastCountryCode {
            countryName = lastCountryName
            countryCode = lastCountryCode
        }else{
            getCountryCodeList()
        }
        sentupViews()
    }
    
    func sentupViews() {
        
        let iconView = IconTitleView.init(frame: CGRect.zero)
        view.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(100)
            make.size.equalTo(CGSize.init(width: 55, height: 55))
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
            make.top.equalTo(passwordView.snp.bottom).offset(12)
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
        registerButton.setTitle("去注册", for: .normal)
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        registerButton.setTitleColor(SGColor.SGMainColor(), for: .normal)
        registerButton.addTarget(self, action:#selector(registerButtonClick), for: .touchUpInside)
        registerButton.layer.borderColor = SGColor.SGMainColor().cgColor
        registerButton.layer.borderWidth = 1.0
        registerButton.layer.cornerRadius = 23

        view.addSubview(registerButton)
        
        loginButton.snp.makeConstraints { (make) in
            make.left.equalTo(80)
            make.right.equalTo(-80)
            make.height.equalTo(46)
            make.bottom.equalTo(registerButton.snp.top).offset(-10)
        }
        
        registerButton.snp.makeConstraints { (make) in
            make.left.equalTo(80)
            make.right.equalTo(-80)
            make.height.equalTo(46)
            make.bottom.equalTo(-16)
        }
        
        #if DEBUG
        self.phoneView.inputTextfield.text = "189120"
        self.passwordView.inputTextfield.text = "A123456"
        #endif  
    }
    
    func configPhoneInputView(inputView : SingleInputView) {
        let leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 64, height: 44))
        codeButton.frame = leftView.bounds
        codeButton.setTitleColor(SGColor.SGBlueColor(), for: .normal)
        codeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        codeButton.addTarget(self, action:#selector(codeButtonClick), for: .touchUpInside)
        leftView.addSubview(codeButton)
        
        let line = UIView.init(frame: CGRect.init(x: 52, y: 6, width: 1, height: 32))
        line.backgroundColor = SGColor.SGLineColor()
        leftView.addSubview(line)
        
        inputView.inputTextfield.leftView = leftView
        inputView.inputTextfield.leftViewMode = .always
        
    }
    //MARK:- Network
    
    func getUserProfile(userUuid: String) {
        let engine = NetworkEngine()
        engine.getUserProfile(userUuid: userUuid) { (response) in
            if response?.status == ResponseError.SUCCESS.0 {
                Global.shared.globalProfile = response?.data
//                self.loginSystem()
                self.getChatToken()
            }else{
                self.showNotificationError(message: response?.msg)
            }
        }
    }

    func getChatToken() {
        let engine = NetworkEngine()
        engine.getChatToken() { (response) in
            self.hiddenNotificationProgress(animated: false)
            if response?.status == ResponseError.SUCCESS.0{
                if let token = response?.data?.chatToken {
                    Global.shared.chatToken = token
                    self.loginSystem()
                }
            }else{
                self.showNotificationError(message: response?.msg)
            }
        }
    }
    
    func getCountryCodeList() {
        let engine = NetworkEngine()
        engine.getPublicCountry(withName: "") { (response) in
            if response?.status == ResponseError.SUCCESS.0,
               let list = response?.data?.list {
                response?.caheForCountryCode()
                let regionCode = Locale.current.regionCode
                for obj in list{
                    if obj.name == regionCode{
                        GVUserDefaults.standard().lastCountryName = obj.name
                        GVUserDefaults.standard().lastCountryCode = obj.telPrefix
                        self.countryName = obj.name!
                        self.countryCode = obj.telPrefix!
                        SGLog(message: obj.display)
                        break
                    }
                }
            }
        }
    }
    
    //MARK:- Action
    
    func forgetButtonClick() {
        SGLog(message: "forgetButtonClick")
        let phoneStr = phoneView.getInputContent()
        if (phoneStr?.isEmpty)! {
            showNotificationError(message: "请输入手机号")
            return
        }
        
        let code = self.countryCode
        
        let pushVC  = FindPasswordViewController.init()
        pushVC.loginVC = self
        pushVC.phoneNo = phoneStr!
        pushVC.codeNo = code
        navigationController?.pushViewController(pushVC, animated: true)
    }
    
    func loginButtonClick() {

        SGLog(message: "loginButtonClick")

        if !checkDataValid(){
            return
        }
        let phoneStr = phoneView.getInputContent()!
        let codeStr = self.countryCode
        let passwordStr = passwordView.getInputContent()!
        
        let engine = NetworkEngine()
        self.showNotificationProgress()
        engine.postAuthLogin(withMobile: codeStr + phoneStr, passwd: passwordStr) { (response) in
            self.hiddenNotificationProgress(animated: false)
            if  response != nil &&
                response?.token != nil{
                GVUserDefaults.standard().lastLoginPhone = phoneStr
                GVUserDefaults.standard().lastCountryCode = codeStr
                Global.shared.globalLogin = response!
                
                if (response!.user?.uuid) != nil{
                    NBSAppAgent.setCustomerData((response!.user?.uuid)!, forKey: "LoginUserUuid")
                }
                if (response!.user?.username) != nil{
                    NBSAppAgent.setCustomerData((response!.user?.username)!, forKey: "LoginUserName")
                }
                Global.shared.chatToken = response!.chatToken
                self.getUserProfile(userUuid: (response!.user?.uuid)!)
            }else{
                self.showNotificationError(message: response?.msg)
            }
        }
    }
    
    func loginSystem() {
        
        do {
            let cache = try Cache<NSString>(name: SGGlobalKey.SCCacheName)
            cache[SGGlobalKey.SCLoginStatusKey] = true.description as NSString?
            NotificationCenter.default.post(name: SGGlobalKey.LoginStatusDidChange, object: nil)
        } catch _ {
            SGLog(message: "Something went wrong :(")
        }
    }
    
    func checkDataValid() -> Bool {
        let phoneStr = phoneView.getInputContent()
        if (phoneStr?.isEmpty)! {
            showNotificationError(message: "请输入手机号")
            return false
        }
        
        if !Validate.phoneNum(phoneStr!).isRight{
            showNotificationError(message: "手机号码为6到11位")
            return false
        }

        let code = self.countryCode
        if (code.isEmpty) {
            showNotificationError(message: "请选择国家码")
            return false
        }
        let passwordStr = passwordView.getInputContent()
        if (passwordStr?.isEmpty)! {
            showNotificationError(message: "请输入密码")
            return false
        }
        
        return true
    }
    
    func registerButtonClick() {
        SGLog(message: "registerButtonClick")
        let pushVC  = RegisterViewController.init()
        navigationController?.pushViewController(pushVC, animated: true)
    }
    
    func codeButtonClick() {
        let pushVC  = CountryCodeViewController.init()
        navigationController?.pushViewController(pushVC, animated: true)
        pushVC.setClosurePass { (tmpCountry) in
            self.countryName = tmpCountry.name!
            self.countryCode = tmpCountry.telPrefix!
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }

}
