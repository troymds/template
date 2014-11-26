//
//  SquareUserItem.m
//  XinNet
//
//  Created by Tianj on 14/11/18.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "SquareUserItem.h"

@implementation SquareUserItem


- (id)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        if ([dic[@"avatar"] isKindOfClass:[NSNull class]]) {
            self.iconImg = @"";
        }else{
            self.iconImg = dic[@"avatar"];
        }
        if ([dic[@"username"] isKindOfClass:[NSNull class]]) {
            self.userName = @"未命名";
        }else{
            self.userName = dic[@"username"];
        }
        if ([dic[@"image"] isKindOfClass:[NSNull class]]) {
            self.image = @"";
        }else{
            self.image = dic[@"image"];
        }

        self.content = dic[@"content"];
        self.create_time = dic[@"create_time"];
        self.uid = dic[@"id"];
    }
    return self;
}


@end
