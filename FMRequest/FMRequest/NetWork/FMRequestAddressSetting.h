//
//  FMRequestAddressSetting.h
//  FMRequest
//
//  Created by 张大威 on 2018/4/1.
//  Copyright © 2018年 zhang-yawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMRequestAddressSetting : NSObject

@property(nonatomic,copy)NSString *baseUrl;


+(FMRequestAddressSetting *)sharedInstance;




@end
