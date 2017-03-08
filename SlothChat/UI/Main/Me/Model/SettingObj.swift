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
        
        let privateChat = SettingObj()
        privateChat.titleStr = "接受私信"
        privateChat.isOn = (Global.shared.globalSysConfig?.acceptPrivateChat)!
        
        let notify = SettingObj()
        notify.titleStr = "接受通知"
        notify.isOn = (Global.shared.globalSysConfig?.acceptSysNotify)!

        let balance = SettingObj()
        balance.titleStr = "账户余额：￥0"
        balance.contentStr = "充值"
        
        let about = SettingObj()
        about.titleStr = "关于我们"
        
        let eula = SettingObj();
        eula.titleStr = "最终用户许可协议"
        
        return [password,privateChat,notify,balance,about,eula]
    }
}
