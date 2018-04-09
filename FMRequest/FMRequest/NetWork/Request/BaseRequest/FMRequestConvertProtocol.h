//
//  FMRequestConvertProtocol.h
//  FMRequest
//
//  Created by 张大威 on 2018/4/6.
//  Copyright © 2018年 zhang-yawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FMRequestConvertProtocol <NSObject>

+(id)prepareConvertToModel:(id)responseObj;

-(void)didFinishConvertToModel;

@end
