//
//  ExampleModel.h
//  FMRequest
//
//  Created by lidaoyuan on 2018/4/10.
//  Copyright © 2018年 zhang-yawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMRequestConvertProtocol.h"
@class ForecastModel;

@interface ExampleModel : NSObject<FMRequestConvertProtocol>

@property(nonatomic,copy)NSString *city;// = "杭州";
@property(nonatomic,assign)NSInteger count;// = 493;
@property(nonatomic,strong)NSArray *forecastArray;
  //  data =     {
@property(nonatomic,copy)NSString *ganmao;// = "极少数敏感人群应减少户外活动";
@property(nonatomic,assign)NSInteger pm10;// = 112;
@property(nonatomic,assign)NSInteger pm25;// = 47;
@property(nonatomic,copy)NSString *quality;// = "良";
@property(nonatomic,copy)NSString *shidu;// = "45%";
@property(nonatomic,assign)NSInteger wendu;// = 18;
@property(nonatomic,strong)ForecastModel *yesterday;// =         {

@property(nonatomic,assign)NSInteger date;// = 20180410;
@property(nonatomic,copy)NSString *message;// = "Success !";
@property(nonatomic,assign)NSInteger status;// = 200;

@end


@interface ForecastModel:NSObject
@property(nonatomic,assign)NSInteger aqi;// = 45;
@property(nonatomic,copy)NSString *date;// = "12日星期四";
@property(nonatomic,copy)NSString *fl;// = "<3级";
@property(nonatomic,copy)NSString *fx;// = "东风";
@property(nonatomic,copy)NSString *high;// = "高温 26.0℃";
@property(nonatomic,copy)NSString *low;// = "低温 16.0℃";
@property(nonatomic,copy)NSString *notice;// = "带好雨具，别在树下躲雨";
@property(nonatomic,copy)NSString *sunrise;// = "05:38";
@property(nonatomic,copy)NSString *sunset;// = "18:24";
@property(nonatomic,copy)NSString *type;// = "雷阵雨";

@end

