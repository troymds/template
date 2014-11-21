//
//  SystemMsgCell.h
//  XinNet
//
//  Created by tianj on 14-11-20.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemMsgItem.h"
#import "AdaptationSize.h"

#define LeftDistance 10
#define ContenWidht (kWidth-LeftDistance*2)
#define ContenFont 13
#define TopDistance 15
#define MiddleDistance 5
#define DateHeight 20

@interface SystemMsgCell : UITableViewCell

@property (nonatomic,strong) UILabel *contenLabel;
@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) UIView *bgView;


- (void)setObject:(SystemMsgItem *)item;

@end
