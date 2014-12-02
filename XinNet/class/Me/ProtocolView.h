//
//  ProtocolView.h
//  PEM
//
//  Created by Tianj on 14/11/22.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProtocolView : UIView<UIScrollViewDelegate,UIWebViewDelegate>

@property (nonatomic,strong) UIScrollView *bgScrollView;
@property (nonatomic,strong) UIWebView *protocolWebView;

- (id)initWithUrl:(NSString *)url;

- (void)showProtocolView;

- (void)dismiss;

@end
