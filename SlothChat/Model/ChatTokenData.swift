//
//	Data.swift
//
//	Create by Fly on 13/11/2016
//	Copyright © 2016 guahao. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class ChatTokenData : NSObject, NSCoding, Mappable{

	var chatToken : String?

    open class func cacheForChatToken(token: String) {
        let data = NSKeyedArchiver.archivedData(withRootObject: token)
        UserDefaults.standard.setValue(data, forKey: "ChatTokenCacheKey")
        UserDefaults.standard.synchronize()
    }
    
    open class func removeFromCache(){
        UserDefaults.standard.removeObject(forKey: "ChatTokenCacheKey")
        UserDefaults.standard.synchronize()
    }
    
    open class func TokenFromCache() -> String? {
        let data = UserDefaults.standard.value(forKey: "ChatTokenCacheKey")
        if data != nil {
            let result = NSKeyedUnarchiver.unarchiveObject(with: data as! Data)  as! String?
            return result
        }
        return nil
    }
    

	class func newInstance(map: Map) -> Mappable?{
		return ChatTokenData()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		chatToken <- map["chatToken"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         chatToken = aDecoder.decodeObject(forKey: "chatToken") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if chatToken != nil{
			aCoder.encode(chatToken, forKey: "chatToken")
		}

	}

}
