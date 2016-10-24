//
//	User.swift
//
//	Create by 一丁 王 on 25/10/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class LoginUser : NSObject, NSCoding, Mappable{

	var country : String?
	var email : String?
	var mobile : String?
	var username : String?
	var uuid : String?


	class func newInstance(map: Map) -> Mappable?{
		return LoginUser()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		country <- map["country"]
		email <- map["email"]
		mobile <- map["mobile"]
		username <- map["username"]
		uuid <- map["uuid"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         country = aDecoder.decodeObject(forKey: "country") as? String
         email = aDecoder.decodeObject(forKey: "email") as? String
         mobile = aDecoder.decodeObject(forKey: "mobile") as? String
         username = aDecoder.decodeObject(forKey: "username") as? String
         uuid = aDecoder.decodeObject(forKey: "uuid") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if country != nil{
			aCoder.encode(country, forKey: "country")
		}
		if email != nil{
			aCoder.encode(email, forKey: "email")
		}
		if mobile != nil{
			aCoder.encode(mobile, forKey: "mobile")
		}
		if username != nil{
			aCoder.encode(username, forKey: "username")
		}
		if uuid != nil{
			aCoder.encode(uuid, forKey: "uuid")
		}

	}

}
