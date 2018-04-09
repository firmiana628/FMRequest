//
//  FMNetworkUtil.h
//  FMSLive
//
//  Created by 郦道元  on 2017/8/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMNetworkUtil : NSObject
// 是否wifi
+ (BOOL) IsEnableWIFI;
// 是否数据
+ (BOOL) IsEnableWWAN;
// 是否存在网络,WiFi或者WWAN
+ (BOOL) IsEnableNetwork;
// 网络类型
+ (NSString *)networkTypeString;
@end
