//
//  ListView.h
//  XinNet
//
//  Created by tianj on 14-11-18.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListView : UIView

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *detailLabel;

- (void)setTitle:(NSString *)title;

@end
