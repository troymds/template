//
//  CommentCell.m
//  XinNet
//
//  Created by tianj on 14-11-20.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = HexRGB(0xe9f1f6);
        _titileLabel = [[TouchLabel alloc] initWithFrame:CGRectMake(10,5,kWidth-20,25)];
        _titileLabel.backgroundColor = [UIColor clearColor];
        _titileLabel.textColor = HexRGB(0x3a3a3a);
        [self.contentView addSubview:_titileLabel];
        
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,30,kWidth-20,85)];
        _commentLabel.backgroundColor = [UIColor whiteColor];
        _commentLabel.font = [UIFont systemFontOfSize:contentFont];
        _commentLabel.textColor = HexRGB(0x3a3a3a);
        _commentLabel.numberOfLines = 0;
        [self.contentView addSubview:_commentLabel];
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
