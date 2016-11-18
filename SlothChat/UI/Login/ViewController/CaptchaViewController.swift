//
//  CaptchaViewController.swift
//  SlothChat
//
//  Created by Fly on 16/10/16.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import PKHUD

class CaptchaViewController: BaseViewController {
    var timer = Timer()
    var registerVC: RegisterViewController?

    public var phoneNo:String!
    public var codeNo:String!
    public var password:String!
    public var countryName = "cn"


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
            make.size.equalTo(CGSize.init(width: 184, height: 55))
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
        
        
        confirmButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(-10)
            make.height.equalTo(44)
            make.left.lessThanOrEqualTo(80)
            make.right.greaterThanOrEqualTo(-80)
        }
    }
    
    //Mark:- Network
    
    func getPublicSMS() {
        if registerVC!.timeout > 0 &&
           registerVC?.timeout != 60 {
            return
        }
        
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        engine.postPublicSMS(withType: "signup", toPhoneno: codeNo + phoneNo) { (sms) in
            HUD.hide()
            if sms?.status == ResponseError.SUCCESS.0 &&
                !(self.phoneNo.isEmpty) {
                self.fireTimer()
            }else{
                self.update()
                HUD.flash(.label(sms?.msg), delay: 2)
            }
        }
    }
    
    func checkPublicSMS(phoneNo: String,verifyCode: String) {
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        engine.postPublicSMSCheck(WithPhoneNumber: phoneNo,verifyCode:verifyCode) { (sms) in
            HUD.hide()
            if sms?.status == ResponseError.SUCCESS.0{
                let pushVC  = PerfectionInfoViewController.init()
                pushVC.phoneNo = self.codeNo + self.phoneNo
                pushVC.password = self.password
                pushVC.countryName = self.countryName
                self.navigationController?.pushViewController(pushVC, animated: true)
            }else{
                HUD.flash(.label(sms?.msg), delay: 2)
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
        print("confirmButtonClick")
        let captcha = captchaView.getInputContent()
        if (captcha?.isEmpty)! {
            HUD.flash(.label("请输入验证码"), delay: 2)
            return
        }
        
        checkPublicSMS(phoneNo: codeNo + phoneNo, verifyCode: captcha!)
        
    }
    
}
