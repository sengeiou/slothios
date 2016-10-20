//
//  NetworkEngine.swift
//  SlothChat
//
//  Created by 王一丁 on 2016/10/18.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

struct ResponseError {
    static let SUCCESS = ("100", "成功")
    static let ERROR_AUTH_CODE = ("201", "token授权码错误")
    static let ERROR_SMS_CODE = ("202", "无效的短信验证码")
    static let USERNAMEE = ("203", "昵称重复/无效")
    static let EMAILE = ("204", "邮件重复/无效")
    static let AUTH_FAILURE = ("205", "登录验证错误，无效的手机号码和密码组合")
    static let NOT_EXIST = ("206", "访问的记录不存在/已经成功删除")
    static let ALREADY_EXIST = ("207", "不能重复创建相同记录")
    static let WEAK_NEW_PWD = ("208", "不安全的弱密码，请输入同时包含数字和字母的组合，并至少含有一个大写字母")
    static let USER_NOT_EXIST = ("209", "该手机号注册的用户不存在")
    static let NO_PRIVELLEGE = ("300", "权限错误")
    static let NOT_ENOUGH_MONEY = ("301", "账户余下额度不足，请充值")
    static let PROFILE_PIC_NOT_VERIFIED = ("302", "个人资料第一张头像未通过真人认证")
    static let SYSE = ("400", "系统异常错误")
    static let OPER_TIMEOUT = ("401", "网络超时")
    static let DBE = ("402", "数据库异常错误")
    static let FAILURE = ("500", "未知的系统异常")
}

class NetworkEngine: NSObject {
    
}
