//
//  SelectCell.m
//  XinNet
//
//  Created by tianj on 14-11-20.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "SelectCell.h"

@implementation SelectCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50,0,kWidth-60,self.frame.size.height)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_titleLabel];
        
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"on"] forState:UIControlStateSelected];
        _selectBtn.frame = CGRectMake(20,10, 20, 20);
        [self.contentView addSubview:_selectBtn];
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
