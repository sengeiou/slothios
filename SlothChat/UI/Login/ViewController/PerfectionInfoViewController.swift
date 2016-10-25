//
//  PerfectionInfoViewController.swift
//  SlothChat
//
//  Created by Fly on 16/10/15.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import PKHUD
import AwesomeCache


class PerfectionInfoViewController: BaseViewController {
    
    public var phoneNo:String!
    public var password:String!
    
    let avatarButton = UIButton.init(type: .custom)

    let nickNameView = SingleInputView.init()
    let sexPickView = SexPickView()
    
    let birthdayView = SingleInputView.init(type : .button)
    
    
    var datePicker = MIDatePicker.getFromNib()
    var dateFormatter = DateFormatter()
    
    var selectedAvatar : UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        sentupViews()
        
        setupDatePicker()
        
        dateFormatter.dateFormat = "yyyy/MM/dd"
    }

    func sentupViews() {
        
        let iconView = IconTitleView.init(frame: CGRect.zero)
        iconView.titleLabel.font = UIFont.systemFont(ofSize: 24)
        view.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(100)
            make.size.equalTo(CGSize.init(width: 134, height: 42))
        }
        
        let avatarLabel = UILabel.init()
        avatarLabel.text = "头像:"
        view.addSubview(avatarLabel)
        
        avatarButton.addTarget(self, action:#selector(avatarButtonClick), for: .touchUpInside)
        avatarButton.setImage(UIImage.init(named: "camera-gray"), for: .normal)
        avatarButton.setBackgroundImage(UIImage.init(named: "litmatrix"), for: .normal)
        view.addSubview(avatarButton)
        
        nickNameView.configInputView(titleStr: "昵称:", contentStr: "")
        view.addSubview(nickNameView)
        
        
        let genderLabel = UILabel.init()
        
        genderLabel.text = "性别:"
        view.addSubview(genderLabel)
        
        sexPickView.selectSexView(isMale: false)
        view.addSubview(sexPickView)

        birthdayView.configInputView(titleStr: "生日:", contentStr: "")
        birthdayView.setClosurePass { 
            self.datePicker.show(inVC: self)
        }
        view.addSubview(birthdayView)
        
        avatarLabel.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.top.equalTo(iconView.snp.bottom).offset(72)
            make.width.equalTo(114)
        }
        
        avatarButton.snp.makeConstraints { (make) in
            make.left.equalTo(avatarLabel.snp.right)
            make.top.equalTo(iconView.snp.bottom).offset(63)
            make.size.equalTo(CGSize.init(width: 122, height: 122))
        }
        
        nickNameView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(avatarButton.snp.bottom).offset(12)
            make.height.equalTo(60)
        }
        
        genderLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarLabel.snp.left)
            make.top.equalTo(nickNameView.snp.bottom).offset(60)
            make.width.equalTo(100)
        }
        
        sexPickView.snp.makeConstraints { (make) in
            make.left.equalTo(genderLabel.snp.right).offset(14)
            make.centerY.equalTo(genderLabel.snp.centerY)
            make.size.equalTo(CGSize.init(width: 140, height: 44))
        }
        
        birthdayView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(genderLabel.snp.bottom).offset(12)
            make.height.equalTo(60)
        }
        
        let registerButton = UIButton.init(type: .custom)
        registerButton.setTitle("注册", for: .normal)
        registerButton.layer.cornerRadius = 22
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        registerButton.backgroundColor = SGColor.SGMainColor()
        registerButton.addTarget(self, action:#selector(registerButtonClick), for: .touchUpInside)
        view.addSubview(registerButton)
        
        
        registerButton.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.bottom.equalTo(-8)
            make.height.equalTo(44)
            make.right.equalTo(-10)
        }
    }
    
    fileprivate func setupDatePicker() {
        
        datePicker.delegate = self
        
        datePicker.config.startDate = Date()
        datePicker.datePicker.maximumDate = Date()
        datePicker.datePicker.minimumDate = Date.init(timeIntervalSinceNow: -60 * 60 * 24 * 30 * 12 * 70)
        
        datePicker.config.animationDuration = 0.35
        
        datePicker.config.cancelButtonTitle = "取消"
        datePicker.config.confirmButtonTitle = "确认"
        
        datePicker.config.contentBackgroundColor = UIColor(red: 253/255.0, green: 253/255.0, blue: 253/255.0, alpha: 1)
        datePicker.config.headerBackgroundColor = UIColor(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
        datePicker.config.confirmButtonColor = UIColor(red: 32/255.0, green: 146/255.0, blue: 227/255.0, alpha: 1)
        datePicker.config.cancelButtonColor = UIColor(red: 32/255.0, green: 146/255.0, blue: 227/255.0, alpha: 1)
        
    }
    
    //MARK:- Action
    func registerButtonClick() {
        print("registerButtonClick")
        
        if self.selectedAvatar == nil {
            HUD.flash(.label("请选择头像"), delay: 2)
            return
        }
        let nickName = nickNameView.getInputContent()
        if (nickName?.isEmpty)! {
            HUD.flash(.label("请输入昵称"), delay: 2)
            return
        }
        
        let birthday = birthdayView.getInputContent()
        if (birthday?.isEmpty)! {
            HUD.flash(.label("请选择生日"), delay: 2)
            return
        }
        print("注册信息齐全")
        let user = UserSignupModel()
        
        let engine = NetworkEngine()
        engine.postPublicUserAndProfileSignup(withSignpModel: user) { (profile) in
            
        }
        
        do {
            let cache = try Cache<NSString>(name: SGGlobalKey.SCCacheName)
            cache[SGGlobalKey.SCLoginStatusKey] = true.description as NSString?
            NotificationCenter.default.post(name: SGGlobalKey.LoginStatusDidChange, object: nil)
        } catch _ {
            print("Something went wrong :(")
        }
    }
    
    func avatarButtonClick() {
        

        UIActionSheet.photoPicker(withTitle: "选择头像", showIn: self.view, presentVC: self, onPhotoPicked: { (avatar) in
            self.selectedAvatar = avatar

            let engine = NetworkEngine()
            engine.postPicFile(picFile: avatar!) { (userPhoto) in
                if userPhoto?.status == ResponseError.SUCCESS.0{
                    self.selectedAvatar = avatar
                    self.avatarButton.setImage(avatar, for: .normal)
                }else{
                    HUD.flash(.label(userPhoto?.msg), delay: 2)
                }
            }
            }, onCancel: nil, allowsEditing: true)
    }
}

extension PerfectionInfoViewController: MIDatePickerDelegate {
    
    func miDatePicker(_ amDatePicker: MIDatePicker, didSelect date: Date) {
        birthdayView.configContent(contentStr: dateFormatter.string(from: date))
    }
    func miDatePickerDidCancelSelection(_ amDatePicker: MIDatePicker) {
        // NOP
    }
    
}

