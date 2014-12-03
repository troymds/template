//
//  MoreContentCell.m
//  XinNet
//
//  Created by tianj on 14-12-1.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "MoreContentCell.h"

@implementation MoreContentCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat height = 50; //cell的高度
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kWidth-20,50)];
        _descLabel.backgroundColor = [UIColor clearColor];
        _descLabel.textColor = HexRGB(0x3a3a3a);
        [self.contentView addSubview:_descLabel];
        
        
        //加右侧箭头
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_sore.png"]];
        img.frame = CGRectMake(0,0, 30, 30);
        img.center = CGPointMake(kWidth-(30/2)-5,height/2);
        [self.contentView addSubview:img];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
