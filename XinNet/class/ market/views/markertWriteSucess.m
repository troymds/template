//
//  markertWriteSucess.m
//  XinNet
//
//  Created by YY on 14-11-19.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "markertWriteSucess.h"
#import "YYSearchButton.h"
#define YYBODER 20
@interface markertWriteSucess ()

@end

@implementation markertWriteSucess

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"详情";
    self.view.backgroundColor =[UIColor whiteColor];
    [self addImageView];

}

-(void)addImageView{
    UIImageView *headerImage =[[UIImageView alloc]initWithFrame:CGRectMake(YYBODER, 70, kWidth-YYBODER*2, 100)];
    headerImage.backgroundColor =[UIColor purpleColor];
    [self.view addSubview:headerImage];
    
    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(YYBODER-1, 179, kWidth-YYBODER*2, kHeight-250)];
    line.backgroundColor =[UIColor lightGrayColor];
    [self.view addSubview:line];
    
    for (int i=0; i<5; i++) {
        NSArray *titleArr =@[@"   产品名称:",@"   现价:",@"   原价:",@"   所属企业:",@"   产品简介:"];
        UILabel *contentLable=[[UILabel alloc]initWithFrame:CGRectMake(1, 1+i%5*41, kWidth-YYBODER*2-2, 40)];
        [line addSubview:contentLable];
        if (i==4) {
            contentLable.frame =CGRectMake(1, 1+i%5*41, kWidth-YYBODER*2-2, 251);
            contentLable.numberOfLines = 0;
        }
        contentLable.text =titleArr[i];
        contentLable.backgroundColor =[UIColor whiteColor];
        contentLable.numberOfLines = 0;
        contentLable.font =[UIFont systemFontOfSize:18];
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
-(void)wirteBtnClick:(UIButton *)write{
    
}

@end
