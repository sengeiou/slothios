//
//  CountryCodeObj.swift
//  SlothChat
//
//  Created by fly on 16/10/14.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class CountryCodeObj: NSObject {
    var name: String?
    var code: String?
    class func countryCode(name: String, code: String) -> CountryCodeObj {
        let obj = CountryCodeObj.init()
        obj.name = name
        obj.code = code
        return obj
    }
}
