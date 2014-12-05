//
//  MagnifyView.m
//  XinNet
//
//  Created by tianj on 14-12-5.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "MagnifyView.h"

@interface MagnifyView ()
{
    UIView *bgView;
    UIImageView *imgView;
    CGRect defaultRect;
    UIImage *image;
    UITapGestureRecognizer *tap;
}
@end

@implementation MagnifyView

- (id)initWithImageView:(UIImageView *)imageView
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, kWidth,kHeight);
        bgView =[[UIView alloc] initWithFrame:CGRectMake(0, 0,kWidth,kHeight)];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.userInteractionEnabled = YES;
        bgView.alpha = 0;
    
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        defaultRect = [imageView convertRect:imageView.bounds toView:window];
        imgView = [[UIImageView alloc] initWithFrame:defaultRect];
        imgView.userInteractionEnabled = YES;
        image = imageView.image;
        imgView.image = image;
        [bgView addSubview:imgView];
        
        
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDown)];
        [bgView addGestureRecognizer:tap];
        
        [self addSubview:bgView];
        
    }
    return self;
}

- (void)tapDown
{
    [UIView animateWithDuration:0.4 animations:^{
        bgView.alpha = 0;
        imgView.frame = defaultRect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)show
{
    [UIView animateWithDuration:0.4 animations:^{
        bgView.alpha = 1;
        imgView.frame = CGRectMake(0,(kHeight-image.size.height*(kWidth/image.size.width))/2,kWidth,image.size.height*(kWidth/image.size.width));
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
