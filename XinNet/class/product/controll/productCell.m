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
        nameLabel.font =[UIFont systemFontOfSize:PxFont(23)];
        [self addSubview:nameLabel];
        nameLabel.textColor=HexRGB(0x3a3a3a);
        
        
        
        
        companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(86, 32, 190, 20)];
        [self addSubview:companyLabel];
        companyLabel.numberOfLines = 0;
        companyLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        companyLabel.textColor=HexRGB(0x808080);
        
        UILabel*   priceLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(86, 52, 60, 20)];
        priceLabel1.text = @"产品价格:";
        [self addSubview:priceLabel1];
        priceLabel1.font =[UIFont systemFontOfSize:PxFont(18)];
        priceLabel1.textColor = HexRGB(0x808080);

        
        priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 52, 70, 20)];
        [self addSubview:priceLabel];
        priceLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        priceLabel.textColor = HexRGB(0xfe7c75);
        priceLabel.backgroundColor=[UIColor clearColor];
        
        old_priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 52, 70, 20)];
        old_priceLabel.backgroundColor =[UIColor clearColor];
        [self addSubview:old_priceLabel];
        old_priceLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        old_priceLabel.textColor = HexRGB(0x808080);
        old_priceLabel.backgroundColor=[UIColor clearColor];
        
        _lineView =[[UIView alloc]initWithFrame:CGRectMake(0, 10, 20, 1)];
        [old_priceLabel addSubview:_lineView];
        _lineView.backgroundColor =HexRGB(0x808080);

        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
