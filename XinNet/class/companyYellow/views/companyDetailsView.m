//
//  companyDetailsView.m
//  NewView
//
//  Created by YY on 14-11-18.
//  Copyright (c) 2014年 ___普而摩___. All rights reserved.
//

#import "companyDetailsView.h"
#import "YYSearchButton.h"
#import "YYalertView.h"
#import "RemindView.h"

#import "companyProfilesView.h"
#import "productController.h"
#import "businessController.h"
#import "companyJOBController.h"
#define YYBODER 20
@interface companyDetailsView ()<YYalertViewDelegate>

@end

@implementation companyDetailsView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"企业详情";

    self.view.backgroundColor =[UIColor whiteColor];
    [self addImageView];

}
-(void)addImageView{
    UIImageView *headerImage =[[UIImageView alloc]initWithFrame:CGRectMake(YYBODER, 70, kWidth-YYBODER*2, 100)];
    headerImage.backgroundColor =[UIColor purpleColor];
    [self.view addSubview:headerImage];
    
    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(YYBODER-1, 179, kWidth-YYBODER*2, kHeight-502)];
    line.backgroundColor =[UIColor lightGrayColor];
    [self.view addSubview:line];
    
    
    for (int i=0; i<4; i++) {
        NSArray *titleArr =@[@"    公司名称:",@"    联系人:",@"    联系方式:",@"    公司地址:"];
        UILabel *contentLable=[[UILabel alloc]initWithFrame:CGRectMake(1, 1+i%4*41, kWidth-YYBODER*2-2, 40)];
        [line addSubview:contentLable];
        contentLable.text =titleArr[i];
        contentLable.backgroundColor =[UIColor whiteColor];
        contentLable.numberOfLines = 0;
        contentLable.font =[UIFont systemFontOfSize:18];

    }
    for (int t=0; t<2; t++) {
        NSArray *titleArr =@[@"收藏",@"订阅"];
        YYSearchButton * collectionBtn =[YYSearchButton buttonWithType:UIButtonTypeCustom];
        collectionBtn.frame =CGRectMake((kWidth-150)+t%3*50, 12,40, 20);
        [collectionBtn setTitle:titleArr[t] forState:UIControlStateNormal];
        [collectionBtn addTarget:self action:@selector(redingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [line addSubview:collectionBtn];
    }
   
    
    UIView *line1 =[[UIView alloc]initWithFrame:CGRectMake(YYBODER-1, 350, kWidth-YYBODER*2, kHeight-502)];
    line1.backgroundColor =[UIColor lightGrayColor];
    [self.view addSubview:line1];
    
    for (int l=0; l<4; l++) {
        NSArray *titleArr1 =@[@"企业简介:",@"产品管理:",@"供求商机:",@"企业招聘:"];
        UIButton *contentLable1=[UIButton buttonWithType:UIButtonTypeCustom];
        contentLable1.frame = CGRectMake(1, 1+l%4*41, kWidth-YYBODER*2-2, 40);
        [line1 addSubview:contentLable1];
        [contentLable1 setImage:[UIImage imageNamed:@"nav_code"] forState:UIControlStateNormal];
        contentLable1.imageEdgeInsets = UIEdgeInsetsMake(0, 270, 0, 10);
        contentLable1.titleEdgeInsets =UIEdgeInsetsMake(0, 0, 0, 235);
        [contentLable1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [contentLable1 setTitle:titleArr1[l] forState:UIControlStateNormal];
        contentLable1.backgroundColor =[UIColor whiteColor];
        contentLable1.titleLabel.font =[UIFont systemFontOfSize:18];
        [contentLable1 addTarget:self action:@selector(contentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        contentLable1.tag = 100+l;
    }

    
    
    YYSearchButton *findBtn = [YYSearchButton buttonWithType:UIButtonTypeCustom];
    findBtn.frame = CGRectMake(20, kHeight-54,kWidth-YYBODER*2,44);
    [findBtn addTarget:self action:@selector(wirteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [findBtn setTitle:@"           写评论" forState:UIControlStateNormal];
    [findBtn setImage:[UIImage imageNamed:@"nav_code.png"] forState:UIControlStateNormal];
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
