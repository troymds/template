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
        
        logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 150)];
        logoImage.backgroundColor =[UIColor clearColor];
        [self addSubview:logoImage];
        
        
        
        nameLabel = [[TYMyLabel alloc] initWithFrame:CGRectMake(10, 160, 300, 35) withInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        nameLabel.font =[UIFont systemFontOfSize:PxFont(20)];
        [self addSubview:nameLabel];
        nameLabel.textColor =HexRGB(0x3a3a3a);
        nameLabel.backgroundColor=[UIColor whiteColor];


        
        
        
        
              
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
