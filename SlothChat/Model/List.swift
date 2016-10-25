//
//	List.swift
//
//	Create by 一丁 王 on 25/10/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class List : NSObject, NSCoding, Mappable{

	var display : String?
	var name : String?
	var telPrefix : String?


	class func newInstance(map: Map) -> Mappable?{
		return List()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		display <- map["display"]
		name <- map["name"]
		telPrefix <- map["telPrefix"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         display = aDecoder.decodeObject(forKey: "display") as? String
         name = aDecoder.decodeObject(forKey: "name") as? String
         telPrefix = aDecoder.decodeObject(forKey: "telPrefix") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if display != nil{
			aCoder.encode(display, forKey: "display")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if telPrefix != nil{
			aCoder.encode(telPrefix, forKey: "telPrefix")
		}

	}

}