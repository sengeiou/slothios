//
//  UserInfoView.swift
//  SlothChat
//
//  Created by fly on 2016/10/19.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

typealias EditUserInfoType = () -> Void

class UserInfoView: BaseView {
    let nameLabel = UILabel()
    let sexImgView = UIImageView()
    let ageInfoLabel = UILabel()
    
    let universityView = UserInfoSingleView()
    let personalProfileView = UserInfoSingleView()
    let editView = UIView()
    
    var userObj: UserProfileData?
    
    var editUserInfoValue:EditUserInfoType?

    override init(frame: CGRect ){
        super.init(frame: frame)
        sentupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sentupView() {
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        addSubview(nameLabel)
        addSubview(sexImgView)
        ageInfoLabel.font = UIFont.systemFont(ofSize: 14)
        addSubview(ageInfoLabel)
        
        universityView.titleLabel.textColor = SGColor.SGTextColor()
        universityView.configInputView(titleStr: "所在地:", contentStr: "")
        addSubview(universityView)
        
        personalProfileView.titleLabel.textColor = SGColor.SGTextColor()
        personalProfileView.configInputView(titleStr: "经常出没:", contentStr: "")
        addSubview(personalProfileView)
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.top.equalTo(0)
            make.right.lessThanOrEqualTo(-90)
        }
        sexImgView.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(10)
            make.bottom.equalTo(nameLabel.snp.bottom).offset(-2)
            make.size.equalTo(CGSize.init(width: 14, height: 14))
        }
        ageInfoLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.left)
            make.top.equalTo(nameLabel.snp.bottom).offset(14)
        }
        
        universityView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(ageInfoLabel.snp.bottom).offset(24)
            make.height.equalTo(34).priority(250)
        }
        personalProfileView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(universityView.snp.bottom)
            make.height.equalTo(34).priority(250)
            make.bottom.equalTo(-60)
        }
        
        let editImgView = UIImageView()
        editImgView.image = UIImage.init(named: "pen")
        editImgView.tintColor = SGColor.SGMainColor()
        let editLabel = UILabel()
        editLabel.text = "编辑"
        editLabel.font = UIFont.systemFont(ofSize: 15) 
        editLabel.textColor = SGColor.SGMainColor()
        
        let editButton = UIButton(type: .custom)
        editButton.addTarget(self, action: #selector(editButtonClick), for: .touchUpInside)
        addSubview(editView)
        editView.addSubview(editImgView)
        editView.addSubview(editLabel)
        editView.addSubview(editButton)
        
        editView.snp.makeConstraints { (make) in
            make.top.right.equalTo(0)
            make.size.equalTo(CGSize.init(width: 64, height: 46))
        }
        
        editImgView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.centerY.equalTo(editView.snp.centerY)
            make.size.equalTo(CGSize.init(width: 15, height: 15))
        }
        
        editLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.centerY.equalTo(editImgView.snp.centerY)
        }
        
        editButton.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    func configViewWihObject(userObj: UserProfileData) {
        self.userObj = userObj
        
        nameLabel.text = userObj.nickname
        let isMale = (userObj.sex == SGGenderType.male.rawValue)
        let sexName = (isMale ? "male" : "female")
        sexImgView.image = UIImage.init(named: sexName)
        
        let birthday = userObj.birthdate?.toYMDDate()
        let age = birthday?.toAgeString()
        let constellation = birthday?.toConstellationString()
        ageInfoLabel.text = age! + "，" + constellation!
        
        universityView.configContent(contentStr: userObj.university!)
        personalProfileView.configContent(contentStr: userObj.personalProfile!)
    }
    
    func setUserEntity(isMyself: Bool) {
        editView.isHidden = !isMyself
    }
    
    func setEditUserInfoValue(temClosure: @escaping EditUserInfoType){
        self.editUserInfoValue = temClosure
    }
    
    func editButtonClick() {
        print("editButtonClick")
        if let sp = self.editUserInfoValue {
            sp()
        }
    }

}
