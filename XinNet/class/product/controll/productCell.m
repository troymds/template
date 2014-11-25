//
//  productCell.m
//  XinNet
//
//  Created by YY on 14-11-21.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "productCell.h"

@implementation productCell
@synthesize hearderImage,priceLabel,companyLabel,nameLabel,old_priceLabel;

- (void)awakeFromNib {
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        hearderImage = [[UIImageView alloc] initWithFrame:CGRectMake(16, 11, 60, 60)];
        hearderImage.image =[UIImage imageNamed:@""];
        hearderImage.backgroundColor =[UIColor lightGrayColor];
        [self addSubview:hearderImage];
        
        
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
        
        
        priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 52, 60, 20)];
        priceLabel.text = @"产品价格";
        [self addSubview:priceLabel];
        priceLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        priceLabel.textColor = HexRGB(0xfe7c75);
        
        old_priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(86, 52, 220, 20)];
        old_priceLabel.text = @"产品价格";
        old_priceLabel.backgroundColor =[UIColor clearColor];
        [self addSubview:old_priceLabel];
        old_priceLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        old_priceLabel.textColor = HexRGB(0x808080);
        
        UIView *line =[[UIView alloc]initWithFrame:CGRectMake(205, 62, 35, 1)];
        [self addSubview:line];
        line.backgroundColor =HexRGB(0x808080);

        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
