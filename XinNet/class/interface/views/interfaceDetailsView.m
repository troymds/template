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
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithSearch:@"nav_code.png" highlightedSearch:@"vav_code_pre.png" target:(self) action:@selector(collectItem)];

    [self addheader];
    [self addWriteBtn];
}
-(void)collectItem{
    
}
-(void)addheader{
    _backScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, YYBODER, kWidth, kHeight)];
    _backScrollView.userInteractionEnabled=YES;
    _backScrollView.backgroundColor=HexRGB(0xe9f1f6);
    [self.view addSubview:_backScrollView];
    _backScrollView.bounces = NO;
    _backScrollView.showsVerticalScrollIndicator = NO;
    _backScrollView.showsHorizontalScrollIndicator = NO;
    
   UIImageView* hearImage =[[UIImageView alloc]init];
    hearImage.frame =CGRectMake(YYBODER,5, 60, 60);
    hearImage.userInteractionEnabled = YES;
    [_backScrollView addSubview:hearImage];
    hearImage.image =[UIImage imageNamed:@"nav_code"];
    
   UILabel *nameLable =[[UILabel alloc]init];
    nameLable.text = @"展会标题";
    nameLable.backgroundColor =[UIColor clearColor];
    nameLable.font =[UIFont systemFontOfSize:PxFont(22)];
    nameLable.frame=CGRectMake(90, 0, 100, 30 );
    [_backScrollView addSubview:nameLable];
    nameLable.textColor =HexRGB(0x3a3a3a);
    
    UILabel *timeLabel =[[UILabel alloc]init];
    timeLabel.text = @"展会时间";
    timeLabel.backgroundColor =[UIColor clearColor];
    timeLabel.font =[UIFont systemFontOfSize:PxFont(18)];
    timeLabel.frame=CGRectMake(90, 25, 100, 30 );
    timeLabel.textColor = HexRGB(0x808080);
    [_backScrollView addSubview:timeLabel];
    
    UILabel *addLabel =[[UILabel alloc]init];
    addLabel.text = @"来源";
    addLabel.backgroundColor =[UIColor clearColor];
    addLabel.font =[UIFont systemFontOfSize:PxFont(18)];
    addLabel.frame=CGRectMake(90, 50, 60, 30 );

    [_backScrollView addSubview:addLabel];
    addLabel.textColor =HexRGB(0x808080);

    UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(0, 85, kWidth, 1)];
    [_backScrollView addSubview:lineView];
    lineView.backgroundColor =[UIColor lightGrayColor];
    
    UILabel *contentLabel =[[UILabel alloc]initWithFrame:CGRectMake(YYBODER, 90, kWidth-YYBODER*2, 300)];
    contentLabel.text =@"详情内容";
    contentLabel.textAlignment=NSTextAlignmentCenter;
    
    [_backScrollView addSubview:contentLabel];


}
-(void)addWriteBtn{
    YYSearchButton *wirteBtn = [YYSearchButton buttonWithType:UIButtonTypeCustom];
    wirteBtn.frame = CGRectMake(20, kHeight-40,kWidth-YYBODER*2,30);
    [wirteBtn addTarget:self action:@selector(wirteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [wirteBtn setTitle:@"       写评论" forState:UIControlStateNormal];
    [wirteBtn setImage:[UIImage imageNamed:@"write.png"] forState:UIControlStateNormal];
    wirteBtn.titleLabel.font = [UIFont systemFontOfSize:PxFont(20)];
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
