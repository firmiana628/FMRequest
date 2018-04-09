//
//  FMRequest.h
//  FMSLive
//
//  Created by 郦道元  on 2017/10/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "FMRequestError.h"
// 请求方法
typedef NS_ENUM(NSUInteger, FMRequestMethod) {
    FMRequestMethodGET     = 0,
    FMRequestMethodPOST    = 1,
    FMRequestMethodHEAD    = 2,
    FMRequestMethodPUT     = 3,
    FMRequestMethodPATCH   = 4,
    FMRequestMethodDELETE  = 5
};


// 请求的序列化格式
typedef NS_ENUM(NSUInteger, FMRequestSerializerType) {
    FMRequestSerializerTypeHTTP    = 1,
    FMRequestSerializerTypeJSON    = 2,
   
};

// 请求返回的序列化格式
typedef NS_ENUM(NSUInteger, FMResponseSerializerType) {
    FMResponseSerializerTypeHTTP    = 1,
    FMResponseSerializerTypeJSON    = 2,
    FMResponseSerializerTypeSBJSON  = 3     // 使用sbJson解析json,防止double精度丢失
};

// 请求类型
typedef NS_ENUM(NSInteger,FMRequestType) {
    FMRequestTypeNormal = 0,
    FMRequestTypeUpload = 1,
  //  FMRequestTypeDownload = 2
};


//typedef void(^requestResult)(id _Nullable result,NSString* _Nullable error);

typedef void(^requestSuccessResult)(id _Nullable response);
typedef void(^requestFailedResult)(FMRequestError *requestError);
typedef void(^requestProgress)(NSProgress *progress);
@interface FMRequest : NSObject

@property(nonatomic,strong)NSURLSessionTask * _Nullable sessionTask;

@property(nonatomic,nullable)Class modelClass;
@property(nonatomic,assign)BOOL useSBJson;

// 请求参数.. 如果这个属性有值,就不会再调用 requestParams;方法
@property(nonatomic,copy,nullable)NSDictionary *parameters;
// 请求的回调
@property(nonatomic,copy,nullable)requestSuccessResult requestSuccessCallback;
@property(nonatomic,copy,nullable)requestFailedResult requestFailedCallback;

@property (nonatomic,copy,nullable)requestProgress requestProgressCallBack;
// 上传数据应用
@property (nonatomic, copy, nullable) void (^requestConstructingBodyBlock)(id<AFMultipartFormData> _Nonnull formData);


#pragma mark - optional ovveride


-(NSString * _Nonnull)requestBaseUrl;

-(NSString * _Nullable)requestDetailUrl;

-(FMRequestMethod)requestMethod;

-(FMRequestType)requestType;

-(FMRequestSerializerType)requestSerializerType;

-(FMResponseSerializerType)responseSerializerType;

-(NSSet * _Nullable)responseAcceptableContentTypes;


-(NSDictionary * _Nullable)requestHeaders;

-(NSDictionary * _Nullable)requestparameters;

-(NSInteger)requestTimeOutInterval;




/*******    设置请求,并不会开始      *********/
-(void)requestSuccess:(requestSuccessResult)successCallBack failed:(requestFailedResult)failedCallback;

-(void)requestWithModelClass:(Class _Nullable)modelClass success:(requestSuccessResult)successCallBack failed:(requestFailedResult)failedCallback;


-(void)requestWithParams:(NSDictionary * _Nullable)params modelClass:(Class _Nullable)modelClass success:(requestSuccessResult)successCallBack failed:(requestFailedResult)failedCallback;

-(void)requestWithParams:(NSDictionary * _Nullable)params success:(requestSuccessResult)successCallBack failed:(requestFailedResult)failedCallback;

//*******************************************






/*******    设置请求,并开始      *********/
-(void)startRequestSuccess:(requestSuccessResult)successCallBack failed:(requestFailedResult)failedCallback;

-(void)startRequestWithModelClass:(Class _Nullable)modelClass success:(requestSuccessResult)successCallBack failed:(requestFailedResult)failedCallback;


-(void)startRequestWithParams:(NSDictionary * _Nullable)params modelClass:(Class _Nullable)modelClass success:(requestSuccessResult)successCallBack failed:(requestFailedResult)failedCallback;

-(void)startRequestWithParams:(NSDictionary * _Nullable)params success:(requestSuccessResult)successCallBack failed:(requestFailedResult)failedCallback;

//*************************************



-(void)startRequest;

-(void)cancelRequest;

-(void)clearBlock;

@end
