//
//  myCommentCell.m
//  XinNet
//
//  Created by promo on 14-11-25.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "myCommentCell.h"
#import "commentModel.h"
#import "UIImageView+WebCache.h"

#define leftSpace 10
#define topSpace  5
#define avatarW   30
#define avatarH   30
#define userNameY 6
#define userNameW 140
#define nameBwnavata 20
#define dateW     170

@implementation myCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //1 avatar
        UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(leftSpace, topSpace, avatarW, avatarH)];
        [self.contentView addSubview:avatar];
        avatar.backgroundColor = [UIColor redColor];
        _avatar = avatar;
        
        //2 userName
        CGFloat userNameX = CGRectGetMaxX(avatar.frame) + nameBwnavata;
        
        UILabel *name  = [[UILabel alloc] initWithFrame:CGRectMake(userNameX, userNameY, userNameW, 20)];
        name.font = [UIFont systemFontOfSize:13] ;
        [self.contentView addSubview:name];
        _userName = name;
        
        //3 detail comment
        CGFloat detailX = userNameX;
        CGFloat detailW = kWidth - leftSpace - detailX;
        CGFloat detailY = CGRectGetMaxY(name.frame) + topSpace;
        UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(detailX, detailY, detailW, 35)];
        detail.font = [UIFont systemFontOfSize:13] ;
        detail.numberOfLines = 0;
        [self.contentView addSubview:detail];
        _detailContent = detail;
        
        //4 date
        CGFloat dateX = CGRectGetMaxX(name.frame);
        CGFloat dateY = userNameY + topSpace;
        UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(dateX, dateY, dateW, 20)];
        date.font = [UIFont systemFontOfSize:12] ;
        [self.contentView addSubview:date];
        _date = date;
    }
    return self;
}

- (void)setData:(commentModel *)data
{
    _data = data;
    _userName.text = data.userName;
    _detailContent.text = data.content;
    _date.text = data.createTime;
    [_avatar setImageWithURL:[NSURL URLWithString:data.userAvata] placeholderImage:placeHoderImage];
}
@end
