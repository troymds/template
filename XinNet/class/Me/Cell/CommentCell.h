//
//  CommentCell.h
//  XinNet
//
//  Created by tianj on 14-11-20.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentItem.h"
#import "AdaptationSize.h"


#define titleFone 14
#define contentFont 14
#define topDistance 10
#define bgWidth (kWidth-20)
#define leftDistance 10
#define space 10
#define commentWidth (bgWidth-space*2)

@interface CommentCell : UITableViewCell

@property (nonatomic,strong) UILabel *titileLabel;

@property (nonatomic,strong) UILabel *commentLabel;
@property (nonatomic,strong) UIView *line;


- (void)setObject:(CommentItem *)obj;

@end
