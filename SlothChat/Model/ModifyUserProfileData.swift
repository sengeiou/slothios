//
//	Data.swift
//
//	Create by Fly on 25/10/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class ModifyUserProfileData : NSObject, NSCoding, Mappable{

	var age : Int?
	var area : String?
	var commonCities : String?
	var constellation : String?
	var likesCount : Int?
	var nickname : String?
	var sex : String?
	var university : String?
	var userLevel : String?
	var userUuid : String?
	var uuid : String?


	class func newInstance(map: Map) -> Mappable?{
		return ModifyUserProfileData()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		age <- map["age"]
		area <- map["area"]
		commonCities <- map["commonCities"]
		constellation <- map["constellation"]
		likesCount <- map["likesCount"]
		nickname <- map["nickname"]
		sex <- map["sex"]
		university <- map["university"]
		userLevel <- map["userLevel"]
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
         area = aDecoder.decodeObject(forKey: "area") as? String
         commonCities = aDecoder.decodeObject(forKey: "commonCities") as? String
         constellation = aDecoder.decodeObject(forKey: "constellation") as? String
         likesCount = aDecoder.decodeObject(forKey: "likesCount") as? Int
         nickname = aDecoder.decodeObject(forKey: "nickname") as? String
         sex = aDecoder.decodeObject(forKey: "sex") as? String
         university = aDecoder.decodeObject(forKey: "university") as? String
         userLevel = aDecoder.decodeObject(forKey: "userLevel") as? String
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
		if area != nil{
			aCoder.encode(area, forKey: "area")
		}
		if commonCities != nil{
			aCoder.encode(commonCities, forKey: "commonCities")
		}
		if constellation != nil{
			aCoder.encode(constellation, forKey: "constellation")
		}
		if likesCount != nil{
			aCoder.encode(likesCount, forKey: "likesCount")
		}
		if nickname != nil{
			aCoder.encode(nickname, forKey: "nickname")
		}
		if sex != nil{
			aCoder.encode(sex, forKey: "sex")
		}
		if university != nil{
			aCoder.encode(university, forKey: "university")
		}
		if userLevel != nil{
			aCoder.encode(userLevel, forKey: "userLevel")
		}
		if userUuid != nil{
			aCoder.encode(userUuid, forKey: "userUuid")
		}
		if uuid != nil{
			aCoder.encode(uuid, forKey: "uuid")
		}

	}

}
