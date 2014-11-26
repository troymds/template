//
//  interfaceDetailsView.m
//  NewView
//
//  Created by YY on 14-11-18.
//  Copyright (c) 2014年 ___普而摩___. All rights reserved.
//

#import "interfaceDetailsView.h"
#import "YYSearchButton.h"
#import "YYalertView.h"
#define YYBODER 20
@interface interfaceDetailsView ()<YYalertViewDelegate>
{
    UIScrollView *_backScrollView;
}
@end

@implementation interfaceDetailsView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =HexRGB(0xe9f1f6);
    self.title =@"展会详情";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithSearch:@"colloct_img.png" highlightedSearch:@"colloct_img.png" target:(self) action:@selector(collectItem)];

    [self addheader];
    [self addWriteBtn];
}
-(void)collectItem{
    
}
-(void)addheader{

    UIWebView *companyWebView =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    companyWebView.scrollView.bounces = NO;
    companyWebView.scrollView.showsHorizontalScrollIndicator = NO;
    companyWebView.scrollView.showsVerticalScrollIndicator =NO;
    [companyWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_interface_Url]] ];
    [self.view addSubview:companyWebView];
    companyWebView.backgroundColor =[UIColor clearColor];



}
-(void)addWriteBtn{
    YYSearchButton *wirteBtn = [YYSearchButton buttonWithType:UIButtonTypeCustom];
    wirteBtn.frame = CGRectMake(20, kHeight-40,kWidth-YYBODER*2,30);
    [wirteBtn addTarget:self action:@selector(wirteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [wirteBtn setTitle:@"       写评论" forState:UIControlStateNormal];
    [wirteBtn setImage:[UIImage imageNamed:@"write.png"] forState:UIControlStateNormal];
    wirteBtn.titleLabel.font = [UIFont systemFontOfSize:PxFont(20)];
    wirteBtn.backgroundColor =[UIColor whiteColor];
    [wirteBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [self.view addSubview:wirteBtn];
    
}
-(void)wirteBtnClick:(UIButton *)write{
    YYalertView *aleartView =[[YYalertView alloc]init];
    aleartView.delegate = self;
    [aleartView showView ];

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
