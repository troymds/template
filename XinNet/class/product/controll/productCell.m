//
//  productCell.m
//  XinNet
//
//  Created by YY on 14-11-21.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "productCell.h"

@implementation productCell
@synthesize supplyImage,read_numLabel,companyLabel,nameLabel;

- (void)awakeFromNib {
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        supplyImage = [[UIImageView alloc] initWithFrame:CGRectMake(16, 11, 60, 60)];
        supplyImage.image =[UIImage imageNamed:@""];
        supplyImage.backgroundColor =[UIColor lightGrayColor];
        [self addSubview:supplyImage];
        
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(86, 11, 240, 20)];
        nameLabel.text = @"产品标题";
        nameLabel.font =[UIFont systemFontOfSize:PxFont(23)];
        [self addSubview:nameLabel];
        nameLabel.textColor=HexRGB(0x3a3a3a);
        
        
        
        
        companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(86, 32, 190, 20)];
        companyLabel.text = @"所属公司";
        [self addSubview:companyLabel];
        companyLabel.numberOfLines = 0;
        companyLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        companyLabel.textColor=HexRGB(0x808080);
        
        
        read_numLabel = [[UILabel alloc] initWithFrame:CGRectMake(86, 52, 60, 20)];
        read_numLabel.text = @"产品价格";
        [self addSubview:read_numLabel];
        read_numLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        read_numLabel.textColor = HexRGB(0x808080);
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
