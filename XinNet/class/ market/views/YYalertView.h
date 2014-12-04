//
//  YYalertView.h
//  XinNet
//
//  Created by YY on 14-11-18.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYSearchButton.h"
#define cancleType 2001
#define comformType 2002
#define USERNAME_TYPE 5000

@protocol YYalertViewDelegate <NSObject>

@optional

- (void)btnDown:(UIButton *)btn conent:(NSString *) content;

- (void)tapDown;

@end

@interface YYalertView : UIView<UITextFieldDelegate,UITextViewDelegate>
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
