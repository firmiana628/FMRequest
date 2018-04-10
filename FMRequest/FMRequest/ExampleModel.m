//
//  ExampleModel.m
//  FMRequest
//
//  Created by lidaoyuan on 2018/4/10.
//  Copyright © 2018年 zhang-yawei. All rights reserved.
//

#import "ExampleModel.h"
#import <YYModel.h>
@implementation ExampleModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{
     @"forecastArray":@"data.forecast",
     @"ganmao":@"data.ganmao",
      @"pm10":@"data.pm10",
      @"pm25":@"data.pm25",
      @"quality":@"data.quality",
      @"shidu":@"data.shidu",
      @"wendu":@"data.wendu",
      @"ganmao":@"data.ganmao",
     @"yesterday":@"data.yesterday"
     };
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{
             @"forecastArray":[ForecastModel class],
             @"yesterday":[ForecastModel class]
             };
}


@end

@implementation ForecastModel


@end
