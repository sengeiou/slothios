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
    static let USER_DID_REGISTER = ("216", "注册过的啦~直接去登陆咯!")
    static let USER_NOT_REGISTER = ("217", "别逗了了~快去注册吧~")

    static let NO_PRIVELLEGE = ("300", "权限错误")
    static let NOT_ENOUGH_MONEY = ("301", "账户余下额度不足，请充值")
    static let PROFILE_FIRSTPIC_NOT_VERIFIED = ("302", "个人资料第一张头像未通过真人认证")
    static let PROFILE_PIC_NOT_VERIFIED = ("304", "上传的个人照片未通过真人认证")
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
    case auth_mobileapps_logout  = "/mobileauth/logout"
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
    case post_charge = "/api/user/{userUuid}/accounts/charge?token={token}"
    //15.修改个人设置
    //case userProfile_sysConfig = "/api/user/{userUuid}/userProfile/{uuid}/sysConfig?token={token}"
    //16.APPLE STORE充值可选的价格列表
    case get_itunesChargeList = "/api/public/product/itunesChargeList"
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
    //27.第一步发图传图成功后，广告竞价第二步，显示竞价加码页面
    case get_adsBidOrder = "/api/user/{userUuid}/bidGallery/{bidGalleryUuid}/adsBidOrder?token={token}"
    //28.在显示竞价加码页面完成加码选择后，付款确认点击“发送”按钮
    case post_adsBidOrder = "/api/user/{userUuid}/adsBidOrder?token={token}"
    //B3.聊天模块
    //29.获取聊天SDK需要的TOKEN
    case get_chatToken = "/api/user/{userUuid}/chat/getToken?token={token}"
    //30.获取某用户UUID的所有会话列表，待定是否需要加分页参数做分页
    case get_chatList = "/api/user/{userUuid}/chat?token={token}"
    //31.获取指定官方群组 的所有官方群成员资料，需分页参数
    case get_officialGroupMember = "/api/officialGroup/{officialGroupUuid}/officialGroupMember?token={token}"
    //32.创建用户群组
    case post_createGroup = "/api/userGroup?token={token}"
    //33.修改用户群组的显示名称
    case handle_UserGroup = "/api/userGroup/{userGroupUuid}?token={token}"
    //34.（这次可能用不到）获取用户群组信息
    //case get_GroupName = "/api/userGroup/{userGroupUuid}?token={token}"
    //35.删除指定的创建用户群组
    //case delteUserGroup = "/api/userGroup/{userGroupUuid}?token={token}"
    //36.新加成员到指定群组
    case handle_userGroupMember = "/api/userGroup/{userGroupUuid}/userGroupMember?token={token}"
    //37.修改指定群组的某个指定群成员的显示名称
    case modify_userGroupMember = "/api/userGroup/{userGroupUuid}/userGroupMember/{userGroupMemberUuid}?token={token}"
    //38.获取指定群组的所有群成员资料，需分页参数
//    case get_userGroupMember = "/api/userGroup/{userGroupUuid}/userGroupMember?token={token}"
    //39.自己退出群，或者管理员删除指定群组的某个指定群成员
//    case delete_userGroupMember = "/api/userGroup/{userGroupUuid}/userGroupMember/{userGroupMemberUuid}?token={token}"
    //40.创建一对一私聊会话
    case post_privateChat = "/api/privateChat?token={token}"
    //41.删除指定一对一私聊会话
    case delete_privateChat = "/api/privateChat/{uuid}?token={token}"
    case put_officialGroupMemberName = "/api/officialGroup/{officialGroupUuid}/officialGroupMember/{officialGroupMemberUuid}?token={token}"
}

class NetworkEngine: NSObject {
    var alamofireManager:SessionManager = Alamofire.SessionManager()
    let Base_URL:String = NetworkEngine.getBaseURL()

    override init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 8 // seconds
        self.alamofireManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    class func getBaseURL() -> String {
        #if DEBUG
            if GVUserDefaults.standard().networkType == .develop {
                return "http://testapi.ssloth.com"
            }
            return "http://api.ssloth.com"
        #else
            return "http://api.ssloth.com"
        #endif
    }
    
    func HTTPRequestGenerator(withParam parameters:NSDictionary,URLString:String)->URLRequest {
        return HTTPRequestGenerator(withParam: parameters, method: HTTPMethod.post, URLString: URLString)
    }
    
    func HTTPRequestGenerator(withParam parameters: NSDictionary,method: HTTPMethod,URLString: String)->URLRequest {
        return HTTPRequestGenerator(withParam: parameters, method: method, contentType: "application/json", URLString: URLString)
    }
    
    func HTTPRequestGenerator(withParam parameters: NSDictionary,method: HTTPMethod,contentType: String,URLString: String)->URLRequest {
        var request = URLRequest(url: NSURL.init(string: URLString) as! URL)
        request.httpMethod = method.rawValue
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        let values = parameters
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: values)
        
        return request
    }
    
    func verificationResponse(value: NSObject?) -> Bool {
        guard let value = value else {
            SGLog(message: "无对象")
            return false
        }
        guard let code = value.value(forKey: "status") else {
            SGLog(message: "无status")
            return false
        }
        SGLog(message: String(describing: value))
        SGLog(message: value.allPropertyNamesAndValues())
        
        return self.validAuthCode(code: code as? String)
    }
    
    func validAuthCode(code: String?) -> Bool {
        let authCode = ResponseError.ERROR_AUTH_CODE.0
        
        guard let code = code, code == authCode  else {
            return true
        }
        
        Global.shared.logout()
        
        UIViewController.showCurrentViewControllerNotificationError(message: "账号异常")
        NotificationCenter.default.post(name: SGGlobalKey.LoginStatusDidChange, object: nil)
        return false
    }
    
    func showHandleError() {
        UIViewController.showCurrentViewControllerNotificationError(message: "操作异常")
    }
    
    //MARK:- B1.用户模块
    //1.注册选择国家信息列表 GET
    func getPublicCountry(withName name:String,completeHandler :@escaping(_ countryObj:Country?) -> Void) -> Void {
        let URLString:String = Base_URL + API_URI.public_coutry.rawValue
        
        alamofireManager.request(URLString, parameters: ["name":name]).responseObject { (response:DataResponse<Country>) in
            if self.verificationResponse(value: response.result.value) {
                completeHandler(response.result.value)
            }else{
                completeHandler(response.result.value)
            }
        }
    }
    
    //2.获取短信验证码 POST
    func postPublicSMS(withType type:String, toPhoneno:String, completeHandler :@escaping(_ smsObj:SMS?) -> Void) -> Void {
        let URLString:String = Base_URL + API_URI.public_sms.rawValue
        let request = HTTPRequestGenerator(withParam: ["type":type,"toPhoneno":toPhoneno], URLString: URLString)
        
        alamofireManager.request(request).responseObject { (response:DataResponse<SMS>) in
            if self.verificationResponse(value: response.result.value) {
                completeHandler(response.result.value)
            }else{
                completeHandler(response.result.value)
            }
        }
        
    }
    
    //3.校验短信验证码是否正确 POST
    func postPublicSMSCheck(WithPhoneNumber toPhoneno:String,verifyCode:String, completeHandler :@escaping(_ smsObj:SMS?) -> Void) -> Void {
        let URLString:String = Base_URL + API_URI.public_sms_check.rawValue
        let request = HTTPRequestGenerator(withParam: ["toPhoneno":toPhoneno,
                                                       "verifyCode":verifyCode], URLString: URLString);
        alamofireManager.request(request)
            .responseObject { (response:DataResponse<SMS>) in
                if self.verificationResponse(value: response.result.value) {
                    completeHandler(response.result.value)
                }else{
                    self.showHandleError()
                }
        }
        
    }
    
    //4.1.注册初始化用户头像 POST
    func postPicFile(picFile:UIImage,completeHandler :@escaping(_ userPhoto:UserPhoto?) -> Void) -> Void {
        let URLString:String = Base_URL + API_URI.public_userPhoto.rawValue
        
        alamofireManager.upload(multipartFormData: {(multipartFormData) in
            // code
            guard let imageData:Data = UIImageJPEGRepresentation(picFile, 1.0) else{
                SGLog(message: "imageData 为空");
                return
            }
            
            multipartFormData.append(imageData, withName: "picFile", fileName: "picFile", mimeType: "image/jpeg");
            }, to: URLString, encodingCompletion: { (result) in
                switch result {
                case .success(let upload, _, _):
                    upload.responseObject { (response:DataResponse<UserPhoto>) in
                        if self.verificationResponse(value: response.result.value) {
                            completeHandler(response.result.value)
                        }else{
                            self.showHandleError()
                        }
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
        
        alamofireManager.request(request).responseObject { (response:DataResponse<UserAndProfile>) in
            if self.verificationResponse(value: response.result.value) {
                completeHandler(response.result.value)
            }else{
                completeHandler(response.result.value)
            }
        }
    }
    
    //MARK:5.登录 POST
    func postAuthLogin(withMobile mobile:String, passwd:String,completeHandler :@escaping(_ loginModel:LoginModel?) -> Void) -> Void {
        let URLString:String = self.Base_URL + API_URI.auth_login.rawValue
        
        Alamofire.upload(multipartFormData: {(multipartFormData) in
            // code
            guard let mobileData = mobile.data(using: String.Encoding.utf8),
                let passwdData = passwd.data(using: String.Encoding.utf8) else{
                    SGLog(message: "mobileData or passwdData 为空")
                    return
            }
            
            multipartFormData.append(mobileData, withName: "mobile")
            multipartFormData.append(passwdData, withName: "passwd")
            }, to: URLString, encodingCompletion: { (result) in
                switch result {
                case .success(let upload, _, _):
                    upload.responseObject { (response:DataResponse<LoginModel>) in
                        if (response.response?.statusCode == 200) || (response.response?.statusCode == 201) {
                            completeHandler(response.result.value)
                        }
                        else {
                            completeHandler(nil);
                        }
                        
                        //SGLog(message: response.response?.statusCode)
                        
                        
//                        if self.verificationResponse(value: response.result.value) {
//                            completeHandler(response.result.value)
//                        }else{
//                            self.showHandleError()
//                        }
                    }
                case .failure(let encodingError):
                    print("error")
                    print(encodingError)
                }
        })
        
    }
    
    //6.登出 POST
    func postAuthLogout(completeHandler :@escaping(_ response:Response?) -> Void) -> Void {
        guard let token = Global.shared.globalLogin?.token,
            let uuid = Global.shared.globalProfile?.userUuid else {
                SGLog(message: "数据为空")
                return
        }
        
        let URLString:String = self.Base_URL + API_URI.auth_mobileapps_logout.rawValue
        alamofireManager.upload(multipartFormData: {(multipartFormData) in
            guard let uuidData = uuid.data(using: String.Encoding.utf8),
                let tokenData = token.data(using: String.Encoding.utf8) else{
                    return
            }
            
            multipartFormData.append(uuidData, withName: "uuid")
            multipartFormData.append(tokenData, withName: "token")
            }, to: URLString, encodingCompletion: { (result) in
                switch result {
                case .success(let upload, _, _):
                    upload.responseObject { (response:DataResponse<Response>) in
                        if self.verificationResponse(value: response.result.value) {
                            completeHandler(response.result.value)
                        }else{
                            self.showHandleError()
                        }
                    }
                case .failure(let encodingError):
                    print("error")
                    print(encodingError)
                }
        })
    }
    
    //7.修改个人资料页面的文字资料
    func postUserProfile(nickname:String,sex:String,birthdate:String,university:String,personalProfile:String,completeHandler :@escaping(_ response:ModifyUserProfile?) -> Void) -> Void {
        guard let token = Global.shared.globalLogin?.token,
            let userUuid = Global.shared.globalProfile?.userUuid,
            let uuid = Global.shared.globalProfile?.uuid else {
                SGLog(message: "数据为空")
                return
        }
        
        var URLString:String = self.Base_URL + API_URI.post_userProfile.rawValue
        URLString = URLString.replacingOccurrences(of: "{userUuid}", with: userUuid)
        URLString = URLString.replacingOccurrences(of: "{uuid}", with: uuid)
        URLString = URLString.replacingOccurrences(of: "{token}", with: token)
        
        let request = HTTPRequestGenerator(withParam:[
            "nickname": nickname,
            "sex": sex,
            "birthdate":birthdate,
            "university": university,
            "personalProfile": personalProfile,
            ], method: .put, URLString: URLString)

        alamofireManager.request(request).responseObject { (response:DataResponse<ModifyUserProfile>) in
            if self.verificationResponse(value: response.result.value){
                completeHandler(response.result.value)
            }else{
                completeHandler(response.result.value)
            }
        }
    }
    
    //9.查看个人资料页面的文字和图片
    func getUserProfile(userUuid: String?, completeHandler :@escaping(_ response:UserProfile?) -> Void)  -> Void {
        var likeUuid: String?
        
        likeUuid = Global.shared.globalLogin?.user?.uuid

        guard let token = Global.shared.globalLogin?.token,
              let likeSenderUserUuid = likeUuid,
              let userUuid = userUuid else {
            SGLog(message: "数据为空")
            return
        }
        
        var URLString:String = self.Base_URL + API_URI.get_userProfile.rawValue
        
        URLString = URLString.replacingOccurrences(of: "{userUuid}", with: userUuid)
        URLString = URLString.replacingOccurrences(of: "{likeSenderUserUuid}", with: likeSenderUserUuid)
        URLString = URLString.replacingOccurrences(of: "{token}", with: token)

        alamofireManager.request(URLString, parameters: nil).responseObject { (response:DataResponse<UserProfile>) in
            if self.verificationResponse(value: response.result.value){
                completeHandler(response.result.value)
            }else{
                completeHandler(response.result.value)
            }
        }
    }
    
    //11.查看个人设置
    func getSysConfig(completeHandler :@escaping(_ response:SysConfig?) -> Void)  -> Void {
        guard let token = Global.shared.globalLogin?.token,
            let userUuid = Global.shared.globalProfile?.userUuid,
            let uuid = Global.shared.globalProfile?.uuid else {
                SGLog(message: "数据为空")
                return
        }
        
        var URLString:String = self.Base_URL + API_URI.userProfile_sysConfig.rawValue
        URLString = URLString.replacingOccurrences(of: "{userUuid}", with: userUuid)
        URLString = URLString.replacingOccurrences(of: "{uuid}", with: uuid)
        URLString = URLString.replacingOccurrences(of: "{token}", with: token)
        
        alamofireManager.request(URLString, parameters: ["":""]).responseObject { (response:DataResponse<SysConfig>) in
            if self.verificationResponse(value: response.result.value){
                completeHandler(response.result.value)
            }else{
                completeHandler(response.result.value)
            }
        }
    }
    
    //12.用原有登录密码修改账户密码
    func putUpdatePwd(oldPwd: String,newPwd: String,completeHandler :@escaping(_ response:Response?) -> Void)  -> Void {
        guard let uuid = Global.shared.globalProfile?.uuid else {
                SGLog(message: "数据为空")
                return
        }
        
        var URLString:String = self.Base_URL + API_URI.put_updatePwd.rawValue
        URLString = URLString.replacingOccurrences(of: "{uuid}", with: uuid)
        
        let request = HTTPRequestGenerator(withParam:[
            "oldPwd":oldPwd,
            "newPwd":newPwd,]
            , method: .put, URLString: URLString)
        
        alamofireManager.request(request).responseObject { (response:DataResponse<Response>) in
            if self.verificationResponse(value: response.result.value){
                completeHandler(response.result.value)
            }else{
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
        
        alamofireManager.request(request).responseObject { (response:DataResponse<Response>) in
            if self.verificationResponse(value: response.result.value){
                completeHandler(response.result.value)
            }else{
                completeHandler(response.result.value)
            }
        }
    }
    
    //14.账户APPLE STORE充值
    func postCharge(appPayReceipt: String, productId: String?, transactionId: String?, completeHandler :@escaping(_ response:Response?) -> Void)  -> Void {
        guard let token = Global.shared.globalLogin?.token,
            let userUuid = Global.shared.globalProfile?.userUuid,
            let productId = productId,
            let transactionId = transactionId else {
                SGLog(message: "数据为空")
                return
        }
        var URLString:String = self.Base_URL + API_URI.post_charge.rawValue
        URLString = URLString.replacingOccurrences(of: "{userUuid}", with: userUuid)
        URLString = URLString.replacingOccurrences(of: "{token}", with: token)

        let request = HTTPRequestGenerator(withParam:[
            "appPayReceipt":appPayReceipt,
            "productId":productId,
            "transactionId":transactionId,]
            , URLString: URLString)
        
        alamofireManager.request(request).responseObject { (response:DataResponse<Response>) in
            if self.verificationResponse(value: response.result.value){
                completeHandler(response.result.value)
            }else{
                completeHandler(response.result.value)
            }
        }
    }
    
    //15.修改个人设置
    func putSysConfig(isAcceptSysNotify:Bool,isAcceptPrivateChat: Bool,completeHandler :@escaping(_ response:Response?) -> Void)  -> Void {
        guard let token = Global.shared.globalLogin?.token,
            let userUuid = Global.shared.globalProfile?.userUuid,
            let uuid = Global.shared.globalProfile?.uuid else {
                SGLog(message: "数据为空")
                return
        }
        
        var URLString:String = self.Base_URL + API_URI.userProfile_sysConfig.rawValue
        URLString = URLString.replacingOccurrences(of: "{uuid}", with: uuid)
        URLString = URLString.replacingOccurrences(of: "{userUuid}", with: userUuid)
        URLString = URLString.replacingOccurrences(of: "{token}", with: token)
        
        let request = HTTPRequestGenerator(withParam:[
            "isAcceptPrivateChat":isAcceptPrivateChat,
            "isAcceptSysNotify":isAcceptSysNotify]
            , method: .put, URLString: URLString)
        
        alamofireManager.request(request).responseObject { (response:DataResponse<Response>) in
            if self.verificationResponse(value: response.result.value){
                completeHandler(response.result.value)
            }else{
                completeHandler(response.result.value)
            }
        }
    }
    
    //MARK:16.APPLE STORE充值可选的价格列表
    func getItunesChargeList(completeHandler :@escaping(_ response:ItunesCharge?) -> Void)  -> Void {
        
        let URLString:String = self.Base_URL + API_URI.get_itunesChargeList.rawValue
        
        alamofireManager.request(URLString, parameters: ["":""]).responseObject { (response:DataResponse<ItunesCharge>) in
            if self.verificationResponse(value: response.result.value){
                completeHandler(response.result.value)
            }else{
                completeHandler(response.result.value)
            }
        }
    }
    
    //MARK:17.用户资料页面，添加个人照片
    func postUserPhoto(image: UIImage,completeHandler :@escaping(_ userPhoto:UserPhoto?) -> Void) -> Void{
        guard let token = Global.shared.globalLogin?.token,
            let uuid = Global.shared.globalProfile?.userUuid else {
                SGLog(message: "数据为空")
                return
        }
        
        var URLString:String = self.Base_URL + API_URI.post_userPhoto.rawValue
        URLString = URLString.replacingOccurrences(of: "{uuid}", with: uuid)
        URLString = URLString.replacingOccurrences(of: "{token}", with: token)
        
        self.alamofireManager.upload(multipartFormData: {(multipartFormData) in
            // code
            guard let imageData:Data = UIImageJPEGRepresentation(image, 1.0) else{
                SGLog(message: "imageData 为空");
                return
            }
            
            multipartFormData.append(imageData, withName: "picFile", fileName: "picFile", mimeType: "image/jpeg");
            
            }, to: URLString, encodingCompletion: { (result) in
                switch result {
                case .success(let upload, _, _):
                    upload.responseObject { (response:DataResponse<UserPhoto>) in
                        if (response.response?.statusCode == 200) || (response.response?.statusCode == 201) {
                            completeHandler(response.result.value)
                        } else {
                            completeHandler(nil);
                            self.showHandleError()
                        }
                    }
                case .failure(let encodingError):
                    print("error")
                    print(encodingError)
                    completeHandler(nil);
                }
        })
        
    }
    
    //18.用户资料页面，删除指定的个人照片
    func deleteUserPhoto(photoUuid: String,completeHandler :@escaping(_ response:Response?) -> Void)  -> Void {
        
        guard let token = Global.shared.globalLogin?.token,
            let userUuid = Global.shared.globalProfile?.userUuid else {
                SGLog(message: "数据为空")
                return
        }
        
        var URLString:String = self.Base_URL + API_URI.delete_userPhoto.rawValue
        URLString = URLString.replacingOccurrences(of: "{uuid}", with: photoUuid)
        URLString = URLString.replacingOccurrences(of: "{userUuid}", with: userUuid)
        URLString = URLString.replacingOccurrences(of: "{token}", with: token)
        
        let request = HTTPRequestGenerator(withParam:["":""]
            , method: .delete, URLString: URLString)
        
        alamofireManager.request(request).responseObject { (response:DataResponse<Response>) in
            if self.verificationResponse(value: response.result.value){
                completeHandler(response.result.value)
            }else{
                completeHandler(response.result.value)
            }
        }
    }
    
    //19.陌生人查看个人资料页面时对资料点赞
    func post_likeProfile(userProfileUuid: String?,completeHandler :@escaping(_ response:Response?) -> Void)  -> Void {
        
        guard let token = Global.shared.globalLogin?.token,
            let userUuid = Global.shared.globalProfile?.userUuid,
            let userProfileUuid = userProfileUuid else {
                SGLog(message: "数据为空")
                return
        }
        
        var URLString:String = self.Base_URL + API_URI.userProfile_likeProfile.rawValue
        URLString = URLString.replacingOccurrences(of: "{userProfileUuid}", with: userProfileUuid)
        URLString = URLString.replacingOccurrences(of: "{token}", with: token)
        let request = HTTPRequestGenerator(withParam:
            ["likeSenderUserUuid":userUuid], URLString: URLString)
        
        alamofireManager.request(request).responseObject { (response:DataResponse<Response>) in
            if self.verificationResponse(value: response.result.value){
                completeHandler(response.result.value)
            }else{
                completeHandler(response.result.value)
            }
        }
    }
    
    //20.用户查看自己的资料页面时点击（红心，XX人喜欢）按钮，查看点赞发出者头像名称列表
    func getLikeProfile(pageNum: String,pageSize: String,completeHandler :@escaping(_ response:LikeProfileResult?) -> Void)  -> Void {
        
        guard let token = Global.shared.globalLogin?.token,
            let uuid = Global.shared.globalProfile?.uuid else {
                SGLog(message: "数据为空")
                return
        }
        
        
        var URLString:String = self.Base_URL + API_URI.userProfile_likeProfile.rawValue
        URLString = URLString.replacingOccurrences(of: "{userProfileUuid}", with: uuid)
        URLString = URLString.replacingOccurrences(of: "{token}", with: token)
        
        alamofireManager.request(URLString, parameters:["pageNum":pageNum,"pageSize":pageSize]).responseObject { (response:DataResponse<LikeProfileResult>) in
            if self.verificationResponse(value: response.result.value){
                completeHandler(response.result.value)
            }else{
                completeHandler(response.result.value)
            }
        }
    }
    
    //MARK:-B2.探索图片模块
    //21 探索图片空间，新添加图片 POST
    func postPhotoGallery(picFile: UIImage,completeHandler :@escaping(_ userPhoto:GalleryPhoto?) -> Void) -> Void {
        guard let token = Global.shared.globalLogin?.token,
            let userUuid = Global.shared.globalProfile?.userUuid else {
                SGLog(message: "数据为空")
                return
        }
        
        var URLString:String = Base_URL + API_URI.user_gallery.rawValue
        URLString = URLString.replacingOccurrences(of: "{userUuid}", with: userUuid)
        URLString = URLString.replacingOccurrences(of: "{token}", with: token)
        
        var address = GVUserDefaults.standard().locationDesc
        if address != nil {
            address = address?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            URLString = URLString.appending("&adress=" + address!)
        }else{
            URLString = URLString.appending("&adress=")
        }
        
        alamofireManager.upload(multipartFormData: {(multipartFormData) in
            // code
            guard let imageData:Data = UIImageJPEGRepresentation(picFile, 1.0) else{
                SGLog(message: "imageData 为空");
                return
            }
            multipartFormData.append(imageData, withName: "picFile", fileName: "picFile", mimeType: "image/jpeg");
            }, to: URLString, encodingCompletion: { (result) in
                switch result {
                case .success(let upload, _, _):
                    upload.responseObject { (response:DataResponse<GalleryPhoto>) in
                        if self.verificationResponse(value: response.result.value) {
                            completeHandler(response.result.value)
                        }else{
                            self.showHandleError()
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
        
        guard let token = Global.shared.globalLogin?.token,
            let userUuid = userUuid else {
                SGLog(message: "数据为空")
                return
        }
        
        var URLString:String = self.Base_URL + API_URI.user_gallery.rawValue
        URLString = URLString.replacingOccurrences(of: "{userUuid}", with:userUuid)
        URLString = URLString.replacingOccurrences(of: "{token}", with: token)
        
        alamofireManager.request(URLString, parameters:["pageNum":pageNum,"pageSize":pageSize]).responseObject { (response:DataResponse<UserGallery>) in
            if self.verificationResponse(value: response.result.value){
                completeHandler(response.result.value)
            }else{
                completeHandler(response.result.value)
            }
        }
    }
    
    //23.探索图片空间，删除指定的图片
    func deletePhotoFromGallery(photoUuid: String,completeHandler :@escaping(_ response:Response?) -> Void)  -> Void {
        
        guard let token = Global.shared.globalLogin?.token,
            let uuid = Global.shared.globalProfile?.uuid else {
                SGLog(message: "数据为空")
                return
        }
        
        var URLString:String = self.Base_URL + API_URI.delete_gallery.rawValue
        URLString = URLString.replacingOccurrences(of: "{uuid}", with: photoUuid)
        URLString = URLString.replacingOccurrences(of: "{userUuid}", with: uuid)
        URLString = URLString.replacingOccurrences(of: "{token}", with: token)
        
        let request = HTTPRequestGenerator(withParam:["":""]
            , method: .delete, URLString: URLString)
        
        alamofireManager.request(request).responseObject { (response:DataResponse<Response>) in
            if self.verificationResponse(value: response.result.value){
                completeHandler(response.result.value)
            }else{
                completeHandler(response.result.value)
            }
        }
    }
    ///displayOrder: newest：hottest
    
    //24.探索图片空间，分页获取"最新Tab"或者"最热Tab"图片列表
    func getOrderGallery(likeSenderUserUuid: String?,displayType: DisplayType,pageNum: String,pageSize: String,completeHandler :@escaping(_ response:DisplayOrder?) -> Void)  -> Void {

        guard let likeSenderUserUuid = likeSenderUserUuid,
        let token = Global.shared.globalLogin?.token else {
            SGLog(message: "数据为空")
            return
        }
        
        var URLString:String = Base_URL + API_URI.get_orderGallery.rawValue
        URLString = URLString.replacingOccurrences(of: "{likeSenderUserUuid}", with: likeSenderUserUuid)
        URLString = URLString.replacingOccurrences(of: "{token}", with: token)
        URLString = URLString.replacingOccurrences(of: "{displayOrder}", with: displayType.rawValue)
        
        alamofireManager.request(URLString, parameters:["pageNum":pageNum,"pageSize":pageSize]).responseObject { (response:DataResponse<DisplayOrder>) in
            if self.verificationResponse(value: response.result.value){
                completeHandler(response.result.value)
            }else{
                completeHandler(response.result.value)
            }
        }
    }
    
    //25.陌生人查看探索图片时点赞POST
    func postLikeGalleryList(likeSenderUserUuid: String?,galleryUuid: String?,completeHandler :@escaping(_ response:Response?) -> Void)  -> Void {
        guard let token = Global.shared.globalLogin?.token,
            let likeSenderUserUuid = likeSenderUserUuid,
            let galleryUuid = galleryUuid else {
                SGLog(message: "数据为空")
                return
        }
        
        var URLString:String = Base_URL + API_URI.gallery_likeGallery.rawValue
        URLString = URLString.replacingOccurrences(of: "{token}", with: token)
        URLString = URLString.replacingOccurrences(of: "{galleryUuid}", with: galleryUuid)
        
        let request = HTTPRequestGenerator(withParam:["likeSenderUserUuid":likeSenderUserUuid], URLString: URLString)
        
        alamofireManager.request(request).responseObject { (response:DataResponse<Response>) in
            if self.verificationResponse(value: response.result.value){
                completeHandler(response.result.value)
            }else{
                completeHandler(response.result.value)
            }
        }
    }
    //26.用户查看自己的探索图片左下方的3个点赞头像列表，查看点赞发出者头像名称列表（传分页参数分页）
    func getLikeGalleryList(likeSenderUserUuid: String?,galleryUuid: String?,pageNum: String,pageSize: String,completeHandler :@escaping(_ response:LikeProfileResult?) -> Void)  -> Void {
        
        guard let token = Global.shared.globalLogin?.token,
            let galleryUuid = galleryUuid else {
                SGLog(message: "数据为空")
                return
        }
        
        var URLString:String = Base_URL + API_URI.gallery_likeGallery.rawValue
        URLString = URLString.replacingOccurrences(of: "{token}", with: token)
        URLString = URLString.replacingOccurrences(of: "{galleryUuid}", with: galleryUuid)
        
        alamofireManager.request(URLString, parameters:["pageNum":pageNum,"pageSize":pageSize]).responseObject { (response:DataResponse<LikeProfileResult>) in
            if self.verificationResponse(value: response.result.value){
                completeHandler(response.result.value)
            }else{
                completeHandler(response.result.value)
            }
        }
    }
    
    //27.第一步发图传图成功后，广告竞价第二步，显示竞价加码页面
    func getAdsBidOrder(bidGalleryUuid: String?,completeHandler :@escaping(_ response:AdsBidOrder?) -> Void)  -> Void {
        guard let token = Global.shared.globalLogin?.token,
            let userUuid = Global.shared.globalProfile?.userUuid,
            let bidGalleryUuid = bidGalleryUuid else {
                SGLog(message: "数据为空")
                return
        }
        
        
        var URLString:String = Base_URL + API_URI.get_adsBidOrder.rawValue
        URLString = URLString.replacingOccurrences(of: "{token}", with: token)
        URLString = URLString.replacingOccurrences(of: "{userUuid}", with: userUuid)
        URLString = URLString.replacingOccurrences(of: "{bidGalleryUuid}", with: bidGalleryUuid)
        
        alamofireManager.request(URLString).responseObject { (response:DataResponse<AdsBidOrder>) in
            if self.verificationResponse(value: response.result.value){
                completeHandler(response.result.value)
            }else{
                completeHandler(response.result.value)
            }
        }
    }
    //28.在显示竞价加码页面完成加码选择后，付款确认点击“发送”按钮
    func postAdsBidOrder(bidGalleryUuid: String?,amount: Int, completeHandler :@escaping(_ response:BidAdResponse?) -> Void)  -> Void {
        guard let token = Global.shared.globalLogin?.token,
        let userUuid = Global.shared.globalProfile?.userUuid,
        let bidGalleryUuid = bidGalleryUuid else {
            SGLog(message: "数据为空")
            return
        }
        
        var URLString:String = Base_URL + API_URI.post_adsBidOrder.rawValue
        URLString = URLString.replacingOccurrences(of: "{token}", with: token)
        URLString = URLString.replacingOccurrences(of: "{userUuid}", with: userUuid)
        
        let request = HTTPRequestGenerator(withParam:[
            "userUuid":userUuid,
            "bidGalleryUuid":bidGalleryUuid,
            "amount":String(amount),
            "participateBidAds":"true"], URLString: URLString)
        
        alamofireManager.request(request).responseObject { (response:DataResponse<BidAdResponse>) in
            if self.verificationResponse(value: response.result.value){
                completeHandler(response.result.value)
            }else{
                completeHandler(response.result.value)
            }
        }
    }
    //MARK:- B3.聊天模块
    //29.获取聊天SDK需要的TOKEN
    func getChatToken(completeHandler :@escaping(_ response:ChatToken?) -> Void)  -> Void {
        guard let token = Global.shared.globalLogin?.token,
            let userUuid = Global.shared.globalProfile?.userUuid else {
                SGLog(message: "数据为空")
                return
        }
        
        var URLString:String = Base_URL + API_URI.get_chatToken.rawValue
        URLString = URLString.replacingOccurrences(of: "{token}", with: token)
        URLString = URLString.replacingOccurrences(of: "{userUuid}", with: userUuid)
        
        alamofireManager.request(URLString).responseObject { (response:DataResponse<ChatToken>) in
            if self.verificationResponse(value: response.result.value){
                completeHandler(response.result.value)
            }else{
                completeHandler(response.result.value)
            }
        }
    }
    
    //30.获取某用户UUID的所有会话列表，待定是否需要加分页参数做分页
    func getChatList(completeHandler :@escaping(_ response:ChatList?) -> Void)  -> Void {
        guard let token = Global.shared.globalLogin?.token,
            let userUuid = Global.shared.globalProfile?.userUuid else {
                SGLog(message: "数据为空")
                return
        }
        
        var URLString:String = Base_URL + API_URI.get_chatList.rawValue
        URLString = URLString.replacingOccurrences(of: "{token}", with: token)
        URLString = URLString.replacingOccurrences(of: "{userUuid}", with: userUuid)
        
        alamofireManager.request(URLString).responseObject { (response:DataResponse<ChatList>) in
            if self.verificationResponse(value: response.result.value){
                completeHandler(response.result.value)
            }else{
                completeHandler(response.result.value)
            }
        }
    }
    
    //31.获取指定官方群组 的所有官方群成员资料，需分页参数
    func getOfficialGroupMember(officialGroupUuid: String,pageNum: String,pageSize: String, completeHandler :@escaping(_ response:OfficialGroup?) -> Void)  -> Void {
        guard let token = Global.shared.globalLogin?.token else {
                SGLog(message: "数据为空")
                return
        }
        
        var URLString:String = Base_URL + API_URI.get_officialGroupMember.rawValue
        URLString = URLString.replacingOccurrences(of: "{token}", with: token)
        URLString = URLString.replacingOccurrences(of: "{officialGroupUuid}", with: officialGroupUuid)
        
        alamofireManager.request(URLString, parameters:["pageNum":pageNum,"pageSize":pageSize]).responseObject { (response:DataResponse<OfficialGroup>) in
            if self.verificationResponse(value: response.result.value){
                completeHandler(response.result.value)
            }else{
                completeHandler(response.result.value)
            }
        }
    }
    
    //32.创建用户群组
    func postCreateGroup(memberUserUuidList: [String]?,groupDisplayName: String?, completeHandler :@escaping(_ response:GroupInfo?) -> Void)  -> Void {
        
        guard let token = Global.shared.globalLogin?.token,
        let adminUserUuid = Global.shared.globalProfile?.userUuid,
            let groupDisplayName = groupDisplayName,
            let memberUserUuidList = memberUserUuidList else {
                SGLog(message: "数据为空")
                return
        }
        
        var URLString:String = Base_URL + API_URI.post_createGroup.rawValue
        URLString = URLString.replacingOccurrences(of: "{token}", with: token)
        
        let request = HTTPRequestGenerator(withParam:[
            "memberUserUuidList": memberUserUuidList,
            "groupDisplayName": groupDisplayName,
            "adminUserUuid": adminUserUuid], URLString: URLString)
        
        alamofireManager.request(request).responseObject { (response:DataResponse<GroupInfo>) in
            if self.verificationResponse(value: response.result.value){
                completeHandler(response.result.value)
            }else{
                completeHandler(response.result.value)
            }
        }
    }
    //33.修改用户群组的显示名称
    func putUserGroup(groupDisplayName: String?,userGroupUuid: String?,adminUserUuid: String?, completeHandler :@escaping(_ response:Response?) -> Void)  -> Void {
        
        guard let token = Global.shared.globalLogin?.token,
            let adminUserUuid = Global.shared.globalProfile?.uuid,
            let groupDisplayName = groupDisplayName,
            let userGroupUuid = userGroupUuid else {
                SGLog(message: "数据为空")
                return
        }
        
        var URLString:String = Base_URL + API_URI.handle_UserGroup.rawValue
        URLString = URLString.replacingOccurrences(of: "{token}", with: token)
        URLString = URLString.replacingOccurrences(of: "{userGroupUuid}", with: userGroupUuid)

        let request = HTTPRequestGenerator(withParam:[
            "groupDisplayName": groupDisplayName,
            "adminUserUuid": adminUserUuid,
            "userGroupUuid": userGroupUuid], method: .put, URLString: URLString)
        
        alamofireManager.request(request).responseObject { (response:DataResponse<Response>) in
            if self.verificationResponse(value: response.result.value){
                completeHandler(response.result.value)
            }else{
                completeHandler(response.result.value)
            }
        }
    }
    //34.（这次可能用不到）获取用户群组信息
    func getUserGroup(userGroupUuid: String?, completeHandler :@escaping(_ response:GroupInfo?) -> Void)  -> Void {
        guard let token = Global.shared.globalLogin?.token,
              let userGroupUuid = userGroupUuid else {
            SGLog(message: "数据为空")
            return
        }
        
        var URLString:String = Base_URL + API_URI.handle_UserGroup.rawValue
        URLString = URLString.replacingOccurrences(of: "{token}", with: token)
        URLString = URLString.replacingOccurrences(of: "{userGroupUuid}", with: userGroupUuid)
        
        alamofireManager.request(URLString).responseObject { (response:DataResponse<GroupInfo>) in
            if self.verificationResponse(value: response.result.value){
                completeHandler(response.result.value)
            }else{
                completeHandler(response.result.value)
            }
        }
    }
    //35.删除指定的创建用户群组
    func deleteUserGroup(userGroupUuid: String?, completeHandler :@escaping(_ response:Response?) -> Void)  -> Void {
        guard let token = Global.shared.globalLogin?.token,
            let userGroupUuid = userGroupUuid else {
                SGLog(message: "数据为空")
                return
        }
        
        var URLString:String = Base_URL + API_URI.handle_UserGroup.rawValue
        URLString = URLString.replacingOccurrences(of: "{token}", with: token)
        URLString = URLString.replacingOccurrences(of: "{userGroupUuid}", with: userGroupUuid)
        
        let request = HTTPRequestGenerator(withParam:["" : ""], method: .delete, URLString: URLString)
        
        alamofireManager.request(request).responseObject { (response:DataResponse<Response>) in
            if self.verificationResponse(value: response.result.value){
                completeHandler(response.result.value)
            }else{
                completeHandler(response.result.value)
            }
        }
    }
    //36.新加成员到指定群组
    func postUserGroupMember(userGroupUuid: String?,userUuid: String?,userDisplayName: String?, completeHandler :@escaping(_ response:Response?) -> Void)  -> Void {
        guard let token = Global.shared.globalLogin?.token,
            let userUuid = userUuid,
            let userGroupUuid = userGroupUuid ,
            let userDisplayName = userDisplayName  else {
                SGLog(message: "数据为空")
                return
        }
        
        var URLString:String = Base_URL + API_URI.handle_userGroupMember.rawValue
        URLString = URLString.replacingOccurrences(of: "{token}", with: token)
        URLString = URLString.replacingOccurrences(of: "{userGroupUuid}", with: userGroupUuid)
        
        let request = HTTPRequestGenerator(withParam:[
            "userUuid" : userUuid,
            "userGroupUuid" : userGroupUuid,
            "userDisplayName" : userDisplayName], URLString: URLString)
        
        alamofireManager.request(request).responseObject { (response:DataResponse<Response>) in
            if self.verificationResponse(value: response.result.value){
                completeHandler(response.result.value)
            }else{
                completeHandler(response.result.value)
            }
        }
    }
    //37.修改指定群组的某个指定群成员的显示名称
    func putUserGroupMember(userGroupUuid: String?,userGroupMemberUuid: String?,userDisplayName: String?, completeHandler :@escaping(_ response:Response?) -> Void)  -> Void {
        guard let token = Global.shared.globalLogin?.token,
            let userGroupUuid = userGroupUuid,
            let userDisplayName = userDisplayName,
            let userGroupMemberUuid = userGroupMemberUuid else {
                SGLog(message: "数据为空")
                return
        }
        
        var URLString:String = Base_URL + API_URI.modify_userGroupMember.rawValue
        URLString = URLString.replacingOccurrences(of: "{token}", with: token)
        URLString = URLString.replacingOccurrences(of: "{userGroupUuid}", with: userGroupUuid)
        URLString = URLString.replacingOccurrences(of: "{userGroupMemberUuid}", with: userGroupMemberUuid)
        
        let request = HTTPRequestGenerator(withParam:
            ["userDisplayName" : userDisplayName]
            , method: .put, URLString: URLString)
        
        alamofireManager.request(request).responseObject { (response:DataResponse<Response>) in
            if self.verificationResponse(value: response.result.value){
                completeHandler(response.result.value)
            }else{
                completeHandler(response.result.value)
            }
        }
    }
    //38.获取指定群组的所有群成员资料，需分页参数
    func getGroupMemberUserList(userGroupUuid: String?,pageNum: String,pageSize: String, completeHandler :@escaping(_ response:GroupMember?) -> Void)  -> Void {
        guard let token = Global.shared.globalLogin?.token,
            let userGroupUuid = userGroupUuid else {
                SGLog(message: "数据为空")
                return
        }
        
        var URLString:String = Base_URL + API_URI.handle_userGroupMember.rawValue
        URLString = URLString.replacingOccurrences(of: "{token}", with: token)
        URLString = URLString.replacingOccurrences(of: "{userGroupUuid}", with: userGroupUuid)
        
        alamofireManager.request(URLString, parameters:["pageNum":pageNum,"pageSize":pageSize]).responseObject { (response:DataResponse<GroupMember>) in
            if self.verificationResponse(value: response.result.value){
                completeHandler(response.result.value)
            }else{
                completeHandler(response.result.value)
            }
        }
    }
    //39.自己退出群，或者管理员删除指定群组的某个指定群成员
    func deleteUserGroupMember(userGroupUuid: String?,userGroupMemberUuid: String?, completeHandler :@escaping(_ response:Response?) -> Void)  -> Void {
        guard let token = Global.shared.globalLogin?.token,
            let userGroupUuid = userGroupUuid,
            let userGroupMemberUuid = userGroupMemberUuid else {
                SGLog(message: "数据为空")
                return
        }
        
        var URLString:String = Base_URL + API_URI.modify_userGroupMember.rawValue
        URLString = URLString.replacingOccurrences(of: "{token}", with: token)
        URLString = URLString.replacingOccurrences(of: "{userGroupUuid}", with: userGroupUuid)
        URLString = URLString.replacingOccurrences(of: "{userGroupMemberUuid}", with: userGroupMemberUuid)

        let request = HTTPRequestGenerator(withParam:["" : ""], method: .delete, URLString: URLString)
        
        alamofireManager.request(request).responseObject { (response:DataResponse<Response>) in
            if self.verificationResponse(value: response.result.value){
                completeHandler(response.result.value)
            }else{
                completeHandler(response.result.value)
            }
        }
    }
    //40.创建一对一私聊会话
    func postPrivateChat(name: String?,userUuidA: String?,userUuidB: String?, completeHandler :@escaping(_ response:PrivateChat?) -> Void)  -> Void {
        guard let token = Global.shared.globalLogin?.token,
            let name = name,
            let userUuidA = userUuidA ,
            let userUuidB = userUuidB  else {
                SGLog(message: "数据为空")
                return
        }
        
        var URLString:String = Base_URL + API_URI.post_privateChat.rawValue
        URLString = URLString.replacingOccurrences(of: "{token}", with: token)
        
        let request = HTTPRequestGenerator(withParam:[
            "name" : name,
            "userUuidA" : userUuidA,
            "userUuidB" : userUuidB], URLString: URLString)
        
        alamofireManager.request(request).responseObject { (response:DataResponse<PrivateChat>) in
            if self.verificationResponse(value: response.result.value){
                completeHandler(response.result.value)
            }else{
                completeHandler(response.result.value)
            }
        }
    }
    //41.删除指定一对一私聊会话
    func deletePrivateChat(uuid: String?, completeHandler :@escaping(_ response:Response?) -> Void)  -> Void {
        guard let token = Global.shared.globalLogin?.token,
            let uuid = uuid else {
                SGLog(message: "数据为空")
                return
        }
        
        var URLString:String = Base_URL + API_URI.delete_privateChat.rawValue
        URLString = URLString.replacingOccurrences(of: "{token}", with: token)
        URLString = URLString.replacingOccurrences(of: "{uuid}", with: uuid)
        
        let request = HTTPRequestGenerator(withParam:["" : ""], method: .delete, URLString: URLString)
        
        alamofireManager.request(request).responseObject { (response:DataResponse<Response>) in
            if self.verificationResponse(value: response.result.value){
                completeHandler(response.result.value)
            }else{
                completeHandler(response.result.value)
            }
        }
    }
    
    //42.修改指定官方群组的某个指定官方群成员的显示名称，目前只允许自己修改自己
    func putOfficialGroupMemberName(userDisplayName: String?,officialGroupUuid: String?,officialGroupMemberUuid: String?, completeHandler :@escaping(_ response:Response?) -> Void)  -> Void {
        
        guard let token = Global.shared.globalLogin?.token,
            let userDisplayName = userDisplayName,
            let officialGroupUuid = officialGroupUuid,
            let officialGroupMemberUuid = officialGroupMemberUuid else {
                SGLog(message: "数据为空")
                return
        }
        var URLString:String = Base_URL + API_URI.put_officialGroupMemberName.rawValue
        URLString = URLString.replacingOccurrences(of: "{token}", with: token)
        URLString = URLString.replacingOccurrences(of: "{officialGroupUuid}", with: officialGroupUuid)
        URLString = URLString.replacingOccurrences(of: "{officialGroupMemberUuid}", with: officialGroupMemberUuid)

        let request = HTTPRequestGenerator(withParam:[
            "userDisplayName": userDisplayName], method: .put, URLString: URLString)
        
        alamofireManager.request(request).responseObject { (response:DataResponse<Response>) in
            if self.verificationResponse(value: response.result.value){
                completeHandler(response.result.value)
            }else{
                completeHandler(response.result.value)
            }
        }
    }
}
