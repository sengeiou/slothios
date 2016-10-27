//
//  UserInfoEditView.swift
//  SlothChat
//
//  Created by fly on 2016/10/19.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

typealias DoneUserInfoType = (_ userObj: UserProfileData) -> Void

class UserInfoEditView: BaseView {

    let nameView = SingleInputView()
    let sexView = SingleInputView()
    let birthdayView = SingleInputView(type: .button)
    let locationView = SingleInputView()
    let hauntView = SingleInputView()
    let schoolView = SingleInputView()
    
    let sexPickView = SexPickView()
    
    var editUserInfoValue:DoneUserInfoType?
    
    let datePicker = MIDatePicker.getFromNib()
    var dateFormatter = DateFormatter()
    var showVC: UIViewController?
    
    var userObj: UserProfileData?

    override init(frame: CGRect ){
        super.init(frame: frame)
        sentupView()
        setupDatePicker()
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sentupView() {
        nameView.setInputTextfieldLeftMagin(left: 80)
        nameView.configInputView(titleStr: "昵称:", contentStr: "")
        addSubview(nameView)
        
        sexView.setInputTextfieldLeftMagin(left: 80)
        sexView.configInputView(titleStr: "性别:", contentStr: "")
        sexView.inputTextfield.isHidden = true
        sexView.allowEditing(allowEdit: false)
        
        addSubview(sexView)
        sexView.addSubview(sexPickView)
        
        birthdayView.setClosurePass {
            if self.showVC != nil{
                self.datePicker.show(inVC: (self.showVC?.tabBarController)!)
            }
        }
        birthdayView.arrowImgView.isHidden = true
        birthdayView.setInputTextfieldLeftMagin(left: 80)
        birthdayView.configInputView(titleStr: "生日:", contentStr: "")
        addSubview(birthdayView)
        
        locationView.setInputTextfieldLeftMagin(left: 80)
        locationView.configInputView(titleStr: "所在地:", contentStr: "")
        addSubview(locationView)
        
        hauntView.setInputTextfieldLeftMagin(left: 80)
        hauntView.configInputView(titleStr: "经常出没:", contentStr: "")
        addSubview(hauntView)
        
        schoolView.setInputTextfieldLeftMagin(left: 80)
        schoolView.configInputView(titleStr: "学校:", contentStr: "")
        addSubview(schoolView)
        
        nameView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(-90)
            make.height.equalTo(46)
        }
        
        sexView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(nameView.snp.right)
            make.top.equalTo(nameView.snp.bottom).offset(24)
            make.height.equalTo(66)
        }
        
        sexView.titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(sexView.snp.centerY)
        }
        
        sexPickView.snp.makeConstraints { (make) in
            make.top.right.equalTo(0)
            make.left.equalTo(80)
            make.height.equalTo(sexView.snp.height)
        }
        
        birthdayView.snp.makeConstraints { (make) in
            make.left.equalTo(nameView.snp.left)
            make.right.equalTo(nameView.snp.right)
            make.top.equalTo(sexView.snp.bottom).offset(12)
            make.height.equalTo(nameView.snp.height)
        }
        
        locationView.snp.makeConstraints { (make) in
            make.top.equalTo(birthdayView.snp.bottom).offset(12)
            
            make.left.equalTo(nameView.snp.left)
            make.right.equalTo(nameView.snp.right)
            make.height.equalTo(nameView.snp.height)
        }
        
        hauntView.snp.makeConstraints { (make) in
            make.top.equalTo(locationView.snp.bottom).offset(12)

            make.left.equalTo(nameView.snp.left)
            make.right.equalTo(nameView.snp.right)
            make.height.equalTo(nameView.snp.height)
        }
        schoolView.snp.makeConstraints { (make) in
            make.top.equalTo(hauntView.snp.bottom).offset(12)

            make.left.equalTo(nameView.snp.left)
            make.right.equalTo(nameView.snp.right)
            make.height.equalTo(nameView.snp.height)
            make.bottom.equalTo(0)
        }
        
        let editView = UIView()
        let editLabel = UILabel()
        editLabel.text = "完成"
        editLabel.font = UIFont.systemFont(ofSize: 15)
        editLabel.textColor = SGColor.SGMainColor()
        
        let editButton = UIButton(type: .custom)
        editButton.addTarget(self, action: #selector(confirmButtonClick), for: .touchUpInside)
        addSubview(editView)
        editView.addSubview(editLabel)
        editView.addSubview(editButton)
        
        editView.snp.makeConstraints { (make) in
            make.top.right.equalTo(0)
            make.centerY.equalTo(nameView.snp.centerY)
            make.size.equalTo(CGSize.init(width: 64, height: 46))
        }
        
        editLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.centerY.equalTo(editView.snp.centerY)
        }
        
        editButton.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    func configViewWihObject(userObj: UserProfileData) {
        self.userObj = userObj
        nameView.configContent(contentStr: userObj.nickname!)
        birthdayView.configContent(contentStr: userObj.birthdate!)
        
        let isMale = userObj.sex == SGGenderType.male.rawValue
        sexPickView.selectSexView(isMale: isMale)
        
        birthdayView.configContent(contentStr: userObj.birthdate!)
        locationView.configContent(contentStr: userObj.area!)
        hauntView.configContent(contentStr: userObj.commonCities!)
        schoolView.configContent(contentStr: userObj.university!)
        
        if self.userObj != nil {
            datePicker.config.startDate = self.userObj?.birthdate!.toYMDDate()
        }else{
            datePicker.config.startDate = Date()
        }
    }
    
    func setDoneUserInfoValue(temClosure: @escaping DoneUserInfoType){
        self.editUserInfoValue = temClosure
    }
    
    func confirmButtonClick() {
        print("confirmButtonClick")
        
        self.userObj?.nickname = nameView.getInputContent()!
        if sexPickView.isMalePick {
            self.userObj?.sex = SGGenderType.male.rawValue
        }else{
            self.userObj?.sex = SGGenderType.female.rawValue
        }
        self.userObj?.area = locationView.getInputContent()!
        self.userObj?.commonCities = hauntView.getInputContent()!
        self.userObj?.university = schoolView.getInputContent()!

        if let sp = self.editUserInfoValue {
            sp(self.userObj!)
        }
    }
    
    fileprivate func setupDatePicker() {
        
        datePicker.delegate = self
        
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
    
}

extension UserInfoEditView: MIDatePickerDelegate {
    
    func miDatePicker(_ amDatePicker: MIDatePicker, didSelect date: Date) {
        birthdayView.configContent(contentStr: dateFormatter.string(from: date))
        self.userObj?.birthdate = date.toYMDString()!
    }
    func miDatePickerDidCancelSelection(_ amDatePicker: MIDatePicker) {
        // NOP
    }
    
}
