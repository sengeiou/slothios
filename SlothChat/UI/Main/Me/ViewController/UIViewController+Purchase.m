//
//  UIViewController+Purchase.m
//  SlothChat
//
//  Created by Fly on 16/10/22.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

#import "UIViewController+Purchase.h"
#import "IAPShare.h"

@implementation UIViewController (Purchase)

- (void)purchaseForProduct:(NSInteger)price{
    if(![IAPShare sharedHelper].iap) {
        NSSet* dataSet = [[NSSet alloc] initWithObjects:@"com.ssloth.animal.recharge", nil];
        
        [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
    }
    
    [IAPShare sharedHelper].iap.production = NO;
    
    [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response)
     {
         if(response > 0 ) {
             NSArray *products = [IAPShare sharedHelper].iap.products;
             if ([products count] > 0) {
                 SKProduct* product =[products objectAtIndex:0];
                 [[IAPShare sharedHelper].iap buyProduct:product
                                            onCompletion:^(SKPaymentTransaction* trans){
                                                
                                                if(trans.error)
                                                {
                                                    NSLog(@"Fail %@",[trans.error localizedDescription]);
                                                }
                                                else if(trans.transactionState == SKPaymentTransactionStatePurchased) {
                                                    
                                                    NSData *data = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
                                                    //NSData *data = trans.transactionReceipt
                                                    [[IAPShare sharedHelper].iap checkReceipt:data AndSharedSecret:@"your sharesecret" onCompletion:^(NSString *response, NSError *error) {
                                                        
                                                        //Convert JSON String to NSDictionary
                                                        NSDictionary* rec = [IAPShare toJSON:response];
                                                        
                                                        if([rec[@"status"] integerValue]==0)
                                                        {
                                                            
                                                            [[IAPShare sharedHelper].iap provideContentWithTransaction:trans];
                                                            NSLog(@"SUCCESS %@",response);
                                                            NSLog(@"Pruchases %@",[IAPShare sharedHelper].iap.purchasedProducts);
                                                        }
                                                        else {
                                                            NSLog(@"Fail");
                                                        }
                                                    }];
                                                }
                                                else if(trans.transactionState == SKPaymentTransactionStateFailed) {
                                                    NSLog(@"Fail");
                                                }
                                            }];
             }
             //end of buy product
         }
     }];
}

@end
