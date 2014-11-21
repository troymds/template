//
//  YYalertView.h
//  XinNet
//
//  Created by YY on 14-11-18.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYSearchButton.h"
#define FIND_TYPE 2001
#define REGIST_TYPE 2002
#define USERNAME_TYPE 5000

@protocol YYalertViewDelegate <NSObject>

@optional

- (void)btnDown:(UIButton *)btn;

- (void)tapDown;

@end

@interface YYalertView : UIView<UITextFieldDelegate>
{
    UIImageView *bgView;
    YYSearchButton *findBtn;
    YYSearchButton *registerBtn;
    UITapGestureRecognizer *tap;
    UITapGestureRecognizer *tap1;
    UIView *line1;
    UIView *line2;
}




@property (nonatomic,strong) UITextView *userField;
//@property (nonatomic,strong) UITextField *passwordField;

@property (nonatomic,weak) id<YYalertViewDelegate> delegate;


- (void)showView;

- (void)dismissView;



@end
