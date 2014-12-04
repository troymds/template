
//
//  companyProfilesView.m
//  XinNet
//
//  Created by YY on 14-11-19.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "companyProfilesView.h"

@interface companyProfilesView ()

@end

@implementation companyProfilesView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    self.title =@"企业简介";
    
    UIWebView *marketWebView =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    [self.view addSubview:marketWebView];
    [marketWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_companyIndex]] ];
    
    [self.view addSubview:marketWebView];
    marketWebView.backgroundColor =[UIColor clearColor];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
