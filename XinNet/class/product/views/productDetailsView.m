//
//  productDetailsView.m
//  NewView
//
//  Created by YY on 14-11-18.
//  Copyright (c) 2014年 ___普而摩___. All rights reserved.
//

#import "productDetailsView.h"
#import "YYSearchButton.h"
#import "RemindView.h"
#define YYBODER 16
@interface productDetailsView ()

@end

@implementation productDetailsView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"产品详情";
    self.view.backgroundColor =HexRGB(0xededed);
    [self addImageView];
    
}

-(void)addImageView{
    UIImageView *headerImage =[[UIImageView alloc]initWithFrame:CGRectMake(YYBODER, 70, kWidth-YYBODER*2, 100)];
    headerImage.backgroundColor =[UIColor purpleColor];
    [self.view addSubview:headerImage];
    
    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(YYBODER-1, 179, kWidth-YYBODER*2, kHeight-240)];
    line.backgroundColor =HexRGB(0xe6e3e4);
    [self.view addSubview:line];
    
    for (int i=0; i<5; i++) {
        NSArray *titleArr =@[@"   产品名称:",@"   现价:",@"   原价:",@"   所属企业:",@"   产品简介:"];
        UILabel *contentLable=[[UILabel alloc]initWithFrame:CGRectMake(1, 1+i%5*41, kWidth-YYBODER*2-2, 40)];
        [line addSubview:contentLable];
        if (i==4) {
            contentLable.frame =CGRectMake(1, 1+i%5*41, kWidth-YYBODER*2-2, 162);
            contentLable.numberOfLines = 0;
        }
        contentLable.text =titleArr[i];
        contentLable.backgroundColor =[UIColor whiteColor];
        contentLable.numberOfLines = 0;
        contentLable.font =[UIFont systemFontOfSize:PxFont(20)];
    }
    YYSearchButton *findBtn = [YYSearchButton buttonWithType:UIButtonTypeCustom];
    findBtn.frame = CGRectMake(20, kHeight-40,kWidth-YYBODER*2,30);
    [findBtn addTarget:self action:@selector(wirteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [findBtn setTitle:@"           写评论" forState:UIControlStateNormal];
    [findBtn setImage:[UIImage imageNamed:@"write.png"] forState:UIControlStateNormal];
    findBtn.titleLabel.font = [UIFont systemFontOfSize:PxFont(20)];
    [findBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [self.view addSubview:findBtn];
    
    
    
}
-(void)wirteBtnClick:(UIButton *)write{
    [RemindView showViewWithTitle:@"评论成功！" location:MIDDLE];
    
}


@end
