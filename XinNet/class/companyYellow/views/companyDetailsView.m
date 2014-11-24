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
    NSMutableArray *_companyDetailArray;
}
@end

@implementation companyDetailsView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"企业详情";

    self.view.backgroundColor =HexRGB(0xe9f1f6);
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithSearch:@"nav_code.png" highlightedSearch:@"vav_code_pre.png" target:(self) action:@selector(sharSdk:)];
    _companyDetailArray =[[NSMutableArray alloc]init];
    
    [self addLoadStatus];
    

}
#pragma mark---加载数据
-(void)addLoadStatus{
    [companyDetailTool CompanyStatusesWithSuccesscategory:^(NSArray *statues) {
        [_companyDetailArray addObjectsFromArray:statues];

        [self addImageView];
    } company_id:_companyDetailIndex CompanyFailure:^(NSError *error) {
        
    }];
}
-(void)sharSdk:(UIButton *)share{
    
}
-(void)addImageView{

    companyDetailsModel *companyModel =[_companyDetailArray objectAtIndex:0];

    UIImageView *headerImage =[[UIImageView alloc]initWithFrame:CGRectMake(YYBODER, 70, kWidth-YYBODER*2, 100)];
    [headerImage setImageWithURL:[NSURL URLWithString:companyModel.logo] placeholderImage:placeHoderImage];
    [self.view addSubview:headerImage];
    
    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(YYBODER-1, 179, kWidth-YYBODER*2, 165)];
    line.backgroundColor =HexRGB(0xe6e3e4);
    [self.view addSubview:line];
    
    
    for (int i=0; i<4; i++) {
       NSArray *titleArr= @[[NSString stringWithFormat:@"  公司名称:%@",companyModel.name],[NSString stringWithFormat:@"   联系人:%@次",companyModel.name],[NSString stringWithFormat:@"   联系方式:%@",companyModel.tel],[NSString stringWithFormat:@"   公司地址:%@次",companyModel.contact]];
        
        
        
        UILabel *contentLable=[[UILabel alloc]initWithFrame:CGRectMake(1, 1+i%4*41, kWidth-YYBODER*2-2, 40)];
        [line addSubview:contentLable];
        contentLable.text =titleArr[i];
        contentLable.backgroundColor =[UIColor whiteColor];
        contentLable.numberOfLines = 0;
        contentLable.font =[UIFont systemFontOfSize:PxFont(18)];
        
        

    }
    for (int t=0; t<2; t++) {
        NSArray *titleArr =@[@"收藏",@"订阅"];
        UIButton * collectionBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        collectionBtn.frame =CGRectMake((kWidth-150)+t%3*50, 10,40, 50);
        [collectionBtn setTitle:titleArr[t] forState:UIControlStateNormal];
        [collectionBtn addTarget:self action:@selector(redingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        collectionBtn.imageEdgeInsets =UIEdgeInsetsMake(-10, 0, 30, 0);
        [collectionBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"collect%d",t]] forState:UIControlStateNormal];
        [line addSubview:collectionBtn];
        collectionBtn.backgroundColor =[UIColor clearColor];
        [collectionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        collectionBtn.titleLabel.font =[UIFont systemFontOfSize:PxFont(13)];
        collectionBtn.titleEdgeInsets=UIEdgeInsetsMake(0, -35, 0, 0);
        
        UIImageView *failImg =[[UIImageView alloc]initWithFrame:CGRectMake((kWidth-150)+t%3*50, 43,60, 30 )];
        [line addSubview:failImg];
        failImg.backgroundColor =[UIColor whiteColor];
        failImg.userInteractionEnabled = YES;
    
    
    
    }
   
    
    UIView *line1 =[[UIView alloc]initWithFrame:CGRectMake(YYBODER-1, 350, kWidth-YYBODER*2, 165)];
    line1.backgroundColor =HexRGB(0xe6e3e4);
    [self.view addSubview:line1];
    
    for (int l=0; l<4; l++) {
        NSArray *titleArr1 =@[@"企业简介:",@"产品管理:",@"供求商机:",@"企业招聘:"];
        UIButton *contentLable1=[UIButton buttonWithType:UIButtonTypeCustom];
        contentLable1.frame = CGRectMake(1, 1+l%4*41, kWidth-YYBODER*2-2, 40);
        [line1 addSubview:contentLable1];
        [contentLable1 setImage:[UIImage imageNamed:@"reture_left.png"] forState:UIControlStateNormal];
        contentLable1.imageEdgeInsets = UIEdgeInsetsMake(0, 250, 0, 10);
        contentLable1.titleEdgeInsets =UIEdgeInsetsMake(0, -20, 0, 215);
        [contentLable1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [contentLable1 setTitle:titleArr1[l] forState:UIControlStateNormal];
        contentLable1.backgroundColor =[UIColor whiteColor];
        contentLable1.titleLabel.font =[UIFont systemFontOfSize:18];
        [contentLable1 addTarget:self action:@selector(contentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        contentLable1.titleLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        
        contentLable1.tag = 100+l;
    }

    
    
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
