//
//  ViewController.m
//  FMRequest
//
//  Created by 张大威 on 2018/4/1.
//  Copyright © 2018年 zhang-yawei. All rights reserved.
//

#import "ViewController.h"
#import "FMRequest.h"
#import "FMExampleRequest.h"
#import "ExampleModel.h"

@interface ViewController ()
{
    UILabel *_responseLabel;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _responseLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height - 100)];
    _responseLabel.numberOfLines = 0;
    [self.view addSubview:_responseLabel];
}

#pragma mark -  public
-(void)normalRequest
{
    self.title = @"普通请求";
    NSDictionary *dic = @{@"city":@"杭州",
                          };
    [[[FMRequest alloc]init] startRequestWithParams:dic success:^(id  _Nullable response) {
        
        NSString *responseString = [NSString stringWithFormat:@"%@",response];
        _responseLabel.text = [self removeSpaceAndNewline:responseString] ;
    } failed:^(FMRequestError *requestError) {
        
    }];
    
    
    
}

-(void)modelRequest
{
    self.title = @"构造request对象";
    
    [[[FMExampleRequest alloc]init] startRequestSuccess:^(id  _Nullable response) {
        NSString *responseString = [NSString stringWithFormat:@"%@",response];
        _responseLabel.text = [self removeSpaceAndNewline:responseString] ;
    } failed:^(FMRequestError *requestError) {
        
    }];
    
    
}

-(void)requestWithModel
{
    self.title = @"返回model对象";
    [[[FMExampleRequest alloc]init] startRequestWithModelClass:[ExampleModel class] success:^(id  _Nullable response) {
        ExampleModel *model = response;
        NSString *logString = [NSString stringWithFormat:@"城市:%@, 感冒情况:%@",model.city,model.ganmao];
        _responseLabel.text = logString;
    } failed:^(FMRequestError *requestError) {
        
    }];
    
    
}





- (NSString *)removeSpaceAndNewline:(NSString *)str
{
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
