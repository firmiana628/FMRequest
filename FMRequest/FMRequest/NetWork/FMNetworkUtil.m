//
//  FMNetworkUtil.m
//  FMSLive
//
//  Created by 郦道元  on 2017/8/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "FMNetworkUtil.h"
#import "Reachability.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <UIKit/UIKit.h>
@implementation FMNetworkUtil


// 是否wifi
+ (BOOL) IsEnableWIFI {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWiFi);
}

// 是否数据
+ (BOOL) IsEnableWWAN {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWWAN);
}

+ (BOOL) IsEnableNetwork {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}


//- (BOOL)isExistenceNetwork
//{
//    BOOL isExistenceNetwork;
//    Reachability *reachability = [Reachability reachabilityWitFMostName:@"www.apple.com"];
//    switch([reachability currentReachabilityStatus]){
//        case NotReachable: isExistenceNetwork = FALSE;
//            break;
//        case ReachableViaWWAN: isExistenceNetwork = FALSE;
//            break;
//        case ReachableViaWiFi: isExistenceNetwork = TRUE;
//            break;
//    }
//    return isExistenceNetwork;
//}







+(NSString *)networkTypeString
{
    if ([self IsEnableWIFI]) {
        return @"Wifi网络";
    }
    
    
    NSArray *typeStrings2G = @[CTRadioAccessTechnologyEdge,
                               CTRadioAccessTechnologyGPRS,
                               CTRadioAccessTechnologyCDMA1x];
    
    NSArray *typeStrings3G = @[CTRadioAccessTechnologyHSDPA,
                               CTRadioAccessTechnologyWCDMA,
                               CTRadioAccessTechnologyHSUPA,
                               CTRadioAccessTechnologyCDMAEVDORev0,
                               CTRadioAccessTechnologyCDMAEVDORevA,
                               CTRadioAccessTechnologyCDMAEVDORevB,
                               CTRadioAccessTechnologyeHRPD];
    
    NSArray *typeStrings4G = @[CTRadioAccessTechnologyLTE];
    
    NSString *netStr;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        CTTelephonyNetworkInfo *teleInfo= [[CTTelephonyNetworkInfo alloc] init];
        NSString *accessString = teleInfo.currentRadioAccessTechnology;
        if ([typeStrings4G containsObject:accessString]) {
            NSLog (@"4G网络");
            netStr=@"4G网络";
        } else if ([typeStrings3G containsObject:accessString]) {
            NSLog (@"3G网络");
            netStr=@"3G网络";
        } else if ([typeStrings2G containsObject:accessString]) {
            NSLog (@"2G网络");
            netStr=@"2G网络";
        } else {
            NSLog (@"未知网络");
            netStr=@"未知网络";
        }
    } else {
        NSLog (@"未知网络");
        netStr=@"未知网络";
    }
    return netStr;
    
}

@end
