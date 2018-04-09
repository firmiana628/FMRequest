//
//  FMRequestManager.h
//  FMSLive
//
//  Created by 郦道元  on 2017/10/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMRequest;
@class FMBatchRequest;
@interface FMRequestManager : NSObject

+(FMRequestManager * _Nonnull)sharedManager;

/**
 添加一个请求

 @param addedRequest req
 */
-(void)addRequest:(FMRequest * _Nonnull)addedRequest;

/**
 添加一个批请求

 @param reqs req
 */
- (void)addBatchRequest:(FMBatchRequest * _Nonnull)reqs;


/**
 取消请求

 @param cancelRequest req
 */
-(void)cancelRequest:(FMRequest * _Nonnull)cancelRequest;

@end
