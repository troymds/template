//
//  DemandView.m
//  XinNet
//
//  Created by tianj on 14-11-20.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "DemandView.h"
#import "DemandListView.h"
#import "RemindView.h"


@interface DemandView ()<UITextFieldDelegate>
{
    UILabel *titleLabel;
    UIButton *sureBtn;
    
    UIView *bgView;
    UIWindow *secondWindow;
    UITapGestureRecognizer *tap;
}
@end

@implementation DemandView

- (id)initWithTitle:(NSString *)title
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, kWidth-80, 200);
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width,40)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = title;
        [self addSubview:titleLabel];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,39,self.frame.size.width, 1)];
        line.backgroundColor = HexRGB(0xd5d5d5);
        [self addSubview:line];
        
        _titleListView = [[DemandListView alloc] initWithFrame:CGRectMake(0,40,self.frame.size.width,40)];
        _titleListView.textField.delegate = self;
        [_titleListView setTitle:@"标题"];
        [self addSubview:_titleListView];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0,79,self.frame.size.width, 1)];
        line1.backgroundColor = HexRGB(0xd5d5d5);
        [self addSubview:line1];

        
        _numListView = [[DemandListView alloc] initWithFrame:CGRectMake(0,80,self.frame.size.width,40)];
        _numListView.textField.delegate = self;
        [_numListView setTitle:@"数量"];
        [self addSubview:_numListView];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0,119,self.frame.size.width, 1)];
        line2.backgroundColor = HexRGB(0xd5d5d5);
        [self addSubview:line2];


        _contentListView = [[DemandListView alloc] initWithFrame:CGRectMake(0,120,self.frame.size.width,40)];
        _contentListView.textField.delegate = self;
        [_contentListView setTitle:@"内容"];
        [self addSubview:_contentListView];
        
        UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0,159,self.frame.size.width, 1)];
        line3.backgroundColor = HexRGB(0xd5d5d5);
        [self addSubview:line3];

        
        sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.frame = CGRectMake(0,160,self.frame.size.width,40);
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(btnDown) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sureBtn];
        
        bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.4;
        
        
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDown)];
        [bgView addGestureRecognizer:tap];

    }
    return self;
}

- (void)tapDown
{
    [self dismiss];
}

- (void)btnDown
{
    if ([self check]) {
        //开始发布数据
        NSLog(@"发布数据");
    }
}

- (BOOL)check
{
    if (_titleListView.textField.text.length==0) {
        [RemindView showViewWithTitle:@"请输入标题" location:MIDDLE];
        return NO;
    }
    if (_numListView.textField.text.length==0) {
        [RemindView showViewWithTitle:@"请输入数量" location:MIDDLE];
        return NO;
    }
    if (_contentListView.textField.text.length == 0) {
        [RemindView showViewWithTitle:@"请输入内容" location:MIDDLE];
        return NO;
    }
    return YES;
}

- (void)show
{
    secondWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    secondWindow.windowLevel = UIWindowLevelStatusBar;
    [secondWindow addSubview:bgView];
    [secondWindow addSubview:self];
    self.center = secondWindow.center;
    [secondWindow makeKeyAndVisible];
}


- (void)dismiss
{
    [bgView removeFromSuperview];
    secondWindow = nil;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
