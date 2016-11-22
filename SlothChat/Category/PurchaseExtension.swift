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

struct SGIAPPurchaseKey {
    public static let IAPPurchaseSuccess = Notification.Name(rawValue: "SlothChat.IAPPurchaseSuccess")
}

extension UIViewController{
    
    func purchaseForProduct(price: String?,productID: String?) {
        guard let price = price,
              let productID = productID else{
                return
        }
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        
        if IAPShare.sharedHelper().iap == nil {
            let set = Set(arrayLiteral: productID)
            IAPShare.sharedHelper().iap = IAPHelper(productIdentifiers: set)
        }
        IAPShare.sharedHelper().iap.production = false
        
        IAPShare.sharedHelper().iap.requestProducts { (request, response) in
            guard let products = IAPShare.sharedHelper().iap.products else {
                HUD.flash(.label("获取产品失败，请重试"), delay: 2)
                return
            }
            
            if products.count <= 0 {
                HUD.flash(.label("未获取到产品"), delay: 2)
                return
            }
            
            let product = products.first
            
            IAPShare.sharedHelper().iap.buyProduct(product as! SKProduct!, onCompletion: { (trans) in
                guard let trans = trans else {
                    HUD.flash(.label("充值失败，请重试"), delay: 2)
                    return
                }
                if (trans.error != nil ||
                    trans.transactionState == SKPaymentTransactionState.failed) {
                    SGLog(message: trans.error?.localizedDescription)
                    HUD.flash(.label(trans.error?.localizedDescription), delay: 2)
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
                                SGLog(message: error?.localizedDescription)
                                HUD.flash(.label("校验失败，请重试"), delay: 2)
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
                if let amount = Int(amount),
                    let banlace = Global.shared.globalSysConfig?.banlace  {
                    let newBanlace = banlace + amount
                    Global.shared.globalSysConfig?.banlace = newBanlace
                }
                NotificationCenter.default.post(name: SGIAPPurchaseKey.IAPPurchaseSuccess, object: nil)

                HUD.flash(.label("充值成功"), delay: 2)
            }else{
                HUD.flash(.label(response?.msg), delay: 2)
            }
        }
    }
}
