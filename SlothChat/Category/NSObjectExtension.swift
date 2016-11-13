//
//  NSObjectExtension.swift
//  SlothChat
//
//  Created by fly on 2016/11/13.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import Foundation

extension NSObject{

    func allProperties() ->[String] {
        // 这个类型可以使用CUnsignedInt,对应Swift中的UInt32
        var count: UInt32 = 0
        let properties = class_copyPropertyList(self.classForCoder, &count)
        var propertyNames: [String] = []
        // Swift中类型是严格检查的，必须转换成同一类型
        for i in 0..<Int(count) {
            // UnsafeMutablePointer<objc_property_t>是可变指针，因此properties就是类似数组一样，可以通过下标获取
            let property = properties?[i]
            let name = property_getName(property)
            // 这里还得转换成字符串
            let strName =  String.init(cString: name!)
            propertyNames.append(strName);
        }
        // 不要忘记释放内存，否则C语言的指针很容易成野指针的
        free(properties)
        
        return propertyNames;
    }
    
    func allPropertyNamesAndValues() -> [String: AnyObject] {
        var count: UInt32 = 0
        let properties = class_copyPropertyList(self.classForCoder, &count)

        // Swift中类型是严格检查的，必须转换成同一类型
        var resultDict: [String: AnyObject] = [:]

        for i in 0..<Int(count) {
            let property = properties?[i]
            // 取得属性名
            let name = property_getName(property)
            let strName =  String.init(cString: name!)
            // 取得属性值
            if let propertyValue = self.value(forKey: strName) {
                resultDict[strName] = propertyValue as AnyObject?
            }
        }
        free(properties)
        
        return resultDict
    }
}
