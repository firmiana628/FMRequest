//
//  FMBatchRequest.m
//  FMSLive
//
//  Created by 郦道元  on 2017/10/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "FMBatchRequest.h"
#import "FMRequestManager.h"
@interface FMBatchRequest()



@end

@implementation FMBatchRequest

-(NSMutableArray *)requests
{
    if (_requests == nil) {
        _requests = [[NSMutableArray alloc]init];
    }
    return _requests;
}

-(instancetype)initWithRequests:(NSArray *)requests
{
    if (self = [super init]) {
        _requests = [[NSMutableArray alloc]initWithArray:requests];
    }
    return self;
}
-(void)addRequest:(FMRequest *)req
{
    if (![self.requests containsObject:req]) {
         [self.requests addObject:req];
    }
   
}
-(void)addRequestsFromArray:(NSArray *)requestArr
{
    [requestArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[FMRequest class]]) {
            [self addRequest:obj];
        }
    }];
}
-(void)startRequests
{
    [[FMRequestManager sharedManager] addBatchRequest:self];
}

-(void)startRequestsFinishBlock:(void(^)(void))batchFinish
{
    self.batchFinishBlock = batchFinish;
    [self startRequests];
}

-(void)clearBlock
{
    self.batchFinishBlock = nil;
}

-(void)dealloc
{
    
}

@end
