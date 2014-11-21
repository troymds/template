//
//  SystemMsgCell.m
//  XinNet
//
//  Created by tianj on 14-11-20.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "SystemMsgCell.h"

@implementation SystemMsgCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = HexRGB(0xd5d5d5);
        _bgView.layer.cornerRadius = 4;
        _bgView.layer.masksToBounds = YES;
        [self.contentView addSubview:_bgView];

        _contenLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contenLabel.font = [UIFont systemFontOfSize:ContenFont];
        _contenLabel.numberOfLines = 0;
        _contenLabel.backgroundColor = [UIColor clearColor];
        [_bgView addSubview:_contenLabel];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.font = [UIFont systemFontOfSize:11];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        [_bgView addSubview:_dateLabel];
        
    }
    return self;
}

- (void)setObject:(SystemMsgItem *)item
{
    CGSize size = [AdaptationSize getSizeFromString:item.content Font:[UIFont systemFontOfSize:ContenFont] withHight:CGFLOAT_MAX withWidth:ContenWidht];
    _bgView.frame = CGRectMake(LeftDistance,TopDistance,ContenWidht,size.height+MiddleDistance+DateHeight);
    
    _contenLabel.frame = CGRectMake(0, 0,ContenWidht,size.height);
    _contenLabel.text = item.content;
    
    _dateLabel.frame = CGRectMake(0,size.height+MiddleDistance,ContenWidht-10,DateHeight);
    _dateLabel.text = item.date;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
