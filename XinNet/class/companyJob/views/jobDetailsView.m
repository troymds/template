//
//  jobDetailsView.m
//  XinNet
//
//  Created by YY on 14-11-20.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "jobDetailsView.h"
#import "YYSearchButton.h"
#import "YYalertView.h"
#define YYBODER 16
@interface jobDetailsView ()<UIScrollViewDelegate,YYalertViewDelegate>
{
    UIScrollView *_bigScrollView;
    UIView *_jobScrollView;
    UIScrollView *_companyScrollView;
    UIButton *_selectedBtn;
}
@end

@implementation jobDetailsView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =HexRGB(0xe9f1f6);
    self.title = @"招聘详情";
    
    _selectedBtn =[[UIButton alloc]init];
    [self addChooseBtn];
    [self addScrollview];
    [self addWriteBtn];

}
-(void)addScrollview{
    
    _bigScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 116, kWidth, kHeight-94)];
    _bigScrollView.contentSize = CGSizeMake(kWidth*2, kHeight-64);
    _bigScrollView.backgroundColor =[UIColor whiteColor];
    _bigScrollView.delegate = self;
    _bigScrollView.bounces = YES;
    _bigScrollView.showsHorizontalScrollIndicator = NO;
    _bigScrollView.showsVerticalScrollIndicator = NO;
    
    _bigScrollView.pagingEnabled = YES;
    [self.view addSubview:_bigScrollView];
    _bigScrollView.tag =9999;
    [self addCompanyScrollView];
    [self addJobScrollView];
    
    
}
-(void)addJobScrollView{
    _jobScrollView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-94)];
    _jobScrollView.backgroundColor =HexRGB(0xe9f1f6);
    [_bigScrollView addSubview:_jobScrollView];
    [self addJoblabel];
    
}
-(void)addJoblabel{
    
    UIImageView *headerImage =[[UIImageView alloc]initWithFrame:CGRectMake(YYBODER, 10, kWidth-YYBODER*2, 100)];
    [_jobScrollView addSubview:headerImage];
    headerImage.backgroundColor =[UIColor lightGrayColor];
    
    UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(YYBODER, 120, kWidth-YYBODER*2+2, 81)];
    [_jobScrollView addSubview:lineView];
    lineView.backgroundColor =HexRGB(0xe6e3e4);
    
    for (int i=0; i<2; i++) {
        NSArray *titleArr =@[@"   求职岗位:",@"   时间:"];
        UILabel *timeLabel =[[UILabel alloc]initWithFrame:CGRectMake(YYBODER+1, 121+i%3*40, kWidth-YYBODER*2, 39)];
        timeLabel.text =titleArr[i];
        timeLabel.backgroundColor =[UIColor whiteColor];
        [_jobScrollView addSubview:timeLabel];

    }
   
    
//    UILabel *contentLabel =[[UILabel alloc]initWithFrame:CGRectMake(YYBODER, 90, kWidth-YYBODER*2, 300)];
//    contentLabel.text =@"详情内容";
//    contentLabel.textAlignment=NSTextAlignmentCenter;
//
//    [_jobScrollView addSubview:contentLabel];
    
}
-(void)addWriteBtn{
    YYSearchButton *wirteBtn = [YYSearchButton buttonWithType:UIButtonTypeCustom];
    wirteBtn.frame = CGRectMake(YYBODER, kHeight-40,kWidth-YYBODER*2,30);
    [wirteBtn addTarget:self action:@selector(wirteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [wirteBtn setTitle:@"     写评论" forState:UIControlStateNormal];
    [wirteBtn setImage:[UIImage imageNamed:@"write.png"] forState:UIControlStateNormal];
    wirteBtn.titleLabel.font = [UIFont systemFontOfSize:PxFont(20)];
    [wirteBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [self.view addSubview:wirteBtn];
    
//    YYSearchButton *collectBtn = [YYSearchButton buttonWithType:UIButtonTypeCustom];
//    collectBtn.frame = CGRectMake(wirteBtn.frame.size.width+30, kHeight-54,60,44);
//    [collectBtn addTarget:self action:@selector(wirteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
//    collectBtn.titleLabel.font = [UIFont systemFontOfSize:PxFont(20)];
//    [collectBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
//    [self.view addSubview:collectBtn];
//    
    
    
}

-(void)addCompanyScrollView{
    _companyScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(kWidth, 0, kWidth, kHeight-94)];
    _bigScrollView.backgroundColor =HexRGB(0xe9f1f6);
    _companyScrollView.bounces = YES;
    [_bigScrollView addSubview:_companyScrollView];
    [self addCompanylabel];
    
}

-(void)addCompanylabel{
    
    UIImageView *headerImage =[[UIImageView alloc]initWithFrame:CGRectMake(YYBODER, 10, kWidth-YYBODER*2, 100)];
    [_companyScrollView addSubview:headerImage];
    headerImage.backgroundColor =[UIColor lightGrayColor];
    
    UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(YYBODER, 120, kWidth-YYBODER*2+2, 81)];
    [_companyScrollView addSubview:lineView];
    lineView.backgroundColor =HexRGB(0xe6e3e4);
    
    for (int i=0; i<2; i++) {
        NSArray *titleArr =@[@"   公司名称:",@"   公司简介:"];
        UILabel *timeLabel =[[UILabel alloc]initWithFrame:CGRectMake(YYBODER+1, 121+i%3*40, kWidth-YYBODER*2, 39)];
        timeLabel.text =titleArr[i];
        timeLabel.backgroundColor =[UIColor whiteColor];
        [_companyScrollView addSubview:timeLabel];
        
    }
}

-(void)addChooseBtn{
    for (int i=0; i<2; i++) {
        NSArray *titleArr =@[@"职位详情",@"企业简介"];
        UIButton *chooseBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:chooseBtn];
        
        [chooseBtn setTitleColor:HexRGB(0x808080) forState:UIControlStateNormal];
        [chooseBtn setTitleColor:HexRGB(0x069dd4) forState:UIControlStateSelected];
        chooseBtn.frame =CGRectMake(20+i%3*((kWidth-40)/2), 75, (kWidth-40)/2, 40);
        [chooseBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        [chooseBtn setBackgroundImage:[UIImage imageNamed:@"finish.png"] forState:UIControlStateNormal];
        [chooseBtn setBackgroundImage:[UIImage imageNamed:@"finish1.png"] forState:UIControlStateSelected];
        [chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        chooseBtn.tag = 200+i;
        if (chooseBtn.tag == 200) {
            chooseBtn.selected = YES;
            _selectedBtn=chooseBtn;
        }
    }
}
-(void)wirteBtnClick:(UIButton *)write{
    YYalertView *aleartView =[[YYalertView alloc]init];
    aleartView.delegate = self;
    [aleartView showView ];
    
}
-(void)chooseBtnClick:(UIButton *)choose{
    _selectedBtn.selected = NO;
    choose.selected =YES;
    _selectedBtn = choose;
    
    if (choose.tag == 200)
    {
        [_bigScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else
    {
        
        [_bigScrollView setContentOffset:CGPointMake(kWidth, 0) animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag ==9999) {
        if (scrollView.contentOffset.x <=0) {
            scrollView.contentOffset = CGPointMake(0, 0);
        }
        
        if (scrollView.contentOffset.x >= kWidth) {
            scrollView.contentOffset = CGPointMake(kWidth, 0);
        }
       if(scrollView.contentOffset.x==0){
            for (UIView *subView in self.view.subviews) {
                if ([subView isKindOfClass:[UIButton class]]) {
                    UIButton *btn =(UIButton *)subView;
                    if (btn.tag ==200) {
                        _selectedBtn=btn;
                        _selectedBtn.selected=YES;
                    }else{
                        btn.selected = NO;
                    }
                    
                }
            }
       }else if(scrollView.contentOffset.x==kWidth){
           for (UIView *subView in self.view.subviews) {
               if ([subView isKindOfClass:[UIButton class]]) {
                   UIButton *btn =(UIButton *)subView;
                   if (btn.tag ==201) {
                       _selectedBtn=btn;
                       _selectedBtn.selected=YES;
                   }else{
                       btn.selected = NO;
                   }
                   
               }
           }
       }


    }
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
