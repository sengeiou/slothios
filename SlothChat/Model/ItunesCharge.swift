//
//	ItunesCharge.swift
//
//	Create by Fly on 26/11/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class ItunesCharge : NSObject, NSCoding, Mappable{

	var data : [ItunesChargeData]?
	var msg : String?
	var status : String?
    
    open func caheForModel() {
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.setValue(data, forKey: "ItunesChargeCacheKey")
        UserDefaults.standard.synchronize()
    }
    
    open class func removeFromCache(){
        UserDefaults.standard.removeObject(forKey: "ItunesChargeCacheKey")
        UserDefaults.standard.synchronize()
    }
    
    open class func ModelFromCache() -> ItunesCharge? {
        let data = UserDefaults.standard.value(forKey: "ItunesChargeCacheKey")
        if data != nil {
            let user = NSKeyedUnarchiver.unarchiveObject(with: data as! Data)  as! ItunesCharge?
            return user
        }
        return nil
    }
    
    func getItunesChargeAmountList() -> [String] {
        guard let list = self.data else {
            return [""]
        }
        if list.count <= 0 {
            return [""]
        }
        var amountList = [String]()
        for data in list {
            if let amount = data.itunesChargeAmount {
                amountList.append(String(amount))
            }
        }
        return amountList
    }
    
    func getItunesChargeProductUuid(index: Int) -> String? {
        guard let list = self.data else {
            return nil
        }
        if list.count <= 0 {
            return nil
        }
        var uuidList = [String]()
        for data in list {
            if let productUuid = data.itunesChargeProductUuid {
                uuidList.append(String(productUuid))
            }
        }
        
        if uuidList.count > index {
            return uuidList[index]
        }
        
        return nil
    }

	class func newInstance(map: Map) -> Mappable?{
		return ItunesCharge()
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
         data = aDecoder.decodeObject(forKey: "data") as? [ItunesChargeData]
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
