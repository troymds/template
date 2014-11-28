//
//  companyJobCell.m
//  XinNet
//
//  Created by YY on 14-11-20.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "companyJobCell.h"
#define YYBorder 20
@implementation companyJobCell
@synthesize nameLabel,companyLabel,timeLael;
- (void)awakeFromNib {
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(YYBorder, 10, 240, 20)];
        nameLabel.text = @"招聘标题";
        nameLabel.font =[UIFont systemFontOfSize:PxFont(23)];
        [self addSubview:nameLabel];
        nameLabel.textColor =HexRGB(0x3a3a3a);
        nameLabel.textColor=[UIColor blackColor];
        
        
        
        
        companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(YYBorder, 35, 190, 20)];
        companyLabel.text = @"招聘企业";
        [self addSubview:companyLabel];
        companyLabel.numberOfLines = 0;
        companyLabel.textColor = HexRGB(0x808080);
        companyLabel.font =[UIFont systemFontOfSize:PxFont(20)];
        
        
        timeLael = [[UILabel alloc] initWithFrame:CGRectMake(YYBorder, 55, 160, 20)];
        timeLael.text = @"时间";
        [self addSubview:timeLael];
        timeLael.font =[UIFont systemFontOfSize:PxFont(20)];
        timeLael.textColor = HexRGB(0x808080);

        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
