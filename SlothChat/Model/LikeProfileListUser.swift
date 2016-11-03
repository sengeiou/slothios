//
//	List.swift
//
//	Create by Fly on 31/10/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class LikeProfileListUser : NSObject, NSCoding, Mappable{

	var likeSenderNickname : String?
	var likeSenderProfilePicUrl : String?
	var likeSenderProfileUuid : String?
	var likeSenderUserUuid : String?
	var orderNum : Int?
	var profileUuid : String?
	var userUuid : String?
	var uuid : String?


	class func newInstance(map: Map) -> Mappable?{
		return LikeProfileListUser()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		likeSenderNickname <- map["likeSenderNickname"]
		likeSenderProfilePicUrl <- map["likeSenderProfilePicUrl"]
		likeSenderProfileUuid <- map["likeSenderProfileUuid"]
		likeSenderUserUuid <- map["likeSenderUserUuid"]
		orderNum <- map["orderNum"]
		profileUuid <- map["profileUuid"]
		userUuid <- map["userUuid"]
		uuid <- map["uuid"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         likeSenderNickname = aDecoder.decodeObject(forKey: "likeSenderNickname") as? String
         likeSenderProfilePicUrl = aDecoder.decodeObject(forKey: "likeSenderProfilePicUrl") as? String
         likeSenderProfileUuid = aDecoder.decodeObject(forKey: "likeSenderProfileUuid") as? String
         likeSenderUserUuid = aDecoder.decodeObject(forKey: "likeSenderUserUuid") as? String
         orderNum = aDecoder.decodeObject(forKey: "orderNum") as? Int
         profileUuid = aDecoder.decodeObject(forKey: "profileUuid") as? String
         userUuid = aDecoder.decodeObject(forKey: "userUuid") as? String
         uuid = aDecoder.decodeObject(forKey: "uuid") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if likeSenderNickname != nil{
			aCoder.encode(likeSenderNickname, forKey: "likeSenderNickname")
		}
		if likeSenderProfilePicUrl != nil{
			aCoder.encode(likeSenderProfilePicUrl, forKey: "likeSenderProfilePicUrl")
		}
		if likeSenderProfileUuid != nil{
			aCoder.encode(likeSenderProfileUuid, forKey: "likeSenderProfileUuid")
		}
		if likeSenderUserUuid != nil{
			aCoder.encode(likeSenderUserUuid, forKey: "likeSenderUserUuid")
		}
		if orderNum != nil{
			aCoder.encode(orderNum, forKey: "orderNum")
		}
		if profileUuid != nil{
			aCoder.encode(profileUuid, forKey: "profileUuid")
		}
		if userUuid != nil{
			aCoder.encode(userUuid, forKey: "userUuid")
		}
		if uuid != nil{
			aCoder.encode(uuid, forKey: "uuid")
		}

	}

}
