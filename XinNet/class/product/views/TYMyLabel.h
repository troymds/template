//
//  TYMyLabel.h
//  ZSEL
//
//  Created by apple on 14-12-4.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYMyLabel : UILabel

@property(nonatomic) UIEdgeInsets insets;
-(id) initWithFrame:(CGRect)frame withInsets:(UIEdgeInsets)insets;
-(id) initWithInsets:(UIEdgeInsets)insets;

@end
