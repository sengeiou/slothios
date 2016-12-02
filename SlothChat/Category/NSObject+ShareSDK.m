//
//  NSObject+ShareSDK.m
//  SlothChat
//
//  Created by Fly on 16/10/22.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

#import "NSObject+ShareSDK.h"

#import "WXApi.h"
#import "WeiboSDK.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

@implementation NSObject (ShareSDK)

+ (void)registerShareSDK{
    [ShareSDK registerApp:@"844ac1288de3"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"1691968029"
                                           appSecret:@"ff5b34a6a684d4ca4d86a1eedc12c428"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxcd1578b764c4f37b"
                                       appSecret:@"2205c89b80bbe3a85e1c9f712362e519"];
                 break;
             default:
                 break;
         }
     }];
}

+ (void)share{
    //1、创建分享参数
    UIImage *shareImg = [UIImage imageNamed:@"icon"];
    if (shareImg) {
        
    }
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:@""
                                     images:shareImg
                                        url:[NSURL URLWithString:@"http://www.ssloth.com"]
                                      title:nil
                                       type:SSDKContentTypeAuto];
    
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                             items:@[@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline)]
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                       case SSDKResponseStateSuccess:{
                           UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"分享成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
                           UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"我知道了", nil) style:UIAlertActionStyleCancel handler:nil];
                           [alertVC addAction:action];
                           [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertVC animated:YES completion:nil];
                           break;
                       }
                       case SSDKResponseStateFail:{
                           UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"分享失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
                           UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"我知道了", nil) style:UIAlertActionStyleCancel handler:nil];
                           [alertVC addAction:action];
                           [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertVC animated:YES completion:nil];
                           break;
                       }
                       default:
                           break;
                   }
               }
     ];
}

@end
