 //
//  NetworkEngine.swift
//  SlothChat
//
//  Created by 王一丁 on 2016/10/18.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import PKHUD
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
    case public_signup = "/api/public/userAndProfile/signup"
    case auth_login = "/auth/login"
    case auth_mobileapps_logout  = "/auth/mobileapps/logout"
    //7.修改个人资料页面的文字资料
    case post_userProfile  = "/api/user/{userUuid}/userProfile/{uuid}?token={token}"
    //8.修改个人资料页面的5张图片的显示顺序（此功能预留暂时不做）
    case get_api_us  = "/api/us"
    //9.查看个人资料页面的文字和图片
    case get_userProfile  = "/api/user/{userUuid}/userProfile?token={token}&likeSenderUserUuid={likeSenderUserUuid}"
    //    //10.陌生人查看个人资料页面时对资料点赞
    //    case put_userProfile_like = "/api/user/{userUuid}/userProfile/{uuid}/like?token={token}"
    //11.查看个人设置
    case userProfile_sysConfig = "/api/user/{userUuid}/userProfile/{uuid}/sysConfig?token={token}"
    //12.用原有登录密码修改账户密码
    case put_updatePwd = "/api/public/user/{uuid}"
    //13.通过短信验证码修改账户密码
    case post_changePwd = "/api/public/sms/changePwd"
    //14.账户APPLE STORE充值
    case get_money = "/api/public/money"
    //15.修改个人设置
    //    case userProfile_sysConfig = "/api/user/{userUuid}/userProfile/{uuid}/sysConfig?token={token}"
    //17.用户资料页面，添加个人照片
    case post_userPhoto = "/api/user/{uuid}/userPhoto?token={token}"
    //18.用户资料页面，删除指定的个人照片
    case delete_userPhoto = "/api/user/{userUuid}/userPhoto/{uuid}?token={token}"
    //19.陌生人查看个人资料页面时对资料点赞
    case userProfile_likeProfile = "/api/userProfile/{userProfileUuid}/likeProfile?token={token}"
    //20.用户查看自己的资料页面时点击（红心，XX人喜欢）按钮，查看点赞发出者头像名称列表
    //case get_likeProfile = "/api/userProfile/{userProfileUuid}/likeProfile?token={token}"
    
    //B2.
    //21.探索图片空间，新添加图片
    case user_gallery = "/api/user/{userUuid}/gallery?token={token}"
    //22.探索图片空间，分页获取某人的图片列表
    //    case get_gallery = "/api/user/{userUuid}/gallery?token={token}"
    //23.探索图片空间，删除指定的图片
    case delete_gallery = "/api/user/{userUuid}/gallery/{uuid}?token={token}"
    //24.探索图片空间，分页获取"最新Tab"或者"最热Tab"图片列表
    case get_orderGallery = "/api/user/gallery?token={token}&displayOrder={displayOrder}&likeSenderUserUuid={likeSenderUserUuid}"
    //25.陌生人查看探索图片时点赞POST
    case gallery_likeGallery = "/api/gallery/{galleryUuid}/likeGallery?token={token}"
    //26.用户查看自己的探索图片左下方的3个点赞头像列表，查看点赞发出者头像名称列表（传分页参数分页）
    //    case get_ = "/api/gallery/{galleryUuid}/likeGallery?token={token}"
}

class NetworkEngine: NSObject {
    let Base_URL:String = "http://api.ssloth.com"
    
    override init() {
        
    }
    
    func HTTPRequestGenerator(withParam parameters:NSDictionary,URLString:String)->URLRequest {
        var request = URLRequest(url: NSURL.init(string: URLString) as! URL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let values = parameters
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: values)
        
        return request
    }
    
    func HTTPRequestGenerator(withParam parameters: NSDictionary,method: HTTPMethod,URLString: String)->URLRequest {
        var request = URLRequest(url: NSURL.init(string: URLString) as! URL)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let values = parameters
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: values)
        
        return request
    }
    
    func HTTPRequestGenerator(withParam parameters: NSDictionary,method: HTTPMethod,contentType: String,URLString: String)->URLRequest {
        var request = URLRequest(url: NSURL.init(string: URLString) as! URL)
        request.httpMethod = method.rawValue
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        let values = parameters
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: values)
        
        return request
    }
    
    func validAuthCode(code: String?) -> Bool {
        let authCode = ResponseError.ERROR_AUTH_CODE.0
        
        guard let code = code, code == authCode  else {
            return true
        }
        
        Global.shared.logout()
        HUD.flash(.label("账号异常"), delay: 2)
        NotificationCenter.default.post(name: SGGlobalKey.LoginStatusDidChange, object: nil)
        return false
    }
    
    //1.注册选择国家信息列表 GET
    func getPublicCountry(withName name:String,completeHandler :@escaping(_ countryObj:Country?) -> Void) -> Void {
        let URLString:String = Base_URL + API_URI.public_coutry.rawValue
        Alamofire.request(URLString, parameters: ["name":name]).responseObject { (response:DataResponse<Country>) in
            completeHandler(response.result.value);
        }
    }
    
    //2.获取短信验证码 POST
    func postPublicSMS(withType type:String, toPhoneno:String, completeHandler :@escaping(_ smsObj:SMS?) -> Void) -> Void {
        let URLString:String = Base_URL + API_URI.public_sms.rawValue
        let request = HTTPRequestGenerator(withParam: ["type":type,"toPhoneno":toPhoneno], URLString: URLString)
        
        Alamofire.request(request).responseObject { (response:DataResponse<SMS>) in
            completeHandler(response.result.value);
        }
        
    }
    
    //3.校验短信验证码是否正确 POST
    func postPublicSMSCheck(WithPhoneNumber toPhoneno:String,verifyCode:String, completeHandler :@escaping(_ smsObj:SMS?) -> Void) -> Void {
        let URLString:String = Base_URL + API_URI.public_sms_check.rawValue
        let request = HTTPRequestGenerator(withParam: ["toPhoneno":toPhoneno,
                                                       "verifyCode":verifyCode], URLString: URLString);
        Alamofire.request(request)
            .responseObject { (response:DataResponse<SMS>) in
                completeHandler(response.result.value);
        }
        
    }
    
    //4.1.注册初始化用户头像 POST
    func postPicFile(picFile:UIImage,completeHandler :@escaping(_ userPhoto:UserPhoto?) -> Void) -> Void {
        let URLString:String = Base_URL + API_URI.public_userPhoto.rawValue
        
        Alamofire.upload(multipartFormData: {(multipartFormData) in
            // code
            let imageData:Data = UIImageJPEGRepresentation(picFile, 0.7)!
            
            multipartFormData.append(imageData, withName: "picFile", fileName: "picFile", mimeType: "image/jpeg");
            }, to: URLString, encodingCompletion: { (result) in
                switch result {
                case .success(let upload, _, _):
                    upload.responseObject { (response:DataResponse<UserPhoto>) in
                        completeHandler(response.result.value);
                    }
                case .failure(let encodingError):
                    print("error")
                    print(encodingError)
                }
        })
    }
    
    //4.2.注册用户和资料 POST
    func postPublicUserAndProfileSignup(withSignpModel signup:UserSignupModel ,completeHandler :@escaping(_ userAndProfile:UserAndProfile?) -> Void) -> Void {
        let URLString:String = self.Base_URL + API_URI.public_signup.rawValue
        let request = HTTPRequestGenerator(withParam:[
            "userPhotoUuid":signup.userPhotoUuid,
            "mobile": signup.mobile,
            "passwd": signup.passwd,
            "country": signup.country,
            "nickname": signup.nickname,
            "sex": signup.sex,
            "birthdate":signup.birthdate,
            ], URLString: URLString)
        
        Alamofire.request(request).responseObject { (response:DataResponse<UserAndProfile>) in
            completeHandler(response.result.value);
        }
    }
    
    //5.登录 POST
    func postAuthLogin(withMobile mobile:String, passwd:String,completeHandler :@escaping(_ loginModel:LoginModel?) -> Void) -> Void {
        let URLString:String = self.Base_URL + API_URI.auth_login.rawValue
        
        Alamofire.upload(multipartFormData: {(multipartFormData) in
            // code
            let mobileData = mobile.data(using: String.Encoding.utf8)
            let passwdData = passwd.data(using: String.Encoding.utf8)
            
            multipartFormData.append(mobileData!, withName: "mobile")
            multipartFormData.append(passwdData!, withName: "passwd")
            }, to: URLString, encodingCompletion: { (result) in
                switch result {
                case .success(let upload, _, _):
                    upload.responseObject { (response:DataResponse<LoginModel>) in
                        completeHandler(response.result.value);
                    }
                case .failure(let encodingError):
                    print("error")
                    print(encodingError)
                }
        })
        
    }
    
    //6.登出 POST
    func postAuthLogout(completeHandler :@escaping(_ response:Response?) -> Void) -> Void {
        let uuid = Global.shared.globalLogin?.user?.uuid
        let token = Global.shared.globalLogin?.token
        
        if (uuid?.isEmpty)! || (token?.isEmpty)!{
            SGLog(message: "数据为空")
            return
        }
        
        let URLString:String = self.Base_URL + API_URI.auth_mobileapps_logout.rawValue
        Alamofire.upload(multipartFormData: {(multipartFormData) in
            let uuidData = uuid?.data(using: String.Encoding.utf8)
            let tokenData = token?.data(using: String.Encoding.utf8)
            
            multipartFormData.append(uuidData!, withName: "uuid")
            multipartFormData.append(tokenData!, withName: "token")
            }, to: URLString, encodingCompletion: { (result) in
                switch result {
                case .success(let upload, _, _):
                    upload.responseObject { (response:DataResponse<Response>) in
                        completeHandler(response.result.value);
                    }
                case .failure(let encodingError):
                    print("error")
                    print(encodingError)
                }
        })
    }
    
    //7.修改个人资料页面的文字资料
    func postUserProfile(nickname:String,sex:String,birthdate:String,area:String,commonCities:String,university:String,completeHandler :@escaping(_ response:ModifyUserProfile?) -> Void) -> Void {
        let userUuid = Global.shared.globalProfile?.userUuid
        let uuid = Global.shared.globalProfile?.uuid
        let token = Global.shared.globalLogin?.token
        
        if (userUuid?.isEmpty)! || (uuid?.isEmpty)! || (token?.isEmpty)!{
            SGLog(message: "数据为空")
            return
        }
        
        var URLString:String = self.Base_URL + API_URI.post_userProfile.rawValue
        URLString = URLString.replacingOccurrences(of: "{userUuid}", with: userUuid!)
        URLString = URLString.replacingOccurrences(of: "{uuid}", with: uuid!)
        URLString = URLString.replacingOccurrences(of: "{token}", with: token!)
        
        let request = HTTPRequestGenerator(withParam:[
            "nickname": nickname,
            "sex": sex,
            "birthdate":birthdate,
            "area": area,
            "commonCities": commonCities,
            "university": university,
            ], method: .put, URLString: URLString)

        Alamofire.request(request).responseObject { (response:DataResponse<ModifyUserProfile>) in
            let code = response.result.value?.status
            if self.validAuthCode(code: code) {
                completeHandler(response.result.value)
            }
        }
    }
    
    //9.查看个人资料页面的文字和图片
    func getUserProfile(userUuid: String?,likeSenderUserUuid: String?, completeHandler :@escaping(_ response:UserProfile?) -> Void)  -> Void {
        let token = Global.shared.globalLogin?.token

        if (userUuid?.isEmpty)! || (likeSenderUserUuid?.isEmpty)! || (token?.isEmpty)!{
            SGLog(message: "数据为空")
            return
        }
        
        var URLString:String = self.Base_URL + API_URI.get_userProfile.rawValue
        
        URLString = URLString.replacingOccurrences(of: "{userUuid}", with: userUuid!)
        URLString = URLString.replacingOccurrences(of: "{likeSenderUserUuid}", with: likeSenderUserUuid!)
        URLString = URLString.replacingOccurrences(of: "{token}", with: token!)

        Alamofire.request(URLString, parameters: nil).responseObject { (response:DataResponse<UserProfile>) in
            let code = response.result.value?.status
            if self.validAuthCode(code: code) {
                completeHandler(response.result.value)
            }
        }
    }
    /******
     //10.陌生人查看个人资料页面时对资料点赞
     func putUserProfileLike(uuid:String,completeHandler :@escaping(_ response:Response?) -> Void)  -> Void {
     let userUuid = Global.shared.globalProfile?.userUuid
     let token = Global.shared.globalLogin?.token
     
     if (userUuid?.isEmpty)! || (token?.isEmpty)!{
     SGLog(message: "数据为空")
     return
     }
     
     var URLString:String = self.Base_URL + API_URI.put_userProfile_like.rawValue
     URLString = URLString.replacingOccurrences(of: "{userUuid}", with: userUuid!)
     URLString = URLString.replacingOccurrences(of: "{uuid}", with: uuid)
     URLString = URLString.replacingOccurrences(of: "{token}", with: token!)
     
     let request = HTTPRequestGenerator(withParam:[
     "likesCount": "1",
     ] , method: .put, URLString: URLString)
     
     Alamofire.request(request).responseObject { (response:DataResponse<Response>) in
     if (response.result.value?.status) != nil &&
     response.result.value?.status == ResponseError.ERROR_AUTH_CODE.0{
     Global.shared.logout()
                HUD.flash(.label("账号异常"), delay: 2)
     NotificationCenter.default.post(name: SGGlobalKey.LoginStatusDidChange, object: nil)
     }else{
     completeHandler(response.result.value);
     }
     }
     }******/
    
    //11.查看个人设置
    func getSysConfig(completeHandler :@escaping(_ response:SysConfig?) -> Void)  -> Void {
        var URLString:String = self.Base_URL + API_URI.userProfile_sysConfig.rawValue
        let userUuid = Global.shared.globalProfile?.userUuid
        let uuid = Global.shared.globalProfile?.uuid
        let token = Global.shared.globalLogin?.token
        
        if (userUuid?.isEmpty)! || (uuid?.isEmpty)! || (token?.isEmpty)!{
            SGLog(message: "数据为空")
            return
        }
        
        URLString = URLString.replacingOccurrences(of: "{userUuid}", with: userUuid!)
        URLString = URLString.replacingOccurrences(of: "{uuid}", with: uuid!)
        URLString = URLString.replacingOccurrences(of: "{token}", with: token!)
        
        
        Alamofire.request(URLString, parameters: ["":""]).responseObject { (response:DataResponse<SysConfig>) in
            let code = response.result.value?.status
            if self.validAuthCode(code: code) {
                completeHandler(response.result.value)
            }
        }
    }
    
    //12.用原有登录密码修改账户密码
    func putUpdatePwd(oldPwd: String,newPwd: String,completeHandler :@escaping(_ response:Response?) -> Void)  -> Void {
        let uuid = Global.shared.globalProfile?.uuid
        
        if  (uuid?.isEmpty)!{
            SGLog(message: "数据为空")
            return
        }
        
        var URLString:String = self.Base_URL + API_URI.put_updatePwd.rawValue
        URLString = URLString.replacingOccurrences(of: "{uuid}", with: uuid!)
        
        let request = HTTPRequestGenerator(withParam:[
            "oldPwd":oldPwd,
            "newPwd":newPwd,]
            , method: .put, URLString: URLString)
        
        Alamofire.request(request).responseObject { (response:DataResponse<Response>) in
            let code = response.result.value?.status
            if self.validAuthCode(code: code) {
                completeHandler(response.result.value)
            }
        }
    }
    
    //13.通过短信验证码修改账户密码
    func postChangePwd(toPhoneno: String,verifyCode: String,smsChangeNewPwd: String,completeHandler :@escaping(_ response:Response?) -> Void)  -> Void {
        let URLString:String = self.Base_URL + API_URI.post_changePwd.rawValue
        
        let request = HTTPRequestGenerator(withParam:[
            "toPhoneno":toPhoneno,
            "verifyCode":verifyCode,
            "smsChangeNewPwd":smsChangeNewPwd,]
            , URLString: URLString)
        
        Alamofire.request(request).responseObject { (response:DataResponse<Response>) in
            let code = response.result.value?.status
            if self.validAuthCode(code: code) {
                completeHandler(response.result.value)
            }
        }
    }
    
    //14.账户APPLE STORE充值
    func getMoney(toPhoneno: String,type: String, completeHandler :@escaping(_ response:Response?) -> Void)  -> Void {
        let URLString:String = self.Base_URL + API_URI.get_money.rawValue
        let request = HTTPRequestGenerator(withParam:[
            "toPhoneno":toPhoneno,
            "type":type,]
            , URLString: URLString)
        
        Alamofire.request(request).responseObject { (response:DataResponse<Response>) in
            let code = response.result.value?.status
            if self.validAuthCode(code: code) {
                completeHandler(response.result.value)
            }
        }
    }
    
    //15.修改个人设置
    func putSysConfig(isAcceptSysNotify:Bool,isAcceptPrivateChat: Bool,completeHandler :@escaping(_ response:Response?) -> Void)  -> Void {
        let userUuid = Global.shared.globalProfile?.userUuid
        let uuid = Global.shared.globalProfile?.uuid
        let token = Global.shared.globalLogin?.token
        
        if (userUuid?.isEmpty)! || (uuid?.isEmpty)! || (token?.isEmpty)!{
            SGLog(message: "数据为空")
            return
        }
        
        var URLString:String = self.Base_URL + API_URI.userProfile_sysConfig.rawValue
        URLString = URLString.replacingOccurrences(of: "{uuid}", with: uuid!)
        URLString = URLString.replacingOccurrences(of: "{userUuid}", with: userUuid!)
        URLString = URLString.replacingOccurrences(of: "{token}", with: token!)
        
        let request = HTTPRequestGenerator(withParam:[
            "isAcceptPrivateChat":isAcceptPrivateChat,
            "isAcceptSysNotify":isAcceptSysNotify]
            , method: .put, URLString: URLString)
        
        Alamofire.request(request).responseObject { (response:DataResponse<Response>) in
            let code = response.result.value?.status
            if self.validAuthCode(code: code) {
                completeHandler(response.result.value)
            }
        }
    }
    
    //17.用户资料页面，添加个人照片
    func postUserPhoto(image: UIImage,completeHandler :@escaping(_ userPhoto:UserPhoto?) -> Void) -> Void{
        let userUuid = Global.shared.globalProfile?.uuid
        let token = Global.shared.globalLogin?.token
        
        if (userUuid?.isEmpty)! || (token?.isEmpty)!{
            SGLog(message: "数据为空")
            return
        }
        
        var URLString:String = self.Base_URL + API_URI.post_userPhoto.rawValue
        URLString = URLString.replacingOccurrences(of: "{uuid}", with: userUuid!)
        URLString = URLString.replacingOccurrences(of: "{token}", with: token!)
        
        Alamofire.upload(multipartFormData: {(multipartFormData) in
            // code
            let imageData:Data = UIImageJPEGRepresentation(image, 0.7)!
            
            multipartFormData.append(imageData, withName: "picFile", fileName: "picFile", mimeType: "image/jpeg");
            
            }, to: URLString, encodingCompletion: { (result) in
                switch result {
                case .success(let upload, _, _):
                    upload.responseObject { (response:DataResponse<UserPhoto>) in
                        let code = response.result.value?.status
                        if self.validAuthCode(code: code) {
                            completeHandler(response.result.value)
                        }
                    }
                case .failure(let encodingError):
                    print("error")
                    print(encodingError)
                }
        })
        
    }
    
    //18.用户资料页面，删除指定的个人照片
    func deleteUserPhoto(photoUuid: String,completeHandler :@escaping(_ response:Response?) -> Void)  -> Void {
        
        let userUuid = Global.shared.globalProfile?.userUuid
        let token = Global.shared.globalLogin?.token
        
        if (userUuid?.isEmpty)! || (token?.isEmpty)!{
            SGLog(message: "数据为空")
            return
        }
        
        var URLString:String = self.Base_URL + API_URI.delete_userPhoto.rawValue
        URLString = URLString.replacingOccurrences(of: "{uuid}", with: photoUuid)
        URLString = URLString.replacingOccurrences(of: "{userUuid}", with: userUuid!)
        URLString = URLString.replacingOccurrences(of: "{token}", with: token!)
        
        let request = HTTPRequestGenerator(withParam:["":""]
            , method: .delete, URLString: URLString)
        
        Alamofire.request(request).responseObject { (response:DataResponse<Response>) in
            let code = response.result.value?.status
            if self.validAuthCode(code: code) {
                completeHandler(response.result.value)
            }
        }
    }
    
    //19.陌生人查看个人资料页面时对资料点赞
    func post_likeProfile(userUuid: String?,completeHandler :@escaping(_ response:Response?) -> Void)  -> Void {
        
        let likeSenderUserUuid = Global.shared.globalProfile?.uuid
        let token = Global.shared.globalLogin?.token
        
        if (userUuid?.isEmpty)!  || (token?.isEmpty)! || (likeSenderUserUuid?.isEmpty)!{
            SGLog(message: "数据为空")
            return
        }
        
        var URLString:String = self.Base_URL + API_URI.userProfile_likeProfile.rawValue
        URLString = URLString.replacingOccurrences(of: "{userProfileUuid}", with: userUuid!)
        URLString = URLString.replacingOccurrences(of: "{token}", with: token!)
        let request = HTTPRequestGenerator(withParam:
            ["likeSenderUserUuid":likeSenderUserUuid!], URLString: URLString)
        
        Alamofire.request(request).responseObject { (response:DataResponse<Response>) in
            let code = response.result.value?.status
            if self.validAuthCode(code: code) {
                completeHandler(response.result.value)
            }
        }
    }
    
    //20.用户查看自己的资料页面时点击（红心，XX人喜欢）按钮，查看点赞发出者头像名称列表
    func getLikeProfile(pageNum: String,pageSize: String,completeHandler :@escaping(_ response:LikeProfileResult?) -> Void)  -> Void {
        
        let userUuid = Global.shared.globalProfile?.uuid
        let token = Global.shared.globalLogin?.token
        
        if (userUuid?.isEmpty)! || (token?.isEmpty)!{
            SGLog(message: "数据为空")
            return
        }
        
        var URLString:String = self.Base_URL + API_URI.userProfile_likeProfile.rawValue
        URLString = URLString.replacingOccurrences(of: "{userProfileUuid}", with: userUuid!)
        URLString = URLString.replacingOccurrences(of: "{token}", with: token!)
        
        Alamofire.request(URLString, parameters:["pageNum":pageNum,"pageSize":pageSize]).responseObject { (response:DataResponse<LikeProfileResult>) in
            let code = response.result.value?.status
            if self.validAuthCode(code: code) {
                completeHandler(response.result.value)
            }
        }
    }
    
    //MARK:B2.探索图片模块
    //21 探索图片空间，新添加图片 POST
    func postPhotoGallery(picFile:UIImage,completeHandler :@escaping(_ userPhoto:UserPhoto?) -> Void) -> Void {
        let userUuid = Global.shared.globalProfile?.userUuid
        let token = Global.shared.globalLogin?.token
        
        if (userUuid?.isEmpty)! || (token?.isEmpty)!{
            SGLog(message: "数据为空")
            return
        }
        
        var URLString:String = Base_URL + API_URI.user_gallery.rawValue
        URLString = URLString.replacingOccurrences(of: "{userUuid}", with: userUuid!)
        URLString = URLString.replacingOccurrences(of: "{token}", with: token!)
        
        Alamofire.upload(multipartFormData: {(multipartFormData) in
            // code
            let imageData:Data = UIImageJPEGRepresentation(picFile, 0.7)!
            
            multipartFormData.append(imageData, withName: "picFile", fileName: "picFile", mimeType: "image/jpeg");
            }, to: URLString, encodingCompletion: { (result) in
                switch result {
                case .success(let upload, _, _):
                    upload.responseObject { (response:DataResponse<UserPhoto>) in
                        let code = response.result.value?.status
                        if self.validAuthCode(code: code) {
                            completeHandler(response.result.value)
                        }
                    }
                case .failure(let encodingError):
                    print("error")
                    print(encodingError)
                }
        })
    }
    //22.探索图片空间，分页获取某人的图片列表
    func getPhotoGallery(userUuid: String?,pageNum: String,pageSize: String,completeHandler :@escaping(_ response:UserGallery?) -> Void)  -> Void {
        
        let token = Global.shared.globalLogin?.token
        
        if (userUuid?.isEmpty)! || (token?.isEmpty)!{
            SGLog(message: "数据为空")
            return
        }
        
        var URLString:String = self.Base_URL + API_URI.user_gallery.rawValue
        URLString = URLString.replacingOccurrences(of: "{userUuid}", with: userUuid!)
        URLString = URLString.replacingOccurrences(of: "{token}", with: token!)
        
        Alamofire.request(URLString, parameters:["pageNum":pageNum,"pageSize":pageSize]).responseObject { (response:DataResponse<UserGallery>) in
            let code = response.result.value?.status
            if self.validAuthCode(code: code) {
                completeHandler(response.result.value)
            }
        }
    }
    
    //23.探索图片空间，删除指定的图片
    func deletePhotoFromGallery(photoUuid: String,completeHandler :@escaping(_ response:Response?) -> Void)  -> Void {
        
        let userUuid = Global.shared.globalProfile?.uuid
        let token = Global.shared.globalLogin?.token
        
        if (userUuid?.isEmpty)! || (token?.isEmpty)!{
            SGLog(message: "数据为空")
            return
        }
        
        var URLString:String = self.Base_URL + API_URI.delete_gallery.rawValue
        URLString = URLString.replacingOccurrences(of: "{uuid}", with: photoUuid)
        URLString = URLString.replacingOccurrences(of: "{userUuid}", with: userUuid!)
        URLString = URLString.replacingOccurrences(of: "{token}", with: token!)
        
        let request = HTTPRequestGenerator(withParam:["":""]
            , method: .delete, URLString: URLString)
        
        Alamofire.request(request).responseObject { (response:DataResponse<Response>) in
            let code = response.result.value?.status
            if self.validAuthCode(code: code) {
                completeHandler(response.result.value)
            }
        }
    }
    ///displayOrder: newest：hottest
    
    enum DisplayType: String {
        case newest = "newest"
        case hottest = "hottest"
    }
    
    //24.探索图片空间，分页获取"最新Tab"或者"最热Tab"图片列表
    func getOrderGallery(likeSenderUserUuid: String?,displayType: DisplayType,pageNum: String,pageSize: String,completeHandler :@escaping(_ response:DisplayOrder?) -> Void)  -> Void {
        let token = Global.shared.globalLogin?.token
        
        if (likeSenderUserUuid?.isEmpty)! || (token?.isEmpty)!{
            SGLog(message: "数据为空")
            return
        }
        
        var URLString:String = Base_URL + API_URI.get_orderGallery.rawValue
        URLString = URLString.replacingOccurrences(of: "{likeSenderUserUuid}", with: likeSenderUserUuid!)
        URLString = URLString.replacingOccurrences(of: "{token}", with: token!)
        URLString = URLString.replacingOccurrences(of: "{displayOrder}", with: displayType.rawValue)
        
        Alamofire.request(URLString, parameters:["pageNum":pageNum,"pageSize":pageSize]).responseObject { (response:DataResponse<DisplayOrder>) in
            let code = response.result.value?.status
            if self.validAuthCode(code: code) {
                completeHandler(response.result.value)
            }
        }
    }
    
    //25.陌生人查看探索图片时点赞POST
    func postLikeGalleryList(likeSenderUserUuid: String?,galleryUuid: String?,completeHandler :@escaping(_ response:Response?) -> Void)  -> Void {
        let token = Global.shared.globalLogin?.token
        
        if  (token?.isEmpty)! || (galleryUuid?.isEmpty)! ||
            (likeSenderUserUuid?.isEmpty)!{
            SGLog(message: "数据为空")
            return
        }
        
        var URLString:String = Base_URL + API_URI.gallery_likeGallery.rawValue
        URLString = URLString.replacingOccurrences(of: "{token}", with: token!)
        URLString = URLString.replacingOccurrences(of: "{galleryUuid}", with: galleryUuid!)
        
        let request = HTTPRequestGenerator(withParam:["likeSenderUserUuid":likeSenderUserUuid!], URLString: URLString)
        
        Alamofire.request(request).responseObject { (response:DataResponse<Response>) in
            let code = response.result.value?.status
            if self.validAuthCode(code: code) {
                completeHandler(response.result.value)
            }
        }
    }
    //26.用户查看自己的探索图片左下方的3个点赞头像列表，查看点赞发出者头像名称列表（传分页参数分页）
    func getLikeGalleryList(likeSenderUserUuid: String?,galleryUuid: String?,pageNum: String,pageSize: String,completeHandler :@escaping(_ response:LikeProfileResult?) -> Void)  -> Void {
        let token = Global.shared.globalLogin?.token
        
        if  (token?.isEmpty)! || (galleryUuid?.isEmpty)!{
            SGLog(message: "数据为空")
            return
        }
        
        var URLString:String = Base_URL + API_URI.gallery_likeGallery.rawValue
        URLString = URLString.replacingOccurrences(of: "{token}", with: token!)
        URLString = URLString.replacingOccurrences(of: "{galleryUuid}", with: galleryUuid!)
        
        Alamofire.request(URLString, parameters:["pageNum":pageNum,"pageSize":pageSize]).responseObject { (response:DataResponse<LikeProfileResult>) in
            let code = response.result.value?.status
            if self.validAuthCode(code: code) {
                completeHandler(response.result.value)
            }
        }
    }
}
