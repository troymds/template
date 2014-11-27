//
//  myCommentCell.h
//  XinNet
//
//  Created by promo on 14-11-25.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <UIKit/UIKit.h>
@class commentModel;

@interface myCommentCell : UITableViewCell
@property (nonatomic, strong) UIImageView *avatar;//用户头像
@property (nonatomic, strong) UILabel *userName;//用户名
@property (nonatomic, strong) UILabel *detailContent;//评论内容
@property (nonatomic, strong) UILabel *date;//评论时间
@property (nonatomic, strong) commentModel *data;//评论数据
@end
