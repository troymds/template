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
#import "AdaptationSize.h"


@implementation myCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //1 avatar
        UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(leftSpace, topSpace, avatarW, avatarH)];
        [self.contentView addSubview:avatar];
        avatar.backgroundColor = [UIColor clearColor];
        avatar.layer.cornerRadius = avatarW/2;
        _avatar = avatar;
        
        //2 userName
        CGFloat userNameX = CGRectGetMaxX(avatar.frame) + nameBwnavata;
        
        UILabel *name  = [[UILabel alloc] initWithFrame:CGRectMake(userNameX, userNameY, userNameW, useNameH)];
        name.font = [UIFont systemFontOfSize:13] ;
        [self.contentView addSubview:name];
        _userName = name;
        
        //3 detail comment
        CGFloat detailX = userNameX;
        CGFloat detailW = kWidth - leftSpace - detailX;
        _detailW = detailW;
        CGFloat detailY = CGRectGetMaxY(name.frame) ;
        UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(detailX, detailY, detailW, detailContentH)];
        detail.font = [UIFont systemFontOfSize:detailFontSize] ;
        detail.numberOfLines = 0;
        [self.contentView addSubview:detail];
        _detailContent = detail;
        
        //4 date
        CGFloat dateX = CGRectGetMaxX(name.frame);
        CGFloat dateY = userNameY;
        UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(dateX, dateY, dateW, dateContentH)];
        date.font = [UIFont systemFontOfSize:12] ;
        date.textColor = HexRGB(0x808080);
        [self.contentView addSubview:date];
        _date = date;
        
        //5 line
        _cellLine =[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxX(detail.frame) - 1, kWidth, 1)];
        [self.contentView addSubview:_cellLine];
        _cellLine.backgroundColor =HexRGB(0xe6e3e4);
    }
    return self;
}

- (void)setData:(commentModel *)data
{
    _data = data;
    _userName.text = [data.userName isKindOfClass:[NSNull class]] ? @"" : data.userName;
    _detailContent.text = data.content;
    _date.text = data.createTime;
    CGSize size = [AdaptationSize getSizeFromString:data.content Font:[UIFont systemFontOfSize:detailFontSize] withHight:CGFLOAT_MAX withWidth:_detailW];
    _detailContent.frame = CGRectMake(CGRectGetMaxX(_avatar.frame) + nameBwnavata, CGRectGetMaxY(_userName.frame), _detailW, size.height);
    _detailHeight = size.height;
    if ([data.userAvata isKindOfClass:[NSNull class]]) {
        [_avatar setImageWithURL:[NSURL URLWithString:@""] placeholderImage:placeHoderImage1];
    }else
    {
        [_avatar setImageWithURL:[NSURL URLWithString:data.userAvata] placeholderImage:placeHoderImage1];
    }
    CGFloat y = _detailContent.frame.origin.y + _detailHeight + bottomSpace ;

    _cellLine.frame = CGRectMake(0, y - 1, kWidth, 1);
}

@end
