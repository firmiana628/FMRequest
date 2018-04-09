//
//  FMRequestManager.m
//  FMSLive
//
//  Created by 郦道元  on 2017/10/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "FMRequestManager.h"
#import "FMRequest.h"

#import <AFNetworking.h>

#import "FMNetworkUtil.h"
#import <YYModel.h>
#import "FMBatchRequest.h"
#import "FMRequestAddressSetting.h"
#import "NSString+HHAdd.h"
#import "FMRequestConvertProtocol.h"

static FMRequestManager *_sharedManager = nil;

@interface FMRequestManager()

@property(nonatomic,strong)NSMutableDictionary <NSString *,AFHTTPSessionManager *> *sessionManagerPool; // session 缓存


@end

@implementation FMRequestManager

#pragma mark - getter
-(NSMutableDictionary *)sessionManagerPool
{
    if (_sessionManagerPool == nil) {
        _sessionManagerPool = [[NSMutableDictionary alloc]init];
    }
    return _sessionManagerPool;
}

#pragma mark - init
+(FMRequestManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[FMRequestManager alloc]init];
    });
    return _sharedManager;
}



#pragma mark - public

// 添加一个请求
-(void)addRequest:(FMRequest *)addedRequest
{
   
    AFHTTPSessionManager *sessionManager = [self sessionManagerFromPoolWithRequest:addedRequest];
    
    [self sendSingleRequest:addedRequest withSessionManager:sessionManager];
}

- (void)sendSingleRequest:(FMRequest *)req withSessionManager:(AFHTTPSessionManager *)sessionManager {
    [self sendSingleRequest:req withSessionManager:sessionManager andCompletionGroup:nil];
}

- (void)sendSingleRequest:(FMRequest *)req
           withSessionManager:(AFHTTPSessionManager *)sessionManager
           andCompletionGroup:(dispatch_group_t)completionGroup {

    // 检查网络
    if (![FMNetworkUtil IsEnableNetwork]) {
        [self handleNoNetwrokWithRequest:req];//处理没网的情况
        
        if (completionGroup) {
            dispatch_group_leave(completionGroup);
        }
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    NSString *requestUrlStr = [self buildUrlWithRequest:req];

   NSDictionary * requestParams = [self buildParamsWithRequest:req];
    
    void (^successBlock)(NSURLSessionDataTask *task, id responseObject)
    = ^(NSURLSessionDataTask * task, id responseObject) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [strongSelf handleSuccessResponseBlock:task req:req responseObj:responseObject];
        if (completionGroup) {
            dispatch_group_leave(completionGroup);
        }
    };
    
    void (^failureBlock)(NSURLSessionDataTask * task, NSError * error)
    = ^(NSURLSessionDataTask * task, NSError * error) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [strongSelf handleResquestFailureResponseBlock:task req:req error:error];
        if (completionGroup) {
            dispatch_group_leave(completionGroup);
        }
    };
    
    void (^apiProgressBlock)(NSProgress *progress) = ^(NSProgress *progress) {
        if (progress.totalUnitCount <= 0) {
            return;
        }
        if (req.requestProgressCallBack) {
            req.requestProgressCallBack(progress);
        }
    };
    

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
 
    NSURLSessionDataTask *dataTask;
    FMRequestType reqeustType = [req requestType];
    FMRequestMethod requestMethod = [req requestMethod];
    switch (requestMethod) {
        case FMRequestMethodGET:
        {
            dataTask =
            [sessionManager GET:requestUrlStr
                     parameters:requestParams
                       progress:apiProgressBlock
                        success:successBlock
                        failure:failureBlock];
        }
            break;
        case FMRequestMethodDELETE:
        {
            dataTask =
            [sessionManager DELETE:requestUrlStr parameters:requestParams success:successBlock failure:failureBlock];
        }
            break;
        case FMRequestMethodPATCH:
        {
            dataTask =
            [sessionManager PATCH:requestUrlStr parameters:requestParams success:successBlock failure:failureBlock];
        }
            break;
        case FMRequestMethodPUT:
        {
            dataTask =
            [sessionManager PUT:requestUrlStr parameters:requestParams success:successBlock failure:failureBlock];
        }
            break;
        case FMRequestMethodHEAD:
        {
            dataTask =
            [sessionManager HEAD:requestUrlStr
                      parameters:requestParams
                         success:^(NSURLSessionDataTask * _Nonnull task) {
                             if (successBlock) {
                                 successBlock(task, nil);
                             }
                         }
                         failure:failureBlock];
        }
            break;
        case FMRequestMethodPOST:
        {
            if (reqeustType == FMRequestTypeUpload && req.requestConstructingBodyBlock != nil) {
                
                void (^block)(id <AFMultipartFormData> formData)
                = ^(id <AFMultipartFormData> formData) {
                    req.requestConstructingBodyBlock((id<AFMultipartFormData>)formData);
                };
                dataTask =
                [sessionManager POST:requestUrlStr
                          parameters:requestParams
           constructingBodyWithBlock:block
                            progress:apiProgressBlock
                             success:successBlock
                             failure:failureBlock];
               
            } else {
                dataTask =
                [sessionManager POST:requestUrlStr
                          parameters:requestParams
                            progress:apiProgressBlock
                             success:successBlock
                             failure:failureBlock];
            }
        }
            break;
        default:
            dataTask =
            [sessionManager GET:requestUrlStr
                     parameters:requestParams
                       progress:apiProgressBlock
                        success:successBlock
                        failure:failureBlock];
            break;
    }

    req.sessionTask = dataTask;
}


- (void)addBatchRequest:(nonnull FMBatchRequest *)reqs {
    
    dispatch_group_t batch_req_group = dispatch_group_create();
    __weak typeof(self) weakSelf = self;
    [reqs.requests enumerateObjectsUsingBlock:^(FMRequest *req,NSUInteger idx,BOOL * stop) {
        dispatch_group_enter(batch_req_group);
        
        __strong typeof (weakSelf) strongSelf = weakSelf;
        AFHTTPSessionManager *sessionManager = [strongSelf sessionManagerFromPoolWithRequest:req];
        if (!sessionManager) {
            *stop = YES;
            dispatch_group_leave(batch_req_group);
        }
        //sessionManager.completionGroup = batch_api_group;
        
        [strongSelf sendSingleRequest:req withSessionManager:sessionManager andCompletionGroup:batch_req_group];
    }];
    dispatch_group_notify(batch_req_group, dispatch_get_main_queue(), ^{
        if (reqs.batchFinishBlock) {
            reqs.batchFinishBlock();
        }
    });
}


-(void)cancelRequest:(FMRequest *)cancelRequest
{
    if (cancelRequest.sessionTask != nil) {
        [cancelRequest.sessionTask cancel];
        [cancelRequest clearBlock];
    }
}


-(AFHTTPSessionManager *)sessionManagerFromPoolWithRequest:(FMRequest *)req
{
    NSString *url = [self buildUrlWithRequest:req];
    AFHTTPResponseSerializer *responseSerializer = [self responseSerializerForRequest:req];
    AFHTTPRequestSerializer *requestSerizlizer = [self requestSerializerForRequest:req];
    
    AFHTTPSessionManager *sessionManager = self.sessionManagerPool[url];
    if (sessionManager == nil) {
        sessionManager = [AFHTTPSessionManager manager];
        self.sessionManagerPool[url] = sessionManager;
    }
    sessionManager.requestSerializer = requestSerizlizer;
    sessionManager.responseSerializer = responseSerializer;
    return sessionManager;
}



#pragma mark - handle
// 成功
-(void)handleSuccessResponseBlock:(NSURLSessionDataTask *)task req:(FMRequest *)req responseObj:(id)respObj
{
  //  NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    if (req.modelClass) {
        if ([req.modelClass conformsToProtocol:@protocol(FMRequestConvertProtocol)] && [req.modelClass respondsToSelector:@selector(prepareConvertToModel:)]){
                respObj = [req.modelClass prepareConvertToModel:respObj];
        }
        respObj = [req.modelClass yy_modelWithDictionary:respObj];
        
        if ([req.modelClass conformsToProtocol:@protocol(FMRequestConvertProtocol)] && [req.modelClass instancesRespondToSelector:@selector(didFinishConvertToModel)]) {
            [respObj performSelector:@selector(didFinishConvertToModel)];
        }
    }
    
    if (req.requestSuccessCallback) {
        req.requestSuccessCallback(respObj);
    }
    [req clearBlock];

    
}

// 失败
-(void)handleResquestFailureResponseBlock:(NSURLSessionDataTask *)task req:(FMRequest *)req error:(NSError *)error
{
    FMRequestError *responseError = [[FMRequestError alloc]init];
    responseError.error = error;
    [self handleResquestFailureWithRequest:req error:responseError];
}


//处理没有网络的情况
-(void)handleNoNetwrokWithRequest:(FMRequest *)req
{
    FMRequestError *responseError = [[FMRequestError alloc]init];
    responseError.errorMessage = @"当前没有网络,请检查后重试～";
     [self handleResquestFailureWithRequest:req error:responseError];
    
}


-(void)handleResquestFailureWithRequest:(FMRequest *)req error:(FMRequestError *)requestError
{
    if (req.requestFailedCallback && requestError) {
        req.requestFailedCallback(requestError);
    }
    [req clearBlock];
}
#pragma mark -  private

-(NSString *)buildUrlWithRequest:(FMRequest *)request
{
    NSString *baseUrl = [request requestBaseUrl];
    
    if (!baseUrl) {
        baseUrl = [FMRequestAddressSetting sharedInstance].baseUrl;
    }
    
    NSString *detailUrl = [request requestDetailUrl];
    if (detailUrl) {
        if ([detailUrl hasPrefix:@"http"]) {
    
            return [detailUrl stringByURLEncoding];
        }else{
            return [[NSString stringWithFormat:@"%@/%@",baseUrl,detailUrl] stringByURLEncoding];
        }

    }else{
        return [baseUrl stringByURLEncoding];
    }
    
}

-(NSDictionary *)buildParamsWithRequest:(FMRequest *)req
{
    NSDictionary *paramas = req.parameters?:[req requestparameters];
    
    return paramas;
}

- (AFHTTPRequestSerializer *)requestSerializerForRequest:(FMRequest *)req {
    
    AFHTTPRequestSerializer *requestSerializer;
    if ([req requestSerializerType] == FMRequestSerializerTypeJSON) {
        requestSerializer = [AFJSONRequestSerializer serializer];
    } else {
        requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    requestSerializer.timeoutInterval      = [req requestTimeOutInterval];
    NSDictionary *requestHeaderFields = [req requestHeaders];
    if (requestHeaderFields) {
        [requestHeaderFields enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    return requestSerializer;
}

- (AFHTTPResponseSerializer *)responseSerializerForRequest:(FMRequest *)req {
    
    AFHTTPResponseSerializer *responseSerializer;
    if ([req responseSerializerType] == FMResponseSerializerTypeJSON) {
        responseSerializer = [AFJSONResponseSerializer serializer];
    }else {
        responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    responseSerializer.acceptableContentTypes = [req responseAcceptableContentTypes];
    return responseSerializer;
}


@end
