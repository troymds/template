//
//  SquareCell.h
//  XinNet
//
//  Created by Tianj on 14/11/18.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SquareUserItem.h"
#import "AdaptationSize.h"

#define LeftSpace 10
#define TopSapce 10
#define IconImgWidth 35
#define IconImgHeight 35
#define NameFont 14
#define ContentFont 14
#define ContentHeight 80
#define DateFont 12
#define UserNameHeight 20
#define MiddleSpace 5
#define PublishImgWidth 83
#define PublishImgHeiht 83
#define DateHeight 15
#define ContentWidth (kWidth - IconImgWidth-LeftSpace - 5*2)


@interface SquareCell : UITableViewCell

@property (nonatomic,strong) UIImageView *iconImg;
@property (nonatomic,strong) UILabel *userNameLabel;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UIImageView *publishImg;
@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) UIView *line;

- (void)setObject:(SquareUserItem *)item;


@end
