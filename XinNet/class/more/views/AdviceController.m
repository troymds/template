//
//  AdviceController.m
//  XinNet
//
//  Created by tianj on 14-11-19.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "AdviceController.h"

@interface AdviceController ()<UITextViewDelegate>
{
    UITextView *_textView;
}
@end

@implementation AdviceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.title = @"意见反馈";

    [self addView];
    
}

- (void)addView
{
    CGFloat leftDistance = 10;//左边距
    CGFloat topDistance = 10;//顶边距
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(leftDistance,topDistance,kWidth-leftDistance*2,150)];
    _textView.layer.borderColor = HexRGB(0xd5d5d5).CGColor;
    _textView.layer.borderWidth = 1.0f;
    _textView.delegate = self;
    [self.view addSubview:_textView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(kWidth-leftDistance-60,topDistance+_textView.frame.size.height,60,40);
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnDown) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)btnDown
{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textView resignFirstResponder];
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
