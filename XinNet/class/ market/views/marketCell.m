//
//  marketCell.m
//  NewView
//
//  Created by YY on 14-11-18.
//  Copyright (c) 2014年 ___普而摩___. All rights reserved.
//

#import "marketCell.h"
@implementation marketCell
@synthesize marketImage,timeLabel,fromLabel,titleName;

- (void)awakeFromNib {
    
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        marketImage = [[UIImageView alloc] initWithFrame:CGRectMake(16, 11, 60, 60)];
        marketImage.image =[UIImage imageNamed:@""];
        marketImage.backgroundColor =[UIColor lightGrayColor];
        [self addSubview:marketImage];
        
        
        titleName = [[UILabel alloc] initWithFrame:CGRectMake(86, 11, 215, 20)];
        titleName.text = @"新闻标题";
        titleName.font =[UIFont systemFontOfSize:PxFont(23)];
        [self addSubview:titleName];
        titleName.textColor=HexRGB(0x3a3a3a);
        
        
        
        
        fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(86, 32, 190, 20)];
        fromLabel.text = @"来源";
        [self addSubview:fromLabel];
        fromLabel.numberOfLines = 0;
        fromLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        fromLabel.textColor=HexRGB(0x808080);
        
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(86, 52, 150, 20)];
        timeLabel.text = @"时间";
        [self addSubview:timeLabel];
        timeLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        timeLabel.textColor = HexRGB(0x808080);
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
