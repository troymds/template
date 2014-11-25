//
//  productCell.h
//  XinNet
//
//  Created by YY on 14-11-21.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface productCell : UITableViewCell
@property (copy, nonatomic)  UIImageView *hearderImage;
@property (copy, nonatomic)  UILabel *nameLabel;
@property (copy, nonatomic)  UILabel *companyLabel;
@property (copy, nonatomic)  UILabel *priceLabel;
@property (copy, nonatomic)  UILabel *old_priceLabel;

@end
