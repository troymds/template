//
//  CommentItem.m
//  XinNet
//
//  Created by tianj on 14-11-20.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "CommentItem.h"

@implementation CommentItem

- (id)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.uid = dic[@"uid"];
        self.vid = dic[@"id"];
        self.create_time = dic[@"create_time"];
        self.content = dic[@"content"];
        self.user_name =dic[@"user_name"];
        self.user_avatar = dic[@"user_avatar"];
    }
    return self;
}

@end
