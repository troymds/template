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
#define YYBODER 20
@interface jobDetailsView ()<UIScrollViewDelegate,YYalertViewDelegate>
{
    UIScrollView *_bigScrollView;
    UIScrollView *_jobScrollView;
    UIScrollView *_companyScrollView;
    UIButton *_selectedBtn;
}
@end

@implementation jobDetailsView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    self.title = @"招聘详情";
    
    _selectedBtn =[[UIButton alloc]init];
    [self addChooseBtn];
    [self addScrollview];
    [self addWriteBtn];

}
-(void)addScrollview{
    
    _bigScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 94, kWidth, kHeight-94)];
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
    _jobScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-94)];
    //    _jobScrollView.contentSize = CGSizeMake(kWidth, kHeight-64);
    _jobScrollView.backgroundColor =[UIColor whiteColor];
    _jobScrollView.bounces = YES;
    [_bigScrollView addSubview:_jobScrollView];
    [self addJoblabel];
    
}
-(void)addJoblabel{
    for (int i=0; i<2; i++) {
        NSArray *titleArr =@[@"求职岗位",@"时间"];
        UILabel *timeLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, YYBODER+i%3*30, kWidth, 20)];
        timeLabel.text =titleArr[i];
        timeLabel.textAlignment=NSTextAlignmentCenter;
        [_jobScrollView addSubview:timeLabel];

    }
    UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(0, 80, kWidth, 1)];
    [_jobScrollView addSubview:lineView];
    lineView.backgroundColor =[UIColor lightGrayColor];
    
    UILabel *contentLabel =[[UILabel alloc]initWithFrame:CGRectMake(YYBODER, 90, kWidth-YYBODER*2, 300)];
    contentLabel.text =@"详情内容";
    contentLabel.textAlignment=NSTextAlignmentCenter;

    [_jobScrollView addSubview:contentLabel];
    
}
-(void)addWriteBtn{
    YYSearchButton *wirteBtn = [YYSearchButton buttonWithType:UIButtonTypeCustom];
    wirteBtn.frame = CGRectMake(20, kHeight-54,kWidth-YYBODER*2-70,44);
    [wirteBtn addTarget:self action:@selector(wirteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [wirteBtn setTitle:@"           写评论" forState:UIControlStateNormal];
    [wirteBtn setImage:[UIImage imageNamed:@"nav_code.png"] forState:UIControlStateNormal];
    wirteBtn.titleLabel.font = [UIFont systemFontOfSize:PxFont(20)];
    [wirteBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [self.view addSubview:wirteBtn];
    
    YYSearchButton *collectBtn = [YYSearchButton buttonWithType:UIButtonTypeCustom];
    collectBtn.frame = CGRectMake(wirteBtn.frame.size.width+30, kHeight-54,60,44);
    [collectBtn addTarget:self action:@selector(wirteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
    collectBtn.titleLabel.font = [UIFont systemFontOfSize:PxFont(20)];
    [collectBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [self.view addSubview:collectBtn];
    
    
    
}

-(void)addCompanyScrollView{
    _companyScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(kWidth, 0, kWidth, kHeight-94)];
    _bigScrollView.backgroundColor =[UIColor whiteColor];
    _companyScrollView.bounces = YES;
    [_bigScrollView addSubview:_companyScrollView];
    
}

-(void)addChooseBtn{
    for (int i=0; i<2; i++) {
        NSArray *titleArr =@[@"职位详情",@"企业简介"];
        UIButton *chooseBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:chooseBtn];
        
        [chooseBtn setTitleColor:HexRGB(0x808080) forState:UIControlStateNormal];
        [chooseBtn setTitleColor:HexRGB(0x069dd4) forState:UIControlStateSelected];
        chooseBtn.frame =CGRectMake(20+i%3*((kWidth-20)/2), 64, (kWidth-20)/2, 30);
        [chooseBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        [chooseBtn setImage:[UIImage imageNamed:@"finish.png"] forState:UIControlStateNormal];
        [chooseBtn setImage:[UIImage imageNamed:@"finish1.png"] forState:UIControlStateSelected];
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
