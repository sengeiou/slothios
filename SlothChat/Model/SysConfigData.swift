//
//	Data.swift
//
//	Create by Fly on 25/10/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class SysConfigData : NSObject, NSCoding, Mappable{

	var acceptPrivateChat : Bool?
	var acceptSysNotify : Bool?
	var banlace : Int?

    open func cacheForSysConfig() {
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.setValue(data, forKey: "SysConfigDataCacheKey")
        UserDefaults.standard.synchronize()
    }
    
    open class func ConfigFromCache() -> SysConfigData? {
        let data = UserDefaults.standard.value(forKey: "SysConfigDataCacheKey")
        if data != nil {
            let config = NSKeyedUnarchiver.unarchiveObject(with: data as! Data)  as! SysConfigData?
            return config
        }
        return nil
    }

	class func newInstance(map: Map) -> Mappable?{
		return SysConfigData()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		acceptPrivateChat <- map["acceptPrivateChat"]
		acceptSysNotify <- map["acceptSysNotify"]
		banlace <- map["banlace"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         acceptPrivateChat = aDecoder.decodeObject(forKey: "acceptPrivateChat") as? Bool
         acceptSysNotify = aDecoder.decodeObject(forKey: "acceptSysNotify") as? Bool
         banlace = aDecoder.decodeObject(forKey: "banlace") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if acceptPrivateChat != nil{
			aCoder.encode(acceptPrivateChat, forKey: "acceptPrivateChat")
		}
		if acceptSysNotify != nil{
			aCoder.encode(acceptSysNotify, forKey: "acceptSysNotify")
		}
		if banlace != nil{
			aCoder.encode(banlace, forKey: "banlace")
		}

	}

}
