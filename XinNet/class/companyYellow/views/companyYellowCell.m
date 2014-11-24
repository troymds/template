//
//  companyYellowCell.m
//  NewView
//
//  Created by YY on 14-11-18.
//  Copyright (c) 2014年 ___普而摩___. All rights reserved.
//

#import "companyYellowCell.h"
#import "AppMacro.h"

@implementation companyYellowCell
@synthesize logoImage,addressLabel,nameLabel;

- (void)awakeFromNib {
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(16, 10, 60, 60)];
        logoImage.image =[UIImage imageNamed:@""];
        logoImage.backgroundColor =[UIColor cyanColor];
        [self addSubview:logoImage];
        
        
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(86, 10, 240, 20)];
        nameLabel.text = @"企业黄页";
        nameLabel.font =[UIFont systemFontOfSize:PxFont(23)];
        [self addSubview:nameLabel];
        nameLabel.textColor =HexRGB(0x3a3a3a);

        
        
        
        
        addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(86, 40, 190, 20)];
        addressLabel.text = @"公司地址";
        [self addSubview:addressLabel];
        addressLabel.numberOfLines = 0;
        addressLabel.textColor =HexRGB(0x808080);
        addressLabel.font =[UIFont systemFontOfSize:PxFont(17)];
        
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
