//
//  productDetailsView.m
//  NewView
//
//  Created by YY on 14-11-18.
//  Copyright (c) 2014年 ___普而摩___. All rights reserved.
//

#import "productDetailsView.h"
#import "YYSearchButton.h"
#import "CommentController.h"

#import "productDetailModel.h"
#import "productDetailTool.h"
#define YYBODER 16
@interface productDetailsView ()<UIWebViewDelegate>
{
    productDetailModel *prodModel;
    UIScrollView *_backScrollView;
    UIWebView *_proWebView;
    UIView *line;//背景线条
}
@end

@implementation productDetailsView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"产品详情";
    self.view.backgroundColor =HexRGB(0xe9f1f6);
    [self addLoadStatus];
    [self addMBprogressView];
}
#pragma  mark ------显示指示器
-(void)addMBprogressView{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    
    
}
#pragma mark ---加载数据
-(void)addLoadStatus{
    [productDetailTool statusesWithSuccess:^(NSArray *statues) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        NSDictionary *dict =[statues objectAtIndex:0];
        prodModel =[[productDetailModel alloc]init];
        prodModel.wapUrl =[dict objectForKey:@"wapUrl"];
        prodModel.cover =[dict objectForKey:@"cover"];
        prodModel.name =[dict objectForKey:@"name"];
        prodModel.price =[dict objectForKey:@"price"];
        prodModel.old_price =[dict objectForKey:@"old_price"];
        [self addImageView];

    } product_ID:_productIndex failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    }];
}
#pragma mark webViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
  float  webheight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    line.frame =CGRectMake(YYBODER-1, 120, kWidth-YYBODER*2, 241+webheight);

    _proWebView.frame = CGRectMake(1, 200, kWidth-YYBODER*2-2, webheight);
    
    _backScrollView.contentSize = CGSizeMake(kWidth-YYBODER*2,webheight+350);
    
    
}
#pragma mark---添加UI
-(void)addImageView{
    _backScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 70, kWidth, kHeight-64)];
    _backScrollView.userInteractionEnabled=YES;
    _backScrollView.backgroundColor=HexRGB(0xededed);
    [self.view addSubview:_backScrollView];
    _backScrollView.bounces = NO;
    _backScrollView.showsVerticalScrollIndicator = NO;
    _backScrollView.showsHorizontalScrollIndicator = NO;

    

    
    UIImageView *headerImage =[[UIImageView alloc]initWithFrame:CGRectMake(YYBODER, 0, kWidth-YYBODER*2, 100)];
    headerImage.backgroundColor =[UIColor purpleColor];
    [headerImage setImageWithURL:[NSURL URLWithString:prodModel.cover] placeholderImage:placeHoderImage3];
    [_backScrollView addSubview:headerImage];
    
    line =[[UIView alloc]initWithFrame:CGRectMake(YYBODER-1, 120, kWidth-YYBODER*2, 241)];
    line.backgroundColor =HexRGB(0xe6e3e4);
    [_backScrollView addSubview:line];
    
    _proWebView = [[UIWebView alloc]initWithFrame:CGRectMake(1, 200, kWidth-YYBODER*2-2, 40)];
    
    [_proWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:prodModel.wapUrl]]];
    _proWebView.userInteractionEnabled = NO;
    _proWebView.delegate =self;
    
    [line addSubview:_proWebView];

    for (int i=0; i<5; i++) {
        NSArray *titleArr =@[[NSString stringWithFormat:@"   产品名称:%@",prodModel.name],[NSString stringWithFormat:@"   现价:%@",prodModel.price],[NSString stringWithFormat:@"   原价:%@",prodModel.old_price],[NSString stringWithFormat:@"   所属企业:%@",prodModel.name],@"   产品简介:"];
        UILabel *contentLable=[[UILabel alloc]initWithFrame:CGRectMake(1, 1+i%5*41, kWidth-YYBODER*2-2, 40)];
        [line addSubview:contentLable];
        contentLable.text =titleArr[i];
        contentLable.backgroundColor =[UIColor whiteColor];
        contentLable.numberOfLines = 0;
        contentLable.font =[UIFont systemFontOfSize:PxFont(20)];
    }
    
    
    YYSearchButton *findBtn = [YYSearchButton buttonWithType:UIButtonTypeCustom];
    findBtn.frame = CGRectMake(20, kHeight-40,kWidth-YYBODER*2,30);
    [findBtn addTarget:self action:@selector(wirteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [findBtn setTitle:@"      写评论" forState:UIControlStateNormal];
    [findBtn setImage:[UIImage imageNamed:@"write.png"] forState:UIControlStateNormal];
    findBtn.titleLabel.font = [UIFont systemFontOfSize:PxFont(20)];
    [findBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [self.view addSubview:findBtn];
    
    
    
}
-(void)wirteBtnClick:(UIButton *)write{
    CommentController *ctl = [[CommentController alloc] init];
    ctl.entityID = _productIndex;
    [self.navigationController pushViewController:ctl animated:YES];
}


@end
