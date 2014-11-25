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
        
        self.backgroundColor = HexRGB(0xe9f1f6);
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = HexRGB(0xffffff);
        _bgView.layer.cornerRadius = 4;
        _bgView.layer.masksToBounds = YES;
        [self.contentView addSubview:_bgView];

        _contenLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contenLabel.font = [UIFont systemFontOfSize:ContenFont];
        _contenLabel.numberOfLines = 0;
        _contenLabel.backgroundColor = [UIColor clearColor];
        [_bgView addSubview:_contenLabel];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _dateLabel.textColor = HexRGB(0x808080);
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.font = [UIFont systemFontOfSize:11];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_dateLabel];
        
    }
    return self;
}

- (void)setObject:(SystemMsgItem *)item
{
    CGSize size = [AdaptationSize getSizeFromString:item.content Font:[UIFont systemFontOfSize:ContenFont] withHight:CGFLOAT_MAX withWidth:BgWidth-20];
    _bgView.frame = CGRectMake(LeftDistance,TopDistance,BgWidth,size.height+10+bottomHeight);
    
    _contenLabel.frame = CGRectMake(10,10,BgWidth-20,size.height);
    _contenLabel.text = item.content;
    
    _dateLabel.frame = CGRectMake(0,10,kWidth,DateHeight);
    _dateLabel.text = item.date;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
