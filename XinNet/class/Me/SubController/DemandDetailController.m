//
//  DemandDetailController.m
//  XinNet
//
//  Created by Tianj on 14/11/23.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "DemandDetailController.h"
#import "PublishController.h"
#import "businessDetailsTool.h"
#import "businessDetailsModel.h"

#define YYBODERW 16
@interface DemandDetailController ()<UIWebViewDelegate>
{
    businessDetailsModel *businessModel;
    UIWebView *marketWebView;
    UIScrollView *_backScrollView;
}
@end

@implementation DemandDetailController



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addLoadStatus];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor =HexRGB(0xe9f1f6);
    self.title =@"求购详情";
    
    [self addRightBarButton];
}


//添加导航栏右侧按钮
- (void)addRightBarButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0,53, 25);
    [button setTitle:@"编辑" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBarButtonDown) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)rightBarButtonDown
{
    PublishController *pc = [[PublishController alloc] init];
    pc.title = @"编辑";
    pc.isPublish = NO;
    pc.uid = self.businessDetailIndex;
    [self.navigationController pushViewController:pc animated:YES];
}


-(void)addLoadStatus{
    [businessDetailsTool statusesWithSuccess:^(NSArray *statues) {
        NSDictionary *dict =[statues objectAtIndex:0];
        businessModel =[[businessDetailsModel alloc]init];
        businessModel.wapUrl =[dict objectForKey:@"wapUrl"];
        businessModel.title =[dict objectForKey:@"title"];
        businessModel.read_num =[dict objectForKey:@"read_num"];
        businessModel.create_time =[dict objectForKey:@"create_time"];
        
        
        
        [self addLabel];
        
    } opportunity_Id:_businessDetailIndex failure:^(NSError *error) {
        
    }];
}
//收藏
-(void)collectClick:(UIButton *)collect{
    
}
#pragma mark webViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    float  webheight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    
    marketWebView.frame = CGRectMake(1, 80, kWidth, webheight);
    
    _backScrollView.contentSize = CGSizeMake(kWidth,webheight+350);
    
    
}
-(void)addLabel{
    
    _backScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    _backScrollView.userInteractionEnabled=YES;
    _backScrollView.backgroundColor=HexRGB(0xededed);
    [self.view addSubview:_backScrollView];
    _backScrollView.bounces = NO;
    _backScrollView.showsVerticalScrollIndicator = NO;
    _backScrollView.showsHorizontalScrollIndicator = NO;
    
    UILabel *titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 10, kWidth, 20)];
    titleLabel.text =businessModel.title;
    titleLabel.font =[UIFont systemFontOfSize:PxFont(23)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor =HexRGB(0x3a3a3a);
    [_backScrollView addSubview:titleLabel];
    
    
    for (int i=0; i<2; i++) {
        NSArray *titleArr =@[[NSString stringWithFormat:@"时间:%@",businessModel.create_time],[NSString stringWithFormat:@"数量:%@",businessModel.read_num]];
        UILabel *titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(20+i%3*(kWidth/2), 50, kWidth/2-40, 20)];
        titleLabel.text =titleArr[i];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.backgroundColor =[UIColor clearColor];
        if (i==1) {
            titleLabel.textAlignment = NSTextAlignmentRight;
            
        }
        titleLabel.textColor=HexRGB(0x808080);
        titleLabel.font =[UIFont systemFontOfSize:PxFont(16)];
        [_backScrollView addSubview:titleLabel];
        
    }
    
    
    marketWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 80, kWidth, kHeight-120)];
    
    [marketWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:businessModel.wapUrl]]];
    marketWebView.userInteractionEnabled = NO;
    marketWebView.delegate =self;
    marketWebView.backgroundColor =[UIColor redColor];
    [_backScrollView addSubview:marketWebView];
    
    
    
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
