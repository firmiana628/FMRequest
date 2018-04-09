//
//  FMExampleRequest.m
//  FMRequest
//
//  Created by 张大威 on 2018/4/7.
//  Copyright © 2018年 zhang-yawei. All rights reserved.
//

#import "FMExampleRequest.h"

@implementation FMExampleRequest

-(NSString * _Nonnull)requestBaseUrl
{
    return @"https://suggest.taobao.com";
}

-(NSString * _Nullable)requestDetailUrl
{
    return @"sug";
}

@end
