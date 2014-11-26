//
//  UserItem.m
//  XinNet
//
//  Created by tianj on 14-11-26.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "UserItem.h"

@implementation UserItem

- (id)initWithDic:(NSDictionary *)dic
{
    if ([dic[@"avatar"] isKindOfClass:[NSNull class]]) {
        self.avatar = dic[@"avatar"];
    }else{
        self.avatar = @"";
    }
    if ([dic[@"email"] isKindOfClass:[NSNull class]]) {
        self.email = dic[@"email"];
    }else{
        self.email = @"";
    }
    if ([dic[@"id"] isKindOfClass:[NSNull class]]) {
        self.uid = [NSString stringWithFormat:@"%d",[dic[@"id"] intValue]];
    }else{
        self.uid = @"-1";
    }
    if ([dic[@"mobile"] isKindOfClass:[NSNull class]]) {
        self.mobile = dic[@"mobile"];
    }else{
        self.mobile = @"";
    }
    if ([dic[@"user_name"] isKindOfClass:[NSNull class]]) {
        self.mobile = dic[@"user_name"];
    }else{
        self.mobile = @"";
    }
    return self;
}

@end
