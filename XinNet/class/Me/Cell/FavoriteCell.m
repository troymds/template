//
//  FavoriteCell.m
//  XinNet
//
//  Created by tianj on 14-11-20.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "FavoriteCell.h"

@implementation FavoriteCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat height = 50;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0,kWidth-10-35,height)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_titleLabel];
        
        CGFloat imgWidth = 30;
        CGFloat imgHeight = 30;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_sore.png"]];
        imageView.frame = CGRectMake(kWidth-imgWidth-5,(height-imgHeight)/2,imgWidth,imgHeight);
        [self.contentView addSubview:imageView];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
