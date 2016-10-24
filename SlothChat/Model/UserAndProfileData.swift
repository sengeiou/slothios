//
//	Data.swift
//
//	Create by 一丁 王 on 25/10/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class UserAndProfileData : NSObject, NSCoding, Mappable{

	var age : Int?
	var birthdate : Int?
	var canTalk : Bool?
	var constellation : String?
	var nickname : String?
	var sex : String?
	var userRole : String?
	var userUuid : String?
	var uuid : String?


	class func newInstance(map: Map) -> Mappable?{
		return UserAndProfileData()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		age <- map["age"]
		birthdate <- map["birthdate"]
		canTalk <- map["canTalk"]
		constellation <- map["constellation"]
		nickname <- map["nickname"]
		sex <- map["sex"]
		userRole <- map["userRole"]
		userUuid <- map["userUuid"]
		uuid <- map["uuid"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         age = aDecoder.decodeObject(forKey: "age") as? Int
         birthdate = aDecoder.decodeObject(forKey: "birthdate") as? Int
         canTalk = aDecoder.decodeObject(forKey: "canTalk") as? Bool
         constellation = aDecoder.decodeObject(forKey: "constellation") as? String
         nickname = aDecoder.decodeObject(forKey: "nickname") as? String
         sex = aDecoder.decodeObject(forKey: "sex") as? String
         userRole = aDecoder.decodeObject(forKey: "userRole") as? String
         userUuid = aDecoder.decodeObject(forKey: "userUuid") as? String
         uuid = aDecoder.decodeObject(forKey: "uuid") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if age != nil{
			aCoder.encode(age, forKey: "age")
		}
		if birthdate != nil{
			aCoder.encode(birthdate, forKey: "birthdate")
		}
		if canTalk != nil{
			aCoder.encode(canTalk, forKey: "canTalk")
		}
		if constellation != nil{
			aCoder.encode(constellation, forKey: "constellation")
		}
		if nickname != nil{
			aCoder.encode(nickname, forKey: "nickname")
		}
		if sex != nil{
			aCoder.encode(sex, forKey: "sex")
		}
		if userRole != nil{
			aCoder.encode(userRole, forKey: "userRole")
		}
		if userUuid != nil{
			aCoder.encode(userUuid, forKey: "userUuid")
		}
		if uuid != nil{
			aCoder.encode(uuid, forKey: "uuid")
		}

	}

}
