//
//	Data.swift
//
//	Create by Fly on 31/10/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class LikeProfileData : NSObject, NSCoding, Mappable{

	var endRow : Int?
	var firstPage : Int?
	var hasNextPage : Bool?
	var hasPreviousPage : Bool?
	var isFirstPage : Bool?
	var isLastPage : Bool?
	var lastPage : Int?
	var list : [LikeProfileListUser]?
	var navigatePages : Int?
	var navigatepageNums : [Int]?
	var nextPage : Int?
	var orderBy : AnyObject?
	var pageNum : Int?
	var pageSize : Int?
	var pages : Int?
	var prePage : Int?
	var size : Int?
	var startRow : Int?
	var total : Int?


	class func newInstance(map: Map) -> Mappable?{
		return LikeProfileData()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		endRow <- map["endRow"]
		firstPage <- map["firstPage"]
		hasNextPage <- map["hasNextPage"]
		hasPreviousPage <- map["hasPreviousPage"]
		isFirstPage <- map["isFirstPage"]
		isLastPage <- map["isLastPage"]
		lastPage <- map["lastPage"]
		list <- map["list"]
		navigatePages <- map["navigatePages"]
		navigatepageNums <- map["navigatepageNums"]
		nextPage <- map["nextPage"]
		orderBy <- map["orderBy"]
		pageNum <- map["pageNum"]
		pageSize <- map["pageSize"]
		pages <- map["pages"]
		prePage <- map["prePage"]
		size <- map["size"]
		startRow <- map["startRow"]
		total <- map["total"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         endRow = aDecoder.decodeObject(forKey: "endRow") as? Int
         firstPage = aDecoder.decodeObject(forKey: "firstPage") as? Int
         hasNextPage = aDecoder.decodeObject(forKey: "hasNextPage") as? Bool
         hasPreviousPage = aDecoder.decodeObject(forKey: "hasPreviousPage") as? Bool
         isFirstPage = aDecoder.decodeObject(forKey: "isFirstPage") as? Bool
         isLastPage = aDecoder.decodeObject(forKey: "isLastPage") as? Bool
         lastPage = aDecoder.decodeObject(forKey: "lastPage") as? Int
         list = aDecoder.decodeObject(forKey: "list") as? [LikeProfileListUser]
         navigatePages = aDecoder.decodeObject(forKey: "navigatePages") as? Int
         navigatepageNums = aDecoder.decodeObject(forKey: "navigatepageNums") as? [Int]
         nextPage = aDecoder.decodeObject(forKey: "nextPage") as? Int
         orderBy = aDecoder.decodeObject(forKey: "orderBy") as? AnyObject
         pageNum = aDecoder.decodeObject(forKey: "pageNum") as? Int
         pageSize = aDecoder.decodeObject(forKey: "pageSize") as? Int
         pages = aDecoder.decodeObject(forKey: "pages") as? Int
         prePage = aDecoder.decodeObject(forKey: "prePage") as? Int
         size = aDecoder.decodeObject(forKey: "size") as? Int
         startRow = aDecoder.decodeObject(forKey: "startRow") as? Int
         total = aDecoder.decodeObject(forKey: "total") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if endRow != nil{
			aCoder.encode(endRow, forKey: "endRow")
		}
		if firstPage != nil{
			aCoder.encode(firstPage, forKey: "firstPage")
		}
		if hasNextPage != nil{
			aCoder.encode(hasNextPage, forKey: "hasNextPage")
		}
		if hasPreviousPage != nil{
			aCoder.encode(hasPreviousPage, forKey: "hasPreviousPage")
		}
		if isFirstPage != nil{
			aCoder.encode(isFirstPage, forKey: "isFirstPage")
		}
		if isLastPage != nil{
			aCoder.encode(isLastPage, forKey: "isLastPage")
		}
		if lastPage != nil{
			aCoder.encode(lastPage, forKey: "lastPage")
		}
		if list != nil{
			aCoder.encode(list, forKey: "list")
		}
		if navigatePages != nil{
			aCoder.encode(navigatePages, forKey: "navigatePages")
		}
		if navigatepageNums != nil{
			aCoder.encode(navigatepageNums, forKey: "navigatepageNums")
		}
		if nextPage != nil{
			aCoder.encode(nextPage, forKey: "nextPage")
		}
		if orderBy != nil{
			aCoder.encode(orderBy, forKey: "orderBy")
		}
		if pageNum != nil{
			aCoder.encode(pageNum, forKey: "pageNum")
		}
		if pageSize != nil{
			aCoder.encode(pageSize, forKey: "pageSize")
		}
		if pages != nil{
			aCoder.encode(pages, forKey: "pages")
		}
		if prePage != nil{
			aCoder.encode(prePage, forKey: "prePage")
		}
		if size != nil{
			aCoder.encode(size, forKey: "size")
		}
		if startRow != nil{
			aCoder.encode(startRow, forKey: "startRow")
		}
		if total != nil{
			aCoder.encode(total, forKey: "total")
		}

	}

}
