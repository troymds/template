//
//  YYalertView.m
//  XinNet
//
//  Created by YY on 14-11-18.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "YYalertView.h"
#import "markertWriteSucess.h"
#import "RemindView.h"
//#define kHeight-208  360

#define BGViewHeight 200
#define YYborder 20
@implementation YYalertView
- (id)init
{
    if (self = [super init]) {
        CGRect frame = [UIScreen mainScreen].bounds;
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        
        UIView *view = [[UIView alloc] initWithFrame:frame];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.1;
        [self addSubview:view];
//        NSLog(@"%f",kHeight);
        
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDown)];
        [view addGestureRecognizer:tap];
        
        bgView =[[UIImageView alloc] initWithFrame:CGRectMake(YYborder,kHeight, kWidth-40, BGViewHeight)];
        bgView.backgroundColor = [UIColor lightGrayColor];
        bgView.userInteractionEnabled = YES;
        [self addSubview:bgView];
        tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        [bgView addGestureRecognizer:tap1];
        
        UIView *linView =[[UIView alloc]initWithFrame:CGRectMake(1, 1, kWidth-42, BGViewHeight-2)];
        [bgView addSubview:linView];
        linView.backgroundColor =[UIColor whiteColor];
        
        
        _userField = [[UITextView alloc] initWithFrame:CGRectMake(10,40, bgView.frame.size.width-20, 120)];
        _userField.tag = USERNAME_TYPE;

        _userField.keyboardType = UIKeyboardTypeDefault;
        [bgView addSubview:_userField];
        _userField.font =[UIFont systemFontOfSize:18];
        _userField.delegate = self;
        line1 = [[UIView alloc] initWithFrame:CGRectMake(0,165,kWidth-40, 1)];
        line1.backgroundColor = [UIColor lightGrayColor];
        [bgView addSubview:line1];
        
        
        line2 = [[UIView alloc] initWithFrame:CGRectMake(0,39,kWidth-40, 1)];
        line2.backgroundColor = [UIColor lightGrayColor];
        [bgView addSubview:line2];
        
        UILabel *writeLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 10, kWidth-40, 20)];
        [bgView addSubview:writeLabel];
        writeLabel.font =[UIFont systemFontOfSize:PxFont(22)];
        writeLabel.backgroundColor =[UIColor clearColor];
        writeLabel.textAlignment=NSTextAlignmentCenter;
        writeLabel.text =@"写评论";
        
                
        findBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        findBtn.frame = CGRectMake(20, 10,30,30);
        findBtn.tag = cancleType;
        [findBtn addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchUpInside];
        [findBtn setImage:[UIImage imageNamed:@"delete_img.png"] forState:UIControlStateNormal];
        findBtn.titleLabel.font = [UIFont systemFontOfSize:PxFont(20)];
        [findBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        [bgView addSubview:findBtn];
        
        registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        registerBtn.frame = CGRectMake(kWidth-90, 10, 30, 30);
        registerBtn.tag = comformType;
        [registerBtn setImage:[UIImage imageNamed:@"sure_img.png"] forState:UIControlStateNormal];
        [registerBtn addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchUpInside];
        registerBtn.titleLabel.font = [UIFont systemFontOfSize:PxFont(20)];
        [registerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bgView addSubview:registerBtn];
        [self addSubview:bgView];
        
        [UIView animateWithDuration:0.3 animations:^{
            bgView.frame = CGRectMake(YYborder,kHeight-208,  kWidth-40,BGViewHeight);
        }];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        if ([user valueForKey:@"userName"]) {
            _userField.text = [user valueForKey:@"userName"];
            if ([user valueForKey:@"secret"]) {
            }
        }
        
    }
    return self;
}
-(void)tapDown
{
    if ([self.delegate respondsToSelector:@selector(tapDown)]) {
        [self.delegate tapDown];
    }
    
    [self dismissView];
}

- (void)tapClick
{
    for (UIView *subView in bgView.subviews) {
        if ([subView isKindOfClass:[UITextField class]]) {
            [subView  resignFirstResponder];
            CGRect frame = bgView.frame;
            [UIView animateWithDuration:0.3 animations:^{
                bgView.frame = CGRectMake(frame.origin.x,kHeight-208, frame.size.width, frame.size.height);
            }];
        }
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    CGRect frame = bgView.frame;
    if (IsIos7) {
        frame.origin.y -= kHeight-318;

    }else{
        frame.origin.y -= 220;

    }
    [UIView animateWithDuration:0.3 animations:^{
        bgView.frame = CGRectMake(frame.origin.x,frame.origin.y, frame.size.width, frame.size.height);
    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    CGRect frame = bgView.frame;
    frame.origin.y += 80;
    [UIView animateWithDuration:0.3 animations:^{
        bgView.frame = CGRectMake(frame.origin.x,frame.origin.y, frame.size.width, frame.size.height);
    }];
}

- (void)showView{
    if (bgView.frame.origin.y == kHeight) {
        [UIView animateWithDuration:0.3 animations:^{
            bgView.frame = CGRectMake(YYborder,kHeight-208,  kWidth-40,BGViewHeight);
        }];
    }
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
}

- (void)dismissView{
    [UIView animateWithDuration:0.3 animations:^{
        bgView.frame = CGRectMake(20,kHeight, kWidth-40,BGViewHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)buttonDown:(UIButton *)btn{
    if (self.delegate) {
        if (btn.tag==cancleType) {
            [self dismissView];
            
        }
        if (btn.tag == comformType) {
            [self dismissView];
            if ([self.delegate respondsToSelector:@selector(btnDown:conent:)]) {
                [self.delegate btnDown:btn conent:_userField.text];
            }
        }
        
    }
}





- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        bgView.frame = CGRectMake(YYborder,kHeight-208, kWidth-40,BGViewHeight);
    }];
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (_iPhone4) {
        CGRect frame = bgView.frame;
        [UIView animateWithDuration:0.3 animations:^{
            bgView.frame = CGRectMake(frame.origin.x,55, frame.size.width, frame.size.height);
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == USERNAME_TYPE) {
        line1.backgroundColor = HexRGB(0x666666);
    }else{
        line2.backgroundColor = HexRGB(0x666666);
    }
}

@end
