//
//  FMBatchRequest.h
//  FMSLive
//
//  Created by 郦道元  on 2017/10/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMRequest.h"
@interface FMBatchRequest : NSObject

@property(nonatomic,retain)NSMutableArray *requests;

@property(nonatomic,copy) void(^batchFinishBlock)(void);

-(instancetype)initWithRequests:(NSArray *)requests;
-(void)addRequest:(FMRequest *)req;
-(void)addRequestsFromArray:(NSArray *)requestArr;
-(void)startRequests;
-(void)startRequestsFinishBlock:(void(^)(void))batchFinish;

-(void)clearBlock;
@end
