//
//	BidAdResponse.swift
//
//	Create by Fly on 10/11/2016
//	Copyright © 2016 guahao. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class BidAdResponse : NSObject, NSCoding, Mappable{

	var data : BidAdResponseData?
	var msg : String?
	var status : String?


	class func newInstance(map: Map) -> Mappable?{
		return BidAdResponse()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		data <- map["data"]
		msg <- map["msg"]
		status <- map["status"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         data = aDecoder.decodeObject(forKey: "data") as? BidAdResponseData
         msg = aDecoder.decodeObject(forKey: "msg") as? String
         status = aDecoder.decodeObject(forKey: "status") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if data != nil{
			aCoder.encode(data, forKey: "data")
		}
		if msg != nil{
			aCoder.encode(msg, forKey: "msg")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}

	}

}