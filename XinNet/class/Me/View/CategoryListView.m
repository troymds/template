//
//  CategoryListView.m
//  XinNet
//
//  Created by tianj on 14-11-25.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "CategoryListView.h"

@implementation CategoryListView


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        CGFloat leftDistance =10;
        CGFloat imgWidth = 48;
        CGFloat imgHeight = 48;
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(leftDistance,(frame.size.height-imgHeight)/2,imgWidth,imgHeight)];
        [self addSubview:_imgView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftDistance+_imgView.frame.size.width+10,0,100,frame.size.height)];
        _titleLabel.textColor = HexRGB(0x3a3a3a);
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
    }
    return self;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(cateListClick:)]) {
        [self.delegate cateListClick:self];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
