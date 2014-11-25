//
//  ProtocolView.h
//  PEM
//
//  Created by Tianj on 14/11/22.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  protocolViewDelegate <NSObject>

@optional

- (void)btnClicked:(UIButton *)btn;

@end

@interface ProtocolView : UIView<UIScrollViewDelegate,UIWebViewDelegate>

@property (nonatomic,strong) UIScrollView *bgScrollView;
@property (nonatomic,strong) UIWebView *protocolWebView;
@property (nonatomic,weak) id <protocolViewDelegate>delegate;

- (void)showProtocolView;

- (void)dismiss;

@end
