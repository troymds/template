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
        
        //头像
        _iconImg = [[TJImageView alloc] initWithFrame:CGRectMake(0,0, 80,80)];
        _iconImg.layer.masksToBounds = YES;
        _iconImg.layer.cornerRadius = _iconImg.frame.size.width/2;
        _iconImg.center = CGPointMake(kWidth/2,10+_iconImg.frame.size.height/2);
        [self addSubview:_iconImg];
        
        //用户名
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,_iconImg.frame.origin.y+_iconImg.frame.size.height, kWidth,30)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_nameLabel];
        
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
