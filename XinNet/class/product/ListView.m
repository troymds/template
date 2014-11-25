//
//  ListView.m
//  XinNet
//
//  Created by tianj on 14-11-18.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "ListView.h"
#import "AdaptationSize.h"

#define NameFontSize [UIFont systemFontOfSize:18]
#define DetailFont [UIFont systemFontOfSize:16]

@implementation ListView


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,0,150,frame.size.height)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = HexRGB(0x3a3a3a);
        _nameLabel.font = NameFontSize;
        [self addSubview:_nameLabel];
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.textColor = HexRGB(0x3a3a3a);
        [self addSubview:_detailLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _nameLabel.text = title;
    CGSize size = [AdaptationSize getSizeFromString:title Font:NameFontSize withHight:_nameLabel.frame.size.height withWidth:CGFLOAT_MAX];
    _nameLabel.frame = CGRectMake(5, 0,size.width,_nameLabel.frame.size.height);
    
    CGFloat x = _nameLabel.frame.origin.x+_nameLabel.frame.size.width+5;
    _detailLabel.frame = CGRectMake(x,0,self.frame.size.width-x,self.frame.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
