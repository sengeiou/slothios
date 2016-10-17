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

enum SGGenderType {
    case male
    case female
}

class PerfectionInfoViewController: BaseViewController {
    
    public var phoneNo:String!
    public var password:String!
    
    let avatarButton = UIButton.init(type: .custom)

    let nickNameView = SingleInputView.init()
    let birthdayView = SingleInputView.init(type : .button)
    
    var datePicker = MIDatePicker.getFromNib()
    var dateFormatter = DateFormatter()
    
    var selectedAvatar : UIImage?
    var gender : SGGenderType = .male
    

    override func viewDidLoad() {
        super.viewDidLoad()
        sentupViews()
        
        setupDatePicker()
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
    }

    func sentupViews() {
        let iconImgView = UIImageView.init(image: UIImage.init(named: "icon"))
        view.addSubview(iconImgView)
        
        let titleLabel = UILabel.init()
        titleLabel.text = "树懒"
        titleLabel.font = UIFont.systemFont(ofSize: 24)
        titleLabel.textColor = UIColor.red
        view.addSubview(titleLabel)
        
        iconImgView.snp.makeConstraints { (make) in
            make.top.equalTo(100)
            make.centerX.equalTo(self.view).offset(-40)
            make.size.equalTo(CGSize.init(width: 44, height: 44))
        }
        titleLabel.snp.makeConstraints  { (make) in
            make.left.equalTo(iconImgView.snp.right).offset(40)
            make.centerY.equalTo(iconImgView.snp.centerY)
        }
        
        let avatarLabel = UILabel.init()
        avatarLabel.text = "头像:"
        view.addSubview(avatarLabel)
        
        avatarButton.addTarget(self, action:#selector(avatarButtonClick), for: .touchUpInside)
        avatarButton.setImage(UIImage.init(named: "camera-gray"), for: .normal)
        view.addSubview(avatarButton)
        
        nickNameView.configInputView(titleStr: "昵称:", contentStr: "")
        view.addSubview(nickNameView)
        
        let genderLabel = UILabel.init()
        
        genderLabel.text = "性别:"
        view.addSubview(genderLabel)
        
        let femaleButton = UIButton.init(type: .custom)
        femaleButton.setImage(UIImage.init(named: "female"), for: .normal)
        femaleButton.addTarget(self, action:#selector(femaleButtonClick), for: .touchUpInside)

        view.addSubview(femaleButton)
        
        let maleButton = UIButton.init(type: .custom)
        maleButton.setImage(UIImage.init(named: "male"), for: .normal)
        maleButton.addTarget(self, action:#selector(maleButtonClick), for: .touchUpInside)
        view.addSubview(maleButton)
        
        birthdayView.configInputView(titleStr: "生日:", contentStr: "")
        birthdayView.setClosurePass { 
            self.datePicker.show(inVC: self)
        }
        view.addSubview(birthdayView)
        
        avatarLabel.snp.makeConstraints { (make) in
            make.left.equalTo(4)
            make.top.equalTo(titleLabel.snp.bottom).offset(36)
            make.width.equalTo(100)
        }
        
        avatarButton.snp.makeConstraints { (make) in
            make.left.equalTo(avatarLabel.snp.right)
            make.top.equalTo(avatarLabel.snp.top)
            make.size.equalTo(CGSize.init(width: 100, height: 100))
        }
        nickNameView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(avatarButton.snp.bottom).offset(24)
            make.height.equalTo(44)
        }
        
        genderLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarLabel.snp.left)
            make.top.equalTo(nickNameView.snp.bottom).offset(24)
            make.width.equalTo(100)
        }
        
        femaleButton.snp.makeConstraints { (make) in
            make.left.equalTo(genderLabel.snp.right).offset(120)
            make.centerY.equalTo(genderLabel.snp.centerY)
            make.size.equalTo(CGSize.init(width: 24, height: 24))
        }
        
        maleButton.snp.makeConstraints { (make) in
            make.left.equalTo(femaleButton.snp.right).offset(4)
            make.centerY.equalTo(genderLabel.snp.centerY)
            make.size.equalTo(CGSize.init(width: 24, height: 24))
        }
        
        birthdayView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(genderLabel.snp.bottom).offset(24)
            make.height.equalTo(44)
        }
        
        let registerButton = UIButton.init(type: .custom)
        registerButton.setTitle("注册", for: .normal)
        registerButton.layer.cornerRadius = 20
        registerButton.backgroundColor = SGColor.SGMainColor()
        registerButton.addTarget(self, action:#selector(registerButtonClick), for: .touchUpInside)
        view.addSubview(registerButton)
        
        
        registerButton.snp.makeConstraints { (make) in
            make.left.equalTo(4)
            make.bottom.equalTo(-4)
            make.height.equalTo(44)
            make.right.equalTo(-4)
        }
    }
    
    fileprivate func setupDatePicker() {
        
        datePicker.delegate = self
        
        datePicker.config.startDate = Date()
        
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
        
        do {
            let cache = try Cache<NSString>(name: SGGlobalKey.SCCacheName)
            cache[SGGlobalKey.SCLoginStatusKey] = true.description as NSString?
            NotificationCenter.default.post(name: SGGlobalKey.LoginStatusDidChange, object: nil)
        } catch _ {
            print("Something went wrong :(")
        }
    }
    
    func femaleButtonClick() {
        gender = .female
    }
    
    func maleButtonClick() {
        gender = .male
    }
    
    func avatarButtonClick() {
        UIActionSheet.photoPicker(withTitle: "选择头像", showIn: self.view, presentVC: self, onPhotoPicked: { (avatar) in
            self.selectedAvatar = avatar
           self.avatarButton.setImage(avatar, for: .normal)
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

