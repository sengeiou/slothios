//
//	ItunesChargeData.swift
//
//	Create by Fly on 26/11/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class ItunesChargeData : NSObject, NSCoding, Mappable{

	var itunesChargeAmount : Int?
	var itunesChargeProductUuid : String?


	class func newInstance(map: Map) -> Mappable?{
		return ItunesChargeData()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		itunesChargeAmount <- map["itunesChargeAmount"]
		itunesChargeProductUuid <- map["itunesChargeProductUuid"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         itunesChargeAmount = aDecoder.decodeObject(forKey: "itunesChargeAmount") as? Int
         itunesChargeProductUuid = aDecoder.decodeObject(forKey: "itunesChargeProductUuid") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if itunesChargeAmount != nil{
			aCoder.encode(itunesChargeAmount, forKey: "itunesChargeAmount")
		}
		if itunesChargeProductUuid != nil{
			aCoder.encode(itunesChargeProductUuid, forKey: "itunesChargeProductUuid")
		}

	}

}