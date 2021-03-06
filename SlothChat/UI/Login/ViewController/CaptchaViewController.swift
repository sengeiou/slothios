//
//  CaptchaViewController.swift
//  SlothChat
//
//  Created by Fly on 16/10/16.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class CaptchaViewController: BaseViewController {
    var timer = Timer()
    var registerVC: RegisterViewController?

    public var phoneNo: String!
    public var codeNo: String!
    public var password: String!
    public var countryName: String!
    public var countryCode: String!


    let tipLabel = UILabel.init()
    let captchaView = SingleInputView.init()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !(phoneNo?.isEmpty)! {
            self.fireTimer()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if timer.isValid {
            timer.invalidate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sentupViews()
        getPublicSMS()
    }
    
    func sentupViews() {
        let iconView = IconTitleView.init(frame: CGRect.zero)
        view.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(100)
            make.size.equalTo(CGSize.init(width: 55, height: 55))
        }
        
        tipLabel.numberOfLines = 0
        tipLabel.lineBreakMode = .byCharWrapping
        view.addSubview(tipLabel)

        tipLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(iconView.snp.bottom).offset(100)
        }
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(getPublicSMS))
        tipLabel.addGestureRecognizer(tap)
        tipLabel.isUserInteractionEnabled = true
        
        captchaView.titleLabel.font = UIFont.systemFont(ofSize: 17)
        captchaView.inputTextfield.font = UIFont.systemFont(ofSize: 17)
        captchaView.setInputTextfieldLeftMagin(left: 106)
        captchaView.configInputView(titleStr: "验证码:", contentStr: "")
        captchaView.inputTextfield.keyboardType = .numberPad
        view.addSubview(captchaView)
        
        captchaView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(tipLabel.snp.bottom).offset(48)
            make.height.equalTo(44)
        }
        
        let confirmButton = UIButton.init(type: .custom)
        confirmButton.setTitle("确认", for: .normal)
        confirmButton.layer.cornerRadius = 20
        confirmButton.backgroundColor = SGColor.SGMainColor()
        confirmButton.addTarget(self, action:#selector(confirmButtonClick), for: .touchUpInside)
        view.addSubview(confirmButton)
        
        
//        confirmButton.snp.makeConstraints { (make) in
//            make.bottom.equalTo(-10)
//            make.height.equalTo(44)
//            make.left.lessThanOrEqualTo(80)
//            make.right.greaterThanOrEqualTo(-80)
//        }
        
        let loginButton = UIButton.init(type: .custom)
        loginButton.setTitle("返回", for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        loginButton.setTitleColor(SGColor.SGMainColor(), for: .normal)
        loginButton.addTarget(self, action:#selector(loginButtonClick), for: .touchUpInside)
        loginButton.layer.borderColor = SGColor.SGMainColor().cgColor
        loginButton.layer.borderWidth = 1.0
        loginButton.layer.cornerRadius = 23
        view.addSubview(loginButton)
        
        confirmButton.snp.makeConstraints { (make) in
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
    
    //Mark:- Network
    
    func getPublicSMS() {
        if registerVC!.timeout > 0 &&
           registerVC?.timeout != 60 {
            return
        }
        
        let engine = NetworkEngine()
        self.showNotificationProgress()
        engine.postPublicSMS(withType: "signup", toPhoneno: codeNo + phoneNo) { (response) in
            self.hiddenNotificationProgress(animated: false)
            if response?.status == ResponseError.SUCCESS.0 &&
                !(self.phoneNo.isEmpty) {
                self.fireTimer()
            }else{
                if response?.status == ResponseError.USER_NOT_REGISTER.0 ||
                   response?.status == ResponseError.USER_DID_REGISTER.0{
                    let popVC = self.navigationController?.popViewController(animated: true)
                    popVC?.showNotificationError(message: response?.msg)
                }else{
                    self.update()
                    self.showNotificationError(message: response?.msg)
                }
            }
        }
    }
    
    func checkPublicSMS(phoneNo: String,verifyCode: String) {
        let engine = NetworkEngine()
        self.showNotificationProgress()
        engine.postPublicSMSCheck(WithPhoneNumber: phoneNo,verifyCode:verifyCode) { (response) in
            self.hiddenNotificationProgress(animated: false)
            if response?.status == ResponseError.SUCCESS.0{
                let pushVC  = PerfectionInfoViewController.init()
                pushVC.phoneNo = self.phoneNo
                pushVC.password = self.password
                pushVC.countryName = self.countryName
                pushVC.countryCode = self.countryCode
                self.navigationController?.pushViewController(pushVC, animated: true)
            }else{
                self.showNotificationError(message: response?.msg)
            }
            
        }
    }
    
    func update() {
        let string1 = "已经向您的手机+" + codeNo + "-" + phoneNo! + "发送验证码。\n"
        let timeStr = String(registerVC!.timeout)
        let string2 = "如果" + timeStr + "秒后未收到验证码，再次申请。"
        let range = NSRange.init(location: string1.characters.count + 2, length: timeStr.characters.count)
        
        let attributedText = NSMutableAttributedString.init(string: string1 + string2)
        attributedText.addAttribute(NSForegroundColorAttributeName, value: SGColor.SGBlueColor(), range: range)
        tipLabel.attributedText = attributedText
        
        registerVC!.timeout -= 1
        if registerVC!.timeout <= 0 {
            registerVC!.timeout = 60
            let string3 = string1 + "未收到验证码，"
            let string4 = "重新申请验证码。"
            let range = NSRange.init(location: string3.characters.count, length: string4.characters.count)
            
            let attributedText = NSMutableAttributedString.init(string: string3 + string4)
            attributedText.addAttribute(NSForegroundColorAttributeName, value: SGColor.SGBlueColor(), range: range)
            tipLabel.attributedText = attributedText
            
            timer.invalidate()
        }
    }
    
    func fireTimer() {
        if registerVC!.timeout > 0 && timer.isValid {
            return
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true);
        timer.fire()
    }
    
    //MARK:- Action
    func confirmButtonClick() {
        SGLog(message: "confirmButtonClick")
        
        let captcha = captchaView.getInputContent()
        if (captcha?.isEmpty)! {
            self.showNotificationError(message: "请输入验证码")
            return
        }
        
        checkPublicSMS(phoneNo: codeNo + phoneNo, verifyCode: captcha!)
        
    }
    
    func loginButtonClick() {
        _ = navigationController?.popViewController(animated: true)
    }
}
