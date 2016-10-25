//
//  CountryCodeObj.swift
//  SlothChat
//
//  Created by fly on 16/10/14.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class CountryCodeObj: NSObject {
    var code: String?
    var name: String?
    var display: String?
    
    class func countryCode(name: String, code: String) -> CountryCodeObj {
        let obj = CountryCodeObj.init()
        obj.name = name
        obj.code = code
        return obj
    }
//     -> [[CountryCodeObj]] 
    func getCountrySectionList(allCountryList: [CountryCodeObj]){
        
//        var list = [CountryCodeObj]()
//
//        var sectionChar = ""
//        
//        for countryObj in allCountryList {
//            let frist = countryObj.name?.substring(to: 1)
//            
//            
//        }
        
//        return nil
    }
}

