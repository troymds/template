//
//  DemandDetailController.m
//  XinNet
//
//  Created by Tianj on 14/11/23.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "DemandDetailController.h"
#import "PublishController.h"

@interface DemandDetailController ()
{
    UILabel *titleLabel;//标题
    UILabel *dateLabel;//日期
    UILabel *numLabel;//数量
    UIView *detailView;//求购详情
}
@end

@implementation DemandDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HexRGB(0xededed);
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout  = UIRectEdgeNone;
    }
    self.title = @"求购详情";

    // Do any additional setup after loading the view.
    
    [self addRightNavButton];
    
    [self addView];
    
    [self loadData];
}

- (void)addView
{
    CGFloat y = 0;
    //标题
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,y, kWidth,30)];
    titleLabel.textColor = HexRGB(0x3a3a3a);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    //时间
    y+=titleLabel.frame.size.height+10;
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(40,y, kWidth/2-40,15)];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.font = [UIFont systemFontOfSize:11];
    dateLabel.textColor = HexRGB(0x808080);
    [self.view addSubview:dateLabel];
    
    numLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/2+40,y, kWidth/2-40,15)];
    numLabel.backgroundColor = [UIColor clearColor];
    numLabel.font = [UIFont systemFontOfSize:11];
    numLabel.textColor = HexRGB(0x808080);
    [self.view addSubview:numLabel];
}

//添加右导航按钮
- (void)addRightNavButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0,53, 25);
    [button setTitle:@"编辑" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBarButtonDown) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

//右导航按钮点击
- (void)rightBarButtonDown
{
    PublishController *pc = [[PublishController alloc] init];
    pc.title = @"编辑";
    pc.isPublish =NO;
    [self.navigationController pushViewController:pc animated:YES];
}

//加载数据
- (void)loadData
{
    titleLabel.text = @"标题";
    dateLabel.text = @"时间 2014-11-24";
    numLabel.text = @"数量 2000";
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
