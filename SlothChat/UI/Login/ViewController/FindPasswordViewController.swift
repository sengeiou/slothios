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
    var timeout = 0
    
    var phoneNo:String?
    
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
    }
    
    func sentupViews() {
        let iconView = IconTitleView.init(frame: CGRect.zero)
        view.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(60)
            make.top.equalTo(100)
        }
        
        tipLabel.numberOfLines = 0
        tipLabel.lineBreakMode = .byCharWrapping
        view.addSubview(tipLabel)
        
        tipLabel.snp.makeConstraints { (make) in
            make.left.equalTo(4)
            make.right.equalTo(-4)
            make.top.equalTo(iconView.snp.bottom).offset(100)
        }
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(fireTimer))
        tipLabel.addGestureRecognizer(tap)
        tipLabel.isUserInteractionEnabled = true
        
        
        captchaView.configInputView(titleStr: "验证码:", contentStr: "")
        captchaView.inputTextfield.keyboardType = .numberPad
        view.addSubview(captchaView)
        
        captchaView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(tipLabel.snp.bottom).offset(48)
            make.height.equalTo(44)
        }
        
        passwordView.configInputView(titleStr: "密码:", contentStr: "")
        passwordView.inputTextfield.isSecureTextEntry = true
        view.addSubview(passwordView)
        
        passwordView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(captchaView.snp.bottom).offset(24)
            make.height.equalTo(44)
        }
        
        let confirmButton = UIButton.init(type: .custom)
        confirmButton.setTitle("登录", for: .normal)
        confirmButton.layer.cornerRadius = 20
        confirmButton.backgroundColor = SGColor.SGMainColor()
        confirmButton.addTarget(self, action:#selector(confirmButtonClick), for: .touchUpInside)
        view.addSubview(confirmButton)
        
        
        confirmButton.snp.makeConstraints { (make) in
            make.left.equalTo(4)
            make.bottom.equalTo(-4)
            make.height.equalTo(44)
            make.right.equalTo(-4)
        }
    }
    
    func update() {
        let string1 = "已经向您的手机" + phoneNo! + "发送验证码。\n"
        let timeStr = String(timeout)
        let string2 = "如果" + timeStr + "秒后未收到验证码，再次申请。"
        let range = NSRange.init(location: string1.characters.count + 2, length: timeStr.characters.count)
        
        let attributedText = NSMutableAttributedString.init(string: string1 + string2)
        attributedText.addAttribute(NSForegroundColorAttributeName, value: SGColor.SGBlueColor(), range: range)
        tipLabel.attributedText = attributedText
        
        timeout -= 1
        if timeout <= 0 {
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
        if timeout > 0 {
            return
        }
        timeout = 60
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
//        HUD.flash(.label("登录成功"), delay: 2)
        do {
            let cache = try Cache<NSString>(name: SGGlobalKey.SCCacheName)
            cache[SGGlobalKey.SCLoginStatusKey] = true.description as NSString?
            NotificationCenter.default.post(name: SGGlobalKey.LoginStatusDidChange, object: nil)
        } catch _ {
            print("Something went wrong :(")
        }
    }
    
}

