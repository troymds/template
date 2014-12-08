//
//  SquareHeadView.m
//  XinNet
//
//  Created by Tianj on 14/11/18.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "SquareHeadView.h"

@implementation SquareHeadView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"square_headBg"]];
        bgView.frame = CGRectMake(0,0,frame.size.width,frame.size.height);
        bgView.userInteractionEnabled = YES;
        [self addSubview:bgView];
        
        //头像
        _iconImg = [[TJImageView alloc] initWithFrame:CGRectMake(0,0, 80,80)];
        _iconImg.layer.masksToBounds = YES;
        _iconImg.layer.cornerRadius = _iconImg.frame.size.width/2;
        _iconImg.center = CGPointMake(kWidth/2,10+_iconImg.frame.size.height/2);
        [self addSubview:_iconImg];
        
        //用户名
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,_iconImg.frame.origin.y+_iconImg.frame.size.height+10, kWidth,20)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.hidden = YES;
        [self addSubview:_nameLabel];
        
        
        
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setTitle:@"登 陆" forState:UIControlStateNormal];
        _loginBtn.frame = CGRectMake(kWidth/2-80/2,_iconImg.frame.origin.y+_iconImg.frame.size.height+10,80,30);
        _loginBtn.layer.borderColor = HexRGB(0xd5d5d5).CGColor;
        _loginBtn.layer.borderWidth = 1.0f;
        [_loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:_loginBtn];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
