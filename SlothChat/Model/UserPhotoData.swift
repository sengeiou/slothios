//
//	Data.swift
//
//	Create by 一丁 王 on 25/10/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class UserPhotoData : NSObject, NSCoding, Mappable{

	var isHumanVerified : Bool?
	var orderNum : Int?
	var profileBigPicUrl : String?
	var profilePicUrl : String?
	var userUuid : String?
	var uuid : String?


	class func newInstance(map: Map) -> Mappable?{
		return UserPhotoData()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		isHumanVerified <- map["isHumanVerified"]
		orderNum <- map["orderNum"]
		profileBigPicUrl <- map["profileBigPicUrl"]
		profilePicUrl <- map["profilePicUrl"]
		userUuid <- map["userUuid"]
		uuid <- map["uuid"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         isHumanVerified = aDecoder.decodeObject(forKey: "isHumanVerified") as? Bool
         orderNum = aDecoder.decodeObject(forKey: "orderNum") as? Int
         profileBigPicUrl = aDecoder.decodeObject(forKey: "profileBigPicUrl") as? String
         profilePicUrl = aDecoder.decodeObject(forKey: "profilePicUrl") as? String
         userUuid = aDecoder.decodeObject(forKey: "userUuid") as? String
         uuid = aDecoder.decodeObject(forKey: "uuid") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if isHumanVerified != nil{
			aCoder.encode(isHumanVerified, forKey: "isHumanVerified")
		}
		if orderNum != nil{
			aCoder.encode(orderNum, forKey: "orderNum")
		}
		if profileBigPicUrl != nil{
			aCoder.encode(profileBigPicUrl, forKey: "profileBigPicUrl")
		}
		if profilePicUrl != nil{
			aCoder.encode(profilePicUrl, forKey: "profilePicUrl")
		}
		if userUuid != nil{
			aCoder.encode(userUuid, forKey: "userUuid")
		}
		if uuid != nil{
			aCoder.encode(uuid, forKey: "uuid")
		}

	}

}
