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
    let codeButton = UIButton(type: .custom)

    var timeout = 0

    public var countryName = "CN"
    public var countryCode = "86"{
        didSet{
            codeButton.setTitle("+" + countryCode, for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let lastCountryName = GVUserDefaults.standard().lastCountryName,
            let lastCountryCode = GVUserDefaults.standard().lastCountryCode {
            countryName = lastCountryName
            countryCode = lastCountryCode
        }
        sentupViews()
    }

    func sentupViews() {
        view.backgroundColor = UIColor.white

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
        passwordView.configInputView(titleStr: "创建密码:", contentStr: "")
        passwordView.inputTextfield.isSecureTextEntry = true
        view.addSubview(passwordView)
        
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
        
        let registerButton = UIButton.init(type: .custom)
        registerButton.layer.cornerRadius = 23
        registerButton.setTitle("注册", for: .normal)
        registerButton.backgroundColor = SGColor.SGMainColor()
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        registerButton.addTarget(self, action:#selector(registerButtonClick), for: .touchUpInside)
        view.addSubview(registerButton)
        
        let loginButton = UIButton.init(type: .custom)
        loginButton.setTitle("返回登录", for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        loginButton.setTitleColor(SGColor.SGMainColor(), for: .normal)
        loginButton.addTarget(self, action:#selector(loginButtonClick), for: .touchUpInside)
        loginButton.layer.borderColor = SGColor.SGMainColor().cgColor
        loginButton.layer.borderWidth = 1.0
        loginButton.layer.cornerRadius = 23
        view.addSubview(loginButton)
        
        registerButton.snp.makeConstraints { (make) in
            make.left.equalTo(80)
            make.right.equalTo(-80)
            make.height.equalTo(46)
            make.bottom.equalTo(loginButton.snp.top).offset(-10)
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.left.equalTo(80)
            make.right.equalTo(-80)
            make.height.equalTo(46)
            make.bottom.equalTo(-16)
        }
        
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
    
    //MARK:- Action
    func registerButtonClick() {
        SGLog(message: "registerButtonClick")
        if !checkDataValid(){
            return
        }
        
        let phoneStr = phoneView.getInputContent()!
        let codeStr = self.countryCode
        let passwordStr = passwordView.getInputContent()!
        
        let pushVC  = CaptchaViewController.init()
        pushVC.registerVC = self
        pushVC.phoneNo = phoneStr
        pushVC.codeNo = codeStr
        pushVC.password = passwordStr
        pushVC.countryName = countryName
        pushVC.countryCode = countryCode
        navigationController?.pushViewController(pushVC, animated: true)
        
    }
    
    func loginButtonClick() {
        SGLog(message: "loginButtonClick")
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
