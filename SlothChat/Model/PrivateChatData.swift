//
//	PrivateChatData.swift
//
//	Create by Fly on 18/11/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class PrivateChatData : NSObject, NSCoding, Mappable{

	var name : String?
	var userUuidA : String?
	var userUuidB : String?
	var uuid : String?


	class func newInstance(map: Map) -> Mappable?{
		return PrivateChatData()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		name <- map["name"]
		userUuidA <- map["userUuidA"]
		userUuidB <- map["userUuidB"]
		uuid <- map["uuid"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         name = aDecoder.decodeObject(forKey: "name") as? String
         userUuidA = aDecoder.decodeObject(forKey: "userUuidA") as? String
         userUuidB = aDecoder.decodeObject(forKey: "userUuidB") as? String
         uuid = aDecoder.decodeObject(forKey: "uuid") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if userUuidA != nil{
			aCoder.encode(userUuidA, forKey: "userUuidA")
		}
		if userUuidB != nil{
			aCoder.encode(userUuidB, forKey: "userUuidB")
		}
		if uuid != nil{
			aCoder.encode(uuid, forKey: "uuid")
		}

	}

}
