//
//  UserSignupModel.swift
//  SlothChat
//
//  Created by 王一丁 on 2016/10/25.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class UserSignupModel: NSObject {
    var userPhotoUuid:String
    var mobile:String //加了国际区号的手机号码（由注册选择国家的JSON字段 telPrefix 和 用户输入手机号码组合成）
    var passwd:String //密码
    var country:String //国家简写
    var nickname:String //用户昵称
    var sex:String//性别（male / female 中间2选择1）
    var birthdate:String
    
    override init() {
        self.userPhotoUuid = ""
        self.mobile = ""
        self.passwd = ""
        self.country = ""
        self.nickname = ""
        self.sex = ""
        self.birthdate = ""
    }
}
