//
//  FMBaseModel.h
//  FMSLive
//
//  Created by 郦道元  on 2017/7/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMBaseModel : NSObject

#pragma mark - optional ovveride
/**
 json转为模型前调用,方便对model的转化
 */
-(void)prepareConvertToModel;



/**
 json转为模型后调用,方便对model的转化
 */
-(void)didFinishConvertToModel;

@end
