//
//  SystemMsgItem.m
//  XinNet
//
//  Created by tianj on 14-11-20.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "SystemMsgItem.h"

@implementation SystemMsgItem

- (id)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.content = dic[@"content"];
        self.create_time = dic[@"create_time"];
    }
    return self;
}

@end
