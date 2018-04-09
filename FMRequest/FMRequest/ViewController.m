//
//  ViewController.m
//  FMRequest
//
//  Created by 张大威 on 2018/4/1.
//  Copyright © 2018年 zhang-yawei. All rights reserved.
//

#import "ViewController.h"
#import "FMRequest.h"
@interface ViewController ()
{
    UILabel *_responseLabel;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _responseLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, self.view.bounds.size.width, self.view.bounds.size.height - 100)];
    [self.view addSubview:_responseLabel];
}

#pragma mark -  public
-(void)normalRequest
{
    self.title = @"普通请求";
    NSDictionary *dic = @{@"code":@"utf-8",
                          @"q":@"卫衣",
                          @"callback":@"cb"
                          };
    [[[FMRequest alloc]init] startRequestWithParams:dic success:^(id  _Nullable response) {
            _responseLabel.text = response;
    } failed:^(FMRequestError *requestError) {
        
    }];
    
    
    
}

-(void)modelRequest
{
    self.title = @"构造request对象";
    
}

-(void)requestWithModel
{
    self.title = @"返回model对象";
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
