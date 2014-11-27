//
//  commentModel.m
//  XinNet
//
//  Created by promo on 14-11-25.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "commentModel.h"

@implementation commentModel

- (instancetype)initWithDictionaryForComment:(NSDictionary *)dict
{
    if (self == [super init]) {
        self.Id =dict[@"id"];
        self.uid =dict[@"uid"];
        self.content =dict[@"content"];
        self.userName =dict[@"user_name"];
        self.createTime =dict[@"create_time"];
        self.userAvata =dict[@"user_avatar"];
    }
    return self;
}
@end
