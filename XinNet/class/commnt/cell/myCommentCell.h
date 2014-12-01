//
//  myCommentCell.h
//  XinNet
//
//  Created by promo on 14-11-25.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <UIKit/UIKit.h>
@class commentModel;

#define leftSpace 10
#define topSpace  5
#define bottomSpace 10
#define avatarW   30
#define avatarH   30
#define userNameY 6
#define userNameW 130
#define nameBwnavata 20
#define dateW     170
#define useNameH 20
#define detailContentH 35
#define dateContentH 20
#define detailFontSize 12
#define KdetailW kWidth - leftSpace - leftSpace - avatarW - nameBwnavata

@interface myCommentCell : UITableViewCell
@property (nonatomic, strong) UIImageView *avatar;//用户头像
@property (nonatomic, strong) UILabel *userName;//用户名
@property (nonatomic, strong) UILabel *detailContent;//评论内容
@property (nonatomic, strong) UILabel *date;//评论时间
@property (nonatomic, strong) commentModel *data;//评论数据
@property (nonatomic, assign) CGFloat detailW; //详情宽度
@property (nonatomic ,assign) CGFloat detailHeight;//详情的高度
@property (nonatomic, strong) UIView *cellLine;
@end
