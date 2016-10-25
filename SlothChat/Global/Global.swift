//
//  Global.swift
//  SlothChat
//
//  Created by Fly on 16/10/26.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class Global: BaseObject {
    var globalLogin: LoginModel?{
        didSet{
            if globalLogin != nil {
                globalLogin?.caheForLoginModel()
            }
        }
    }
    
    var globalProfile: UserProfileData?{
        didSet{
            if globalProfile != nil {
                globalProfile?.caheForUserProfile()
            }
        }
    }
    
    static var shared : Global {
        struct Static {
            static let instance : Global = Global()
        }
        return Static.instance
    }
    
    override init() {
        globalLogin = LoginModel.ModelFromCache()
        globalProfile = UserProfileData.ProfileFromCache()
    }
    
    func isLogin() -> Bool {
        if (globalLogin != nil) && !(globalLogin?.token?.isEmpty)! {
            return true
        }
        return false
    }
}
