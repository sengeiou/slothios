//
//  FindPasswordViewController.swift
//  SlothChat
//
//  Created by Fly on 16/10/16.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import PKHUD
import AwesomeCache

class FindPasswordViewController: BaseViewController {
    var timer = Timer()
    var loginVC: LoginViewController?
    
    var phoneNo:String?
    var codeNo:String?

    let tipLabel = UILabel.init()
    let captchaView = SingleInputView.init()
    let passwordView = SingleInputView.init()
    
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
        let scrollView = UIScrollView()
        let container = UIView()
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        scrollView.addSubview(container)
        container.snp.makeConstraints { (make) in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        let iconView = IconTitleView.init(frame: CGRect.zero)
        container.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(100)
            make.size.equalTo(CGSize.init(width: 55, height: 55))
        }
        
        tipLabel.numberOfLines = 0
        tipLabel.lineBreakMode = .byCharWrapping
        container.addSubview(tipLabel)
        
        tipLabel.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.right.equalTo(-8)
            make.top.equalTo(iconView.snp.bottom).offset(122)
        }
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(getPublicSMS))
        tipLabel.addGestureRecognizer(tap)
        tipLabel.isUserInteractionEnabled = true
        
        captchaView.titleLabel.font = UIFont.systemFont(ofSize: 17)
        captchaView.inputTextfield.font = UIFont.systemFont(ofSize: 17)
        captchaView.setInputTextfieldLeftMagin(left: 106)
        captchaView.configInputView(titleStr: "验证码:", contentStr: "")
        captchaView.inputTextfield.keyboardType = .numberPad
        container.addSubview(captchaView)
        
        captchaView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(tipLabel.snp.bottom).offset(36)
            make.height.equalTo(44)
        }
        
        passwordView.titleLabel.font = UIFont.systemFont(ofSize: 17)
        passwordView.inputTextfield.font = UIFont.systemFont(ofSize: 17)
        passwordView.setInputTextfieldLeftMagin(left: 106)
        passwordView.configInputView(titleStr: "新密码:", contentStr: "")
        passwordView.inputTextfield.isSecureTextEntry = true
        container.addSubview(passwordView)
        
        passwordView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(captchaView.snp.bottom).offset(20)
            make.height.equalTo(44)
        }
        
        container.snp.makeConstraints { (make) in
            make.bottom.equalTo(passwordView.snp.bottom).offset(80)
        }
        
        let confirmButton = UIButton.init(type: .custom)
        confirmButton.setTitle("登录", for: .normal)
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
    
    func update() {
        let string1 = "已经向您的手机+" + codeNo! + "-" + phoneNo! + "发送验证码。\n \n"
        let timeStr = String(loginVC!.timeout)
        let string2 = "如果" + timeStr + "秒后未收到验证码，再次申请。"
        let range = NSRange.init(location: string1.characters.count + 2, length: timeStr.characters.count)
        
        let attributedText = NSMutableAttributedString.init(string: string1 + string2)
        attributedText.addAttribute(NSForegroundColorAttributeName, value: SGColor.SGBlueColor(), range: range)
        tipLabel.attributedText = attributedText
        
        loginVC!.timeout -= 1
        if loginVC!.timeout <= 0 {
            loginVC!.timeout = 60
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
        if loginVC!.timeout > 0 && timer.isValid {
            return
        }
//        loginVC!.timeout = 60
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true);
        timer.fire()
    }
    
    //MARK:- NetWork
    
    func getPublicSMS() {
        if loginVC!.timeout > 0 &&
           loginVC?.timeout != 60{
            return
        }
        
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        engine.postPublicSMS(withType: "signup", toPhoneno: codeNo! + phoneNo!) { (response) in
            HUD.hide()
            if response?.status == ResponseError.SUCCESS.0 &&
                !((self.phoneNo?.isEmpty)!) {
                self.fireTimer()
            }else{
                self.update()
                self.showNotificationError(message: response?.msg)
            }
        }
    }
    
    func changeUserPassword(verifyCode: String,newPwd: String)  {
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))

        engine.postChangePwd(toPhoneno: codeNo! + phoneNo!, verifyCode: verifyCode, smsChangeNewPwd: newPwd) { (response) in
            HUD.hide()
            if response?.status == ResponseError.SUCCESS.0 {
                self.showAlertView(message: "成功修改密码")
                let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                    _ = self.navigationController?.popToRootViewController(animated: true)
                })
            }else{
                self.showNotificationError(message: response?.msg)
            }
        }
    }
    
    //MARK:- Action
    func confirmButtonClick() {
        print("confirmButtonClick")
        let captcha = captchaView.getInputContent()
        if (captcha?.isEmpty)! {
            self.showNotificationError(message: "请输入验证码")
            return
        }
        let password = passwordView.getInputContent()
        if (password?.isEmpty)! {
            self.showNotificationError(message: "请输入验证码")
            return
        }
        
        if !(password?.validString())!{
            self.showNotificationError(message: "6位字母数字组合并且至少包含1个大写字母")
            return
        }
        
        self.changeUserPassword(verifyCode: captcha!, newPwd: password!)
    }
    
}

