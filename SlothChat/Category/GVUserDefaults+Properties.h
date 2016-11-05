//
//  GVUserDefaults+Properties.h
//  HarkLive
//
//  Created by kim on 15/7/1.
//  Copyright (c) 2015年 kim. All rights reserved.
//

#import "GVUserDefaults.h"

@interface GVUserDefaults (Properties)

@property (nonatomic, copy  ) NSString       *deviceToken;
@property (nonatomic, copy  ) NSString       *lastLoginPhone;
@property (nonatomic, copy  ) NSString       *lastLoginCountry;
@property (nonatomic, copy  ) NSString       *lastAppVersion;
@property (nonatomic, copy  ) NSString       *locationDesc;

@end
