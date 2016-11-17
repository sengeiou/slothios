//
//	LoginModel.swift
//
//	Create by 一丁 王 on 25/10/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class LoginModel : NSObject, NSCoding, Mappable{

    var canTalk : Bool?
	var token : String?
	var user : LoginUser?
    
    var msg : String?
    var status : String?

    open func caheForLoginModel() {
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.setValue(data, forKey: "LoginModelCacheKey")
        UserDefaults.standard.synchronize()
    }
    
    open class func removeFromCache(){
        UserDefaults.standard.removeObject(forKey: "LoginModelCacheKey")
        UserDefaults.standard.synchronize()
    }
    
    open class func ModelFromCache() -> LoginModel? {
        let data = UserDefaults.standard.value(forKey: "LoginModelCacheKey")
        if data != nil {
            let user = NSKeyedUnarchiver.unarchiveObject(with: data as! Data)  as! LoginModel?
            return user
        }
        return nil
    }
    
	class func newInstance(map: Map) -> Mappable?{
		return LoginModel()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
        canTalk <- map["canTalk"]
		token <- map["token"]
		user <- map["user"]
        status <- map["status"]
        msg <- map["msg"]
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         canTalk = aDecoder.decodeObject(forKey: "canTalk") as? Bool
         token = aDecoder.decodeObject(forKey: "token") as? String
         user = aDecoder.decodeObject(forKey: "user") as? LoginUser

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
        if canTalk != nil{
            aCoder.encode(canTalk, forKey: "canTalk")
        }
		if token != nil{
			aCoder.encode(token, forKey: "token")
		}
		if user != nil{
			aCoder.encode(user, forKey: "user")
		}

	}

}
