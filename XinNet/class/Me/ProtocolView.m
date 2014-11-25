//
//  ProtocolView.m
//  PEM
//
//  Created by Tianj on 14/11/22.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "ProtocolView.h"

@implementation ProtocolView


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _bgScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgScrollView.delegate = self;
        [self addSubview:_bgScrollView];
        
        _protocolWebView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _protocolWebView.delegate = self;
        [_bgScrollView addSubview:_protocolWebView];
        _protocolWebView.scrollView.scrollEnabled = NO;
        [_bgScrollView setContentSize:CGSizeMake(kWidth,3000)];
        
    }
    return self;
}

- (void)showProtocolView
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"protocol" ofType:@"html"];
    NSURL *url = [NSURL URLWithString:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_protocolWebView loadRequest:request];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGFloat sizeHeight =  [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    [_bgScrollView setContentSize:CGSizeMake(kWidth, sizeHeight+30+35)];
    [_protocolWebView setFrame:CGRectMake(0, 0, kWidth,sizeHeight+30)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0,sizeHeight+30,kWidth,35);
    [button setTitle:@"同 意" forState:UIControlStateNormal];
    [button setTitleColor:HexRGB(0x18b0e7) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
    [_bgScrollView addSubview:button];
}

- (void)btnDown:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(btnClicked:)]) {
        [self.delegate btnClicked:btn];
    }
    [self dismiss];
}

- (void)dismiss
{
    [self removeFromSuperview];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
