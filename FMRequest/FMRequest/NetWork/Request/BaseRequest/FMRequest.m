//
//  FMRequest.m
//  FMSLive
//
//  Created by 郦道元  on 2017/10/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "FMRequest.h"
#import "FMRequestManager.h"
#import "FMRequestAddressSetting.h"

@interface FMRequest()

/**
 API调用的类,对应的字段 --> "appReferer"
 */
@property (nonatomic, copy) NSString *apiClassName;

@end


static NSString * const appReferer = @"appReferer";


@implementation FMRequest


/*******    设置请求,并不会开始      *********/

-(void)requestSuccess:(requestSuccessResult)successCallBack failed:(requestFailedResult)failedCallback
{
    [self requestWithParams:nil modelClass:nil success:successCallBack failed:failedCallback];
}

-(void)requestWithModelClass:(Class _Nullable)modelClass success:(requestSuccessResult)successCallBack failed:(requestFailedResult)failedCallback
{
    [self requestWithParams:nil modelClass:modelClass success:successCallBack failed:failedCallback];
}


-(void)requestWithParams:(NSDictionary * _Nullable)params success:(requestSuccessResult)successCallBack failed:(requestFailedResult)failedCallback
{
    [self requestWithParams:params modelClass:nil success:successCallBack failed:failedCallback];
}

-(void)requestWithParams:(NSDictionary * _Nullable)params modelClass:(Class _Nullable)modelClass success:(requestSuccessResult)successCallBack failed:(requestFailedResult)failedCallback
{
    self.parameters = params;
    self.modelClass = modelClass;
    self.requestSuccessCallback = successCallBack;
    self.requestFailedCallback = failedCallback;
}

//*************************************


/************ 设置请求,并开始***********************/


-(void)startRequestSuccess:(requestSuccessResult)successCallBack failed:(requestFailedResult)failedCallback
{
    [self startRequestWithParams:nil modelClass:nil success:successCallBack failed:failedCallback];
}

-(void)startRequestWithModelClass:(Class _Nullable)modelClass success:(requestSuccessResult)successCallBack failed:(requestFailedResult)failedCallback
{
    [self startRequestWithParams:nil modelClass:modelClass success:successCallBack failed:failedCallback];
}


-(void)startRequestWithParams:(NSDictionary * _Nullable)params success:(requestSuccessResult)successCallBack failed:(requestFailedResult)failedCallback
{
    [self startRequestWithParams:params modelClass:nil success:successCallBack failed:failedCallback];
}

-(void)startRequestWithParams:(NSDictionary * _Nullable)params modelClass:(Class _Nullable)modelClass success:(requestSuccessResult)successCallBack failed:(requestFailedResult)failedCallback
{
    self.parameters = params;
    self.modelClass = modelClass;
    self.requestSuccessCallback = successCallBack;
    self.requestFailedCallback = failedCallback;
    [self startRequest];
}

//*************************************

-(void)startRequest
{
    [[FMRequestManager sharedManager] addRequest:self];
}


-(void)cancelRequest
{
    [[FMRequestManager sharedManager] cancelRequest:self];
}


-(void)clearBlock
{
    self.requestSuccessCallback = nil;
    self.requestSuccessCallback = nil;
    self.requestProgressCallBack = nil;
    self.requestConstructingBodyBlock = nil;
}


-(NSString * _Nonnull)requestBaseUrl
{
    return [FMRequestAddressSetting sharedInstance].baseUrl;
}

-(NSString * _Nullable)requestDetailUrl
{
    return @"open/api/weather/json.shtml";
}

-(FMRequestMethod)requestMethod
{
    return FMRequestMethodGET;
}

-(FMRequestType)requestType
{
    return FMRequestTypeNormal;
}

-(FMRequestSerializerType)requestSerializerType
{
    return FMRequestSerializerTypeHTTP;
}

-(FMResponseSerializerType)responseSerializerType
{
    return FMResponseSerializerTypeJSON;
}

-(NSSet *)responseAcceptableContentTypes
{
    return [NSSet setWithObjects:
            @"text/json",
            @"text/html",
            @"application/json",
            @"text/javascript", nil];
}

-(NSDictionary * _Nullable)requestHeaders
{
    
    NSDictionary *headers = @{
                              @"user-agent":@"iphone_"
                              };
    return headers;
}

-(NSInteger)requestTimeOutInterval
{
    return 20;
}
-(NSDictionary *)requestparameters
{
    return nil;
}

-(void)dealloc
{
    
}

@end
