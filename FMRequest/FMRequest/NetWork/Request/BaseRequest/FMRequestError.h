//
//  FMRequestError.h
//  FMRequest
//
//  Created by 张大威 on 2018/4/5.
//  Copyright © 2018年 zhang-yawei. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef NS_ENUM(NSUInteger, FMRequestErrorType) {
//    FMRequestErrorNetworkError,
//    <#MyEnumValueB#>,
//    <#MyEnumValueC#>,
//};

@interface FMRequestError : NSObject

@property(nonatomic,strong)NSError *error;
@property(nonatomic,copy)NSString *errorMessage;

@end
