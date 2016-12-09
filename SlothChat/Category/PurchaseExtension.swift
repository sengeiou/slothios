//
//  PurchaseExtation.swift
//  SlothChat
//
//  Created by fly on 2016/11/13.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import Foundation

struct SGIAPPurchaseKey {
    public static let IAPPurchaseSuccess = Notification.Name(rawValue: "SlothChat.IAPPurchaseSuccess")
}

extension BaseViewController{
    
    func purchaseForProduct(price: String?,productID: String?) {
        guard let price = price,
              let productID = productID else{
                return
        }
        self.showNotificationProgress()
        
        let set = Set(arrayLiteral: productID)

        if IAPShare.sharedHelper().iap == nil {
            IAPShare.sharedHelper().iap = IAPHelper(productIdentifiers: set)
        }else{
            IAPShare.sharedHelper().iap.productIdentifiers = set;
        }
//        IAPShare.sharedHelper().iap.handleFinishTransaction()
        
        IAPShare.sharedHelper().iap.production = false
        
        IAPShare.sharedHelper().iap.requestProducts { (request, response) in
            guard let products = IAPShare.sharedHelper().iap.products else {
                self.hiddenNotificationProgress(animated: false)
                self.showNotificationError(message: "获取产品失败，请重试")
                return
            }
            
            if products.count <= 0 {
                self.hiddenNotificationProgress(animated: false)
                self.showNotificationError(message: "未获取到产品")
                return
            }
            
            let product = products.first
            
            IAPShare.sharedHelper().iap.buyProduct(product as! SKProduct!, onCompletion: { (trans) in
                guard let trans = trans else {
                    self.hiddenNotificationProgress(animated: false)
                    self.showNotificationError(message: "充值失败，请重试")
                    return
                }
                if (trans.error != nil ||
                    trans.transactionState == SKPaymentTransactionState.failed) {
                    SGLog(message: trans.error?.localizedDescription)
                    self.hiddenNotificationProgress(animated: false)
                    self.showNotificationError(message: trans.error?.localizedDescription)
                    return
                }
                
                if trans.transactionState == SKPaymentTransactionState.purchased{
                    if  let data = try? Data(contentsOf: Bundle.main.appStoreReceiptURL!) {
                        IAPShare.sharedHelper().iap.checkReceipt(data, onCompletion: { (response, error) in
                            self.hiddenNotificationProgress(animated: false)
                            
                            let rec = IAPShare.toJSON(response!)
                            let dict: [String: Any] = rec as! [String : Any]
                            guard let status = dict["status"] as? Int else {
                                return
                            }
                            if status == 0 {
                                IAPShare.sharedHelper().iap.provideContent(with: trans)
                                let receipt = data.base64EncodedString()
                                
//                                self.iapPurchaseSuccess(receipt: receipt, amount: price)
                                
                                SGLog(message: dict)
                                let receiptDict: [String: Any] = (dict["receipt"] as? Dictionary)!
                                let inAppList:[[String: Any]] = (receiptDict["in_app"] as? Array)!
                                let firstDict = inAppList.first
                                let transactionId: String = firstDict!["transaction_id"] as! String
                                
                                SGLog(message: transactionId)
                                self.iapPurchaseSuccess(receipt: receipt,productId:productID,transactionId:transactionId,amount: price)

                            }else{
                                SGLog(message: error?.localizedDescription)
                                self.showNotificationError(message: "校验失败，请重试")
                            }
                        })
                    }
                }
            })
        }
    }

    func iapPurchaseSuccess(receipt: String, productId: String?, transactionId: String?,amount: String) {
        let engine = NetworkEngine()
        self.showNotificationProgress()
        
        engine.postCharge(appPayReceipt: receipt, productId: productId, transactionId: transactionId) { (response) in
            self.hiddenNotificationProgress(animated: false)
            if response?.status == ResponseError.SUCCESS.0{
                if let amount = Int(amount),
                    let banlace = Global.shared.globalSysConfig?.banlace  {
                    let newBanlace = banlace + amount
                    Global.shared.globalSysConfig?.banlace = newBanlace
                }
                NotificationCenter.default.post(name: SGIAPPurchaseKey.IAPPurchaseSuccess, object: nil)
                self.showNotificationSuccess(message: "充值成功")
            }else{
                self.showNotificationError(message: response?.msg)
            }
        }
    }
}
