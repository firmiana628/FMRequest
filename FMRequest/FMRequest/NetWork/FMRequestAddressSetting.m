//
//  FMRequestAddressSetting.m
//  FMRequest
//
//  Created by 张大威 on 2018/4/1.
//  Copyright © 2018年 zhang-yawei. All rights reserved.
//

#import "FMRequestAddressSetting.h"

static FMRequestAddressSetting *_staticSetting;

@implementation FMRequestAddressSetting

+(FMRequestAddressSetting *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _staticSetting = [[FMRequestAddressSetting alloc]init];
    });
    return _staticSetting;
}



-(instancetype)init
{
    if (self = [super init]) {
        _baseUrl = @"https://www.sojson.com";
    }
    return self;
}




@end
