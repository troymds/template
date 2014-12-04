//
//  personCenterCell.m
//  XinNet
//
//  Created by tianj on 14-12-3.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "personCenterCell.h"

@implementation personCenterCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat height = 55;
        CGFloat leftDistance =18;
        CGFloat imgWidth = 30;
        CGFloat imgHeight = 30;
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(leftDistance,(height-imgHeight)/2,imgWidth,imgHeight)];
        [self.contentView addSubview:_imgView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftDistance+_imgView.frame.size.width+20,0, 120,height)];
        _titleLabel.textColor = HexRGB(0x3a3a3a);
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_titleLabel];
        
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_sore.png"]];
        img.frame = CGRectMake(0,0, 30, 30);
        img.center = CGPointMake(kWidth-15-5,height/2);
        [self.contentView addSubview:img];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
