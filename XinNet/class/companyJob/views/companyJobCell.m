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
@synthesize nameLabel,companyLabel,read_numLabel;
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
        
        
        read_numLabel = [[UILabel alloc] initWithFrame:CGRectMake(YYBorder, 55, 60, 20)];
        read_numLabel.text = @"时间";
        [self addSubview:read_numLabel];
        read_numLabel.font =[UIFont systemFontOfSize:PxFont(20)];
        read_numLabel.textColor = HexRGB(0x808080);

        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
