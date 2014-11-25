//
//  companyDetailsView.m
//  NewView
//
//  Created by YY on 14-11-18.
//  Copyright (c) 2014年 ___普而摩___. All rights reserved.
//

#import "companyDetailsView.h"
#import "YYalertView.h"
#import "RemindView.h"

#import "companyProfilesView.h"
#import "productController.h"
#import "businessController.h"
#import "companyJOBController.h"

#import "companyDetailTool.h"
#import "companyDetailsModel.h"
#define YYBODER 16
@interface companyDetailsView ()<YYalertViewDelegate>
{
        companyDetailsModel *companyModel;
}
@end

@implementation companyDetailsView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"企业详情";

    self.view.backgroundColor =HexRGB(0xe9f1f6);
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithSearch:@"nav_code.png" highlightedSearch:@"vav_code_pre.png" target:(self) action:@selector(sharSdk:)];
    
    [self addLoadStatus];
    

}
#pragma mark---加载数据
-(void)addLoadStatus{
    [companyDetailTool CompanyStatusesWithSuccesscategory:^(NSArray *statues) {
        companyModel =[[companyDetailsModel alloc]init];
        NSDictionary *dict =[statues objectAtIndex:0];
        companyModel.wapUrl =[dict objectForKey:@"wapUrl"];
        [self addImageView];
          } company_id:_companyDetailIndex CompanyFailure:^(NSError *error) {
        
    }];
}
-(void)sharSdk:(UIButton *)share{
    
}
-(void)addImageView{
    UIWebView *marketWebView =[[UIWebView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-120)];
    [self.view addSubview:marketWebView];
    [marketWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:companyModel.wapUrl]] ];
    NSLog(@"%@",companyModel.wapUrl);
    [self.view addSubview:marketWebView];
    marketWebView.backgroundColor =[UIColor redColor];

    
    
    YYSearchButton *findBtn = [YYSearchButton buttonWithType:UIButtonTypeCustom];
    findBtn.frame = CGRectMake(YYBODER, kHeight-40,kWidth-YYBODER*2,30);
    [findBtn addTarget:self action:@selector(wirteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [findBtn setTitle:@"     写评论" forState:UIControlStateNormal];
    [findBtn setImage:[UIImage imageNamed:@"write.png"] forState:UIControlStateNormal];
    findBtn.titleLabel.font = [UIFont systemFontOfSize:PxFont(20)];
    [findBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [self.view addSubview:findBtn];
    
    
    
}
-(void)contentBtnClick:(UIButton *)content{
   
    if (content.tag ==100) {
        companyProfilesView *profileVc =[[companyProfilesView alloc]init];
        
        [self.navigationController pushViewController:profileVc animated:YES];
    }else if (content.tag ==101) {
        productController *productVc =[[productController alloc]init];
        [self.navigationController pushViewController:productVc animated:YES];
    }else if (content.tag ==102) {
        businessController *businessVc =[[businessController alloc]init];
        [self.navigationController pushViewController:businessVc animated:YES];
       }else{
           companyJOBController *jobVC =[[companyJOBController alloc]init];
           [self.navigationController pushViewController:jobVC animated:YES];

    }



}
-(void)redingBtnClick:(UIButton *)red{
    [RemindView showViewWithTitle:@"订阅成功!" location:MIDDLE];
}
-(void)wirteBtnClick:(UIButton *)write{
    YYalertView *aleartView =[[YYalertView alloc]init];
    aleartView.delegate = self;
    [aleartView showView ];

}



@end
