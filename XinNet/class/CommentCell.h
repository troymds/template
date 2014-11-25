//
//  CommentCell.h
//  XinNet
//
//  Created by tianj on 14-11-20.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchLabel.h"

#define contentFont 13


@interface CommentCell : UITableViewCell

@property (nonatomic,strong) TouchLabel *titileLabel;

@property (nonatomic,strong) UILabel *commentLabel;


@end
