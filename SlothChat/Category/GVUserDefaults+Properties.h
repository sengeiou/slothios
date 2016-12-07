//
//  GVUserDefaults+Properties.h
//  HarkLive
//
//  Created by kim on 15/7/1.
//  Copyright (c) 2015年 kim. All rights reserved.
//

#import "GVUserDefaults.h"

typedef NS_ENUM(NSInteger, NetWorkType) {
    NetWorkTypeOnLine = 0,
    NetWorkTypeDevelop = 1,
};

@interface GVUserDefaults (Properties)

@property (nonatomic, copy  ) NSString       *deviceToken;
@property (nonatomic, copy  ) NSString       *lastLoginPhone;
@property (nonatomic, copy  ) NSString       *lastCountryName;
@property (nonatomic, copy  ) NSString       *lastCountryCode;
@property (nonatomic, copy  ) NSString       *lastAppVersion;
@property (nonatomic, copy  ) NSString       *locationDesc;

@property (nonatomic, assign) NetWorkType     networkType;

@end
