//
//  morecell.m
//  XinNet
//
//  Created by promo on 14-11-26.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "morecell.h"

#define cellH 40

@implementation morecell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //1 提示加载
        UILabel * moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth, cellH)];
        moreLabel.text = @"正在死命加载...";
        moreLabel.textAlignment = NSTextAlignmentCenter;
        moreLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:moreLabel];
        //2 转子
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicator.frame = CGRectMake(60,0,40, 40);
        [self.contentView addSubview:_indicator];
    }
    return self;
}
@end
