//
//  SettingObj.swift
//  SlothChat
//
//  Created by Fly on 16/10/18.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class SettingObj: BaseObject {
    var titleStr = ""
    var contentStr = ""
    var isOn = false
    
    class func getSettingList() -> [SettingObj] {
        let password = SettingObj()
        password.titleStr = "修改密码"
        
        let letter = SettingObj()
        letter.titleStr = "接受私信"
        
        let notice = SettingObj()
        notice.titleStr = "接受通知"
        
        let balance = SettingObj()
        balance.titleStr = "账户余额：￥0"
        balance.contentStr = "充值"
        
        let about = SettingObj()
        about.titleStr = "关于我们"
        
        return [password,letter,notice,balance,about]
    }
}
