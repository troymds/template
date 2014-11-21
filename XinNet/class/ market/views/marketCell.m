//
//  marketCell.m
//  NewView
//
//  Created by YY on 14-11-18.
//  Copyright (c) 2014年 ___普而摩___. All rights reserved.
//

#import "marketCell.h"
#import "AppMacro.h"
@implementation marketCell
@synthesize supplyImage,read_numLabel,companyLabel,nameLabel;

- (void)awakeFromNib {
    
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        supplyImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        supplyImage.image =[UIImage imageNamed:@""];
        supplyImage.backgroundColor =[UIColor purpleColor];
        [self addSubview:supplyImage];
        
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(67, 10, 240, 20)];
        nameLabel.text = @"新闻标题";
        nameLabel.font =[UIFont systemFontOfSize:PxFont(23)];
        [self addSubview:nameLabel];
        nameLabel.textColor=[UIColor blackColor];
        
        
        
        
        companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(67, 30, 190, 20)];
        companyLabel.text = @"来源";
        [self addSubview:companyLabel];
        companyLabel.numberOfLines = 0;
        companyLabel.font =[UIFont systemFontOfSize:PxFont(17)];
        
        
        read_numLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth-60, 30, 60, 20)];
        read_numLabel.text = @"时间";
        [self addSubview:read_numLabel];
        read_numLabel.font =[UIFont systemFontOfSize:PxFont(17)];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
