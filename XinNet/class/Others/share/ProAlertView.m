//
//  MyActionSheetView.m
//  PEM
//
//  Created by tianj on 14-9-30.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "ProAlertView.h"
#import "AdaptationSize.h"

#define alertWidth ([UIScreen mainScreen].bounds.size.width-40)

@interface ProAlertView ()
{
    UILabel *_titleLabel;
    UILabel *_messageLabel;
    UIView *bgView;
    UIView *view;
    UIWindow *secondWindow;
    NSMutableArray *_buttons;
    NSInteger _allBtnNum;
    UIButton *_oneButton;
    UIButton *_rigthButton;
    UIButton *_leftButton;
    UIView *_lineView;
}

@end


@implementation ProAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithTitle:(NSString *)title withMessage:(NSString *)message delegate:(id)delegate cancleButton:(NSString *)cancelButtonTitle otherButton:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    if (self = [super init]) {
        self.backgroundColor = HexRGB(0xffffff);
        _delegate = delegate;
        self.title = title;
        self.message = message;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HexRGB(0x3a3a3a);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.text = self.title;
        [self addSubview:_titleLabel];
        
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.numberOfLines = 0;
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.font = [UIFont systemFontOfSize:14];
        _messageLabel.text = message;
        _messageLabel.textColor = HexRGB(0x3a3a3a);
        [self addSubview:_messageLabel];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HexRGB(0xc3c3c3);
        [self addSubview:_lineView];
        
        _buttons = [[NSMutableArray alloc] init];
        NSMutableArray *otherButtons = [[NSMutableArray alloc] init];
        if(otherButtonTitles){
            [otherButtons addObject:otherButtonTitles];
            va_list list;
            va_start(list, otherButtonTitles);
            while(1){
                NSString *eachButton = va_arg(list, id);
                if(!eachButton)
                {
                    break;
                }
                [otherButtons addObject:eachButton];
            }
            va_end(list);
        }
        _allBtnNum = 0;
        if(cancelButtonTitle){
            _allBtnNum +=1;
        }
        _allBtnNum +=otherButtons.count;
        switch(_allBtnNum){
            case 0:
            {
                break;
            }
            case 1:
            {
                _oneButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [_oneButton setTitle:cancelButtonTitle?cancelButtonTitle:otherButtonTitles forState:UIControlStateNormal];
                [_oneButton setTitleColor:HexRGB(0xffffff) forState:UIControlStateNormal];
                [_oneButton setBackgroundImage:[UIImage imageNamed:@"finish.png"] forState:UIControlStateNormal];
                [_oneButton setBackgroundImage:[UIImage imageNamed:@"finish_pre.png"] forState:UIControlStateHighlighted];
                _oneButton.tag = 0;
                [_oneButton addTarget:self action:@selector(actionButtonDown:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:_oneButton];
                break;
            }
            case 2:
            {
                _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [_leftButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
                [_leftButton setTitleColor:HexRGB(0x000000) forState:UIControlStateNormal];
                [_leftButton setBackgroundImage:[UIImage imageNamed:@"action_btn.png"] forState:UIControlStateHighlighted];
                _leftButton.tag = 0;
                [_leftButton addTarget:self action:@selector(actionButtonDown:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:_leftButton];
                
                _rigthButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [_rigthButton setTitle:otherButtonTitles forState:UIControlStateNormal];
                [_rigthButton setTitleColor:HexRGB(0x000000) forState:UIControlStateNormal];
                [_rigthButton setBackgroundImage:[UIImage imageNamed:@"action_btn.png"] forState:UIControlStateHighlighted];
                _rigthButton.tag = 1;
                [_rigthButton addTarget:self action:@selector(actionButtonDown:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:_rigthButton];

                break;
            }
            default:{
                for(int i = 0;i < otherButtons.count;i++){
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [btn setTitle:[otherButtons objectAtIndex:i] forState:UIControlStateNormal];
                    [btn setTitleColor:HexRGB(0x000000) forState:UIControlStateNormal];
                    [btn setBackgroundImage:[UIImage imageNamed:@"action_btn.png"] forState:UIControlStateHighlighted];
                    btn.tag = i+1;
                    [btn addTarget:self action:@selector(actionButtonDown:) forControlEvents:UIControlEventTouchUpInside];
                    [_buttons addObject:btn];
                    [self addSubview:btn];
                }
                UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [cancelBtn setTitle:cancelButtonTitle?cancelButtonTitle:otherButtonTitles forState:UIControlStateNormal];
                [cancelBtn setTitleColor:HexRGB(0x000000) forState:UIControlStateNormal];
                [cancelBtn setBackgroundImage:[UIImage imageNamed:@"action_btn.png"] forState:UIControlStateHighlighted];
                cancelBtn.tag = 0;
                [cancelBtn addTarget:self action:@selector(actionButtonDown:) forControlEvents:UIControlEventTouchUpInside];
                [_buttons addObject:cancelBtn];
                [self addSubview:cancelBtn];
                break;
            }
        }
    }
    return self;
}

- (void)show
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    secondWindow = [[UIWindow alloc] initWithFrame:frame];
    secondWindow.windowLevel = UIWindowLevelAlert;
    
    bgView = [[UIView alloc] initWithFrame:frame];
    bgView.alpha = 0.0;
    bgView.backgroundColor = [UIColor blackColor];
    [secondWindow addSubview:bgView];
    self.center = secondWindow.center;
    [secondWindow addSubview:self];
    [secondWindow makeKeyAndVisible];
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    [UIView animateWithDuration:0.0f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self setupFrame];
        self.center = secondWindow.center;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.center = secondWindow.center;
            bgView.alpha = 0.4;
            [self roate:orientation sacle:1.1];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.center = secondWindow.center;
                [self roate:orientation sacle:1.0];
            } completion:^(BOOL finished) {
                
            }];
        }];
    }];
}

- (void)setupFrame
{
    CGSize size = [AdaptationSize getSizeFromString:self.message Font:[UIFont systemFontOfSize:14] withHight:CGFLOAT_MAX withWidth:alertWidth];
    switch (_allBtnNum) {
        case 0:
            break;
        case 1:
        {
            self.frame = CGRectMake((kWidth-alertWidth)*0.5,0, alertWidth,56+40+size.height+40+20);
            _oneButton.frame = CGRectMake(20, 56+40+size.height,alertWidth-20*2,40);
        }
            break;
        case 2:
        {
            self.frame = CGRectMake((kWidth-alertWidth)*0.5, 0, alertWidth,56+40+size.height+40);
            _leftButton.frame = CGRectMake(0,56+40+size.height,alertWidth/2,40);
            _rigthButton.frame = CGRectMake(alertWidth/2, 56+40+size.height, alertWidth/2, 40);
        }
            break;
        default:
        {
            self.frame = CGRectMake((kWidth-alertWidth)*0.5, 0, alertWidth,56+40+size.height+40*_buttons.count);
            for (int i = 0 ; i < _buttons.count; i++) {
                UIButton *btn = (UIButton *)[_buttons objectAtIndex:i];
                btn.frame = CGRectMake(0,56+40+size.height+40*i, alertWidth, 40);
            }
        }
            break;
    };
    _titleLabel.frame = CGRectMake(20, 22, alertWidth-40, 20);
    _lineView.frame = CGRectMake(10, 56,alertWidth-10*2, 1);
    _messageLabel.frame = CGRectMake(20,76,alertWidth-40,size.height);
}

- (void)rotate:(UIInterfaceOrientation) orientation
{
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        CGAffineTransform rotation = CGAffineTransformMakeRotation(3*M_PI/2);
        [self setTransform:rotation];
    }else if (orientation == UIInterfaceOrientationLandscapeRight) {
        CGAffineTransform rotation = CGAffineTransformMakeRotation(M_PI/2);
        [self setTransform:rotation];
    }else if (orientation == UIInterfaceOrientationPortrait) {
        CGAffineTransform rotation = CGAffineTransformMakeRotation(0);
        [self setTransform:rotation];
    } else if (orientation == UIDeviceOrientationPortraitUpsideDown) {
        CGAffineTransform rotation = CGAffineTransformMakeRotation(M_PI);
        [self setTransform:rotation];
    }
}


- (void)roate:(UIInterfaceOrientation)orientation sacle:(float)num
{
    CGAffineTransform rotationTransform;
    
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        
        rotationTransform = CGAffineTransformMakeRotation(3*M_PI/2);
        
    }else if (orientation == UIInterfaceOrientationLandscapeRight) {
        
        rotationTransform = CGAffineTransformMakeRotation(M_PI/2);
        
    }else if (orientation == UIInterfaceOrientationPortrait) {
        
        rotationTransform = CGAffineTransformMakeRotation(0);
        
    } else if (orientation == UIDeviceOrientationPortraitUpsideDown) {
        
        rotationTransform = CGAffineTransformMakeRotation(-M_PI);
        
    }
    
    CGAffineTransform scaleTransform = CGAffineTransformScale(CGAffineTransformIdentity,num,num);
    
    self.transform = CGAffineTransformConcat(scaleTransform,rotationTransform);
}


- (void)actionButtonDown:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(proAclertView:clickButtonAtIndex:)]) {
        [self.delegate proAclertView:self clickButtonAtIndex:button.tag];
    }
    [self dismiss];
}

- (void)dismiss
{
    UIInterfaceOrientation oritention = [[UIApplication sharedApplication] statusBarOrientation];
    [UIView animateWithDuration:0.15f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self roate:oritention sacle:0.0001];
        bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [bgView removeFromSuperview];
        [self removeFromSuperview];
        secondWindow = nil;
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end


