//
//  PurchaseExtation.swift
//  SlothChat
//
//  Created by fly on 2016/11/13.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import PKHUD
import Foundation

extension UIViewController{
    
    func purchaseForProduct(price: String) {
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        
        if IAPShare.sharedHelper().iap == nil {
            let set = Set(arrayLiteral: "com.ssloth.animal.recharge")
            IAPShare.sharedHelper().iap = IAPHelper(productIdentifiers: set)
        }
        IAPShare.sharedHelper().iap.production = false
        
        IAPShare.sharedHelper().iap.requestProducts { (request, response) in
            guard let products = IAPShare.sharedHelper().iap.products else {
                HUD.hide()
                return
            }
            
            if products.count <= 0 {
                SGLog(message: "未获取到产品")
                HUD.hide()
                return
            }
            
            let product = products.first
            
            IAPShare.sharedHelper().iap.buyProduct(product as! SKProduct!, onCompletion: { (trans) in
                guard let trans = trans else {
                    HUD.hide()
                    return
                }
                if (trans.error != nil ||
                    trans.transactionState == SKPaymentTransactionState.failed) {
                    SGLog(message: "error")
                    HUD.hide()
                    return
                }
                
                if trans.transactionState == SKPaymentTransactionState.purchased{
                    if  let data = try? Data(contentsOf: Bundle.main.appStoreReceiptURL!) {
                        
                        IAPShare.sharedHelper().iap.checkReceipt(data, onCompletion: { (response, error) in
                            
                            HUD.hide()
                            
                            let rec = IAPShare.toJSON(response!)
                            let dict: [String: Any] = rec as! [String : Any]
                            guard let status = dict["status"] as? Int else {
                                return
                            }
                            if status == 0 {
                                IAPShare.sharedHelper().iap.provideContent(with: trans)
                                let receipt = data.base64EncodedString()
                                self.iapPurchaseSuccess(receipt: receipt, amount: price)
                                SGLog(message: dict)
                            }else{
                                SGLog(message: "error")
                            }
                        })
                    }
                }
            })
        }
    }

    func iapPurchaseSuccess(receipt: String, amount: String) {
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        
        engine.postCharge(appPayReceipt: receipt, amount: amount) { (response) in
            HUD.hide()
            if response?.status == ResponseError.SUCCESS.0{
                HUD.flash(.label("充值成功"), delay: 2)
            }else{
                HUD.flash(.label(response?.msg), delay: 2)
            }
        }
    }
}
