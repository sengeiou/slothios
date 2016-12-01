//
//	Country.swift
//
//	Create by 一丁 王 on 25/10/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class Country : NSObject, NSCoding, Mappable{

	var data : SCData?
	var msg : String?
	var status : String?

    open func caheForCountryCode() {
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.setValue(data, forKey: "CountryCodeCacheKey")
        UserDefaults.standard.synchronize()
    }
    
    open class func removeFromCache(){
        UserDefaults.standard.removeObject(forKey: "CountryCodeCacheKey")
        UserDefaults.standard.synchronize()
    }
    
    open class func ModelFromCache() -> Country? {
        let data = UserDefaults.standard.value(forKey: "CountryCodeCacheKey")
        if data != nil {
            let user = NSKeyedUnarchiver.unarchiveObject(with: data as! Data)  as! Country?
            return user
        }
        return nil
    }
    
	class func newInstance(map: Map) -> Mappable?{
		return Country()
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
         data = aDecoder.decodeObject(forKey: "data") as? SCData
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
