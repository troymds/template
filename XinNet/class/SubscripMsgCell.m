//
//  SubscripMsgCell.m
//  XinNet
//
//  Created by tianj on 14-11-20.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "SubscripMsgCell.h"

@implementation SubscripMsgCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat height = 60; //cell的高度
        CGFloat imgWidth = 50;//图片的宽度
        CGFloat imgHeight = 50;//图片的高度
        CGFloat leftDistance = 10;//图片左边距
        _iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(leftDistance,(height-imgHeight)/2,imgWidth,imgHeight)];
        [self.contentView addSubview:_iconImg];
        
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftDistance+imgWidth+10,height/2-20/2,200,20)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_nameLabel];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef content = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(content,HexRGB(0xd5d5d5).CGColor);
    CGContextSetLineWidth(content,1);
    CGContextBeginPath(content);
    CGContextMoveToPoint(content, rect.origin.x,rect.size.height);
    CGContextAddLineToPoint(content, rect.size.width, rect.size.height);
    CGContextStrokePath(content);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
