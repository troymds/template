//
//  interfaceCell.m
//  XinNet
//
//  Created by YY on 14-11-21.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "interfaceCell.h"

@implementation interfaceCell
@synthesize interfaceImage,timeLabel,nameLabel;

- (void)awakeFromNib {
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        interfaceImage = [[UIImageView alloc] initWithFrame:CGRectMake(16, 11, 60, 60)];
        interfaceImage.image =[UIImage imageNamed:@""];
        interfaceImage.backgroundColor =[UIColor lightGrayColor];
        [self addSubview:interfaceImage];
        
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(86, 11, 240, 20)];
        nameLabel.text = @"展会名称";
        nameLabel.font =[UIFont systemFontOfSize:PxFont(23)];
        [self addSubview:nameLabel];
        nameLabel.textColor=HexRGB(0x3a3a3a);
        
        
        
        
//        companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(86, 32, 190, 20)];
//        companyLabel.text = @"来源";
//        [self addSubview:companyLabel];
//        companyLabel.numberOfLines = 0;
//        companyLabel.font =[UIFont systemFontOfSize:PxFont(18)];
//        companyLabel.textColor=HexRGB(0x808080);
        
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(86, 42, 150, 20)];
        timeLabel.text = @"展会时间";
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
