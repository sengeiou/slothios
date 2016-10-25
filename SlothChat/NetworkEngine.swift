//
//  NetworkEngine.swift
//  SlothChat
//
//  Created by 王一丁 on 2016/10/18.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

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

enum API_URI:String {
    case public_coutry = "/api/public/country"
    case public_sms = "/api/public/sms"
    case public_sms_check = "/api/public/sms/check"
    case public_userPhoto = "/api/public/userPhoto"
    case auth_login = "/auth/login"
    case auth_mobileapps_logout  = "/auth/mobileapps/logout"
    //7.修改个人资料页面的文字资料//POST
    case post_user_userProfile  = "/api/user/{userUuid}/userProfile/{uuid}?token={token}"
    //8.修改个人资料页面的5张图片的显示顺序（此功能预留暂时不做）
    case get_api_us  = "/api/us"//GET
    //9.查看个人资料页面的文字和图片//GET
    case get_user_userProfile  = "/api/user/{userUuid}/userProfile"
    //10.陌生人查看个人资料页面时对资料点赞PUT
    case put_userProfile_like = "/api/user/{userUuid}/userProfile/{uuid}/like?token={token}"
    //11.查看个人设置
    case get_sysConfig = "/api/user/{userUuid}/userProfile/{uuid}/sysConfig?token={token}"
    //12.用原有登录密码修改账户密码
    case put_updatePwd = "/api/public/user/{uuid}"
    //13.通过短信验证码修改账户密码
    case post_changePwd = "/api/public/sms/changePwd"
    //14.账户APPLE STORE充值
    case get_money = "/api/public/money"
    //15.修改个人设置
//    case put_sysConfig = "/api/user/{userUuid}/userProfile/{uuid}/sysConfig?token={token}"
    //17.用户资料页面，添加个人照片
    case post_userPhoto = "/api/user/{uuid}/userPhoto?token={token}"
    //18.用户资料页面，删除指定的个人照片
    case delete_userPhoto = "/api/user/{userUuid}/userPhoto/{uuid}?token={token}"



}

class NetworkEngine: NSObject {
    let Base_URL:String = "http://api.ssloth.com"
    
    override init() {
        
    }
    
    func getPublicCountry(withName name:String,completeHandler :@escaping(_ countryObj:Country?) -> Void) -> Void {
        let URLString:String = Base_URL + API_URI.public_coutry.rawValue
        Alamofire.request(URLString, parameters: ["name":name]).responseObject { (response:DataResponse<Country>) in
            completeHandler(response.result.value);
        }
    }
    
    func postPublicSMS(withType type:String, toPhoneno:String, completeHandler :@escaping(_ smsObj:SMS?) -> Void) -> Void {
        let URLString:String = Base_URL + API_URI.public_sms.rawValue
        
        var request = URLRequest(url: NSURL.init(string: URLString) as! URL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let values = ["type":type,"toPhoneno":toPhoneno]
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: values)
        Alamofire.request(request).responseObject { (response:DataResponse<SMS>) in
            completeHandler(response.result.value);
        }
        
    }
    
    func postPublicSMSCheck(WithPhoneNumber toPhoneno:String,verifyCode:String, completeHandler :@escaping(_ smsObj:SMS?) -> Void) -> Void {
        let URLString:String = Base_URL + API_URI.public_sms_check.rawValue
        
        var request = URLRequest(url: NSURL.init(string: URLString) as! URL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let values = ["toPhoneno":toPhoneno,
                      "verifyCode":verifyCode]
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: values)
        
        Alamofire.request(request)
            .responseObject { (response:DataResponse<SMS>) in
            completeHandler(response.result.value);
        }
 
    }
    
    func post(picFile:String,completeHandler :@escaping(_ userPhoto:UserPhoto?) -> Void) -> Void {
        let URLString:String = Base_URL + API_URI.public_userPhoto.rawValue
        Alamofire.request(URLString, method: .post, parameters: ["picFile": picFile]).responseObject { (response:DataResponse<UserPhoto>) in
            completeHandler(response.result.value);
        }
    }
    
    func postPublicUserAndProfileSignup(withSignpModel signup:UserSignupModel ,completeHandler :@escaping(_ userAndProfile:UserAndProfile?) -> Void) -> Void {
        let URLString:String = self.Base_URL + API_URI.public_userPhoto.rawValue
        let parameters = [
            "userPhotoUuid":signup.userPhotoUuid,
            "mobile": signup.mobile,
            "passwd": signup.passwd,
            "country": signup.country,
            "nickname": signup.nickname,
            "sex": signup.sex,
            "birthdate":signup.birthdate
        ]
        Alamofire.request(URLString, method: .post, parameters: parameters).responseObject { (response:DataResponse<UserAndProfile>) in
            completeHandler(response.result.value);
        }
    }
    
    func postAuthLogin(withMobile mobile:String, passwd:String,completeHandler :@escaping(_ loginModel:LoginModel?) -> Void) -> Void {
        let URLString:String = self.Base_URL + API_URI.auth_login.rawValue
        Alamofire.request(URLString, method: .post, parameters: ["mobile":mobile,"passwd":passwd]).responseObject { (response:DataResponse<LoginModel>) in
            completeHandler(response.result.value);
        }
    }
    
    func postAuthLogout(withUUID uuid:String,token:String,completeHandler :@escaping(_ response:Response?) -> Void) -> Void {
        let URLString:String = self.Base_URL + API_URI.auth_mobileapps_logout.rawValue
        Alamofire.request(URLString, method: .post, parameters: ["uuid":uuid,"token":token]).responseObject { (response:DataResponse<Response>) in
            completeHandler(response.result.value);
        }
    }
}
