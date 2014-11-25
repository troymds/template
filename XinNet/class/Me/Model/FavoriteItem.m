//
//  FavoriteItem.m
//  XinNet
//
//  Created by tianj on 14-11-20.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "FavoriteItem.h"

@implementation FavoriteItem

- (id)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.app_id  = dic[@"app_id"];
        self.create_time = dic[@"create_time"];
        self.entity_id = dic[@"entity_id"];
        self.vid = dic[@"id"];
        if (![dic[@"title"] isKindOfClass:[NSNull class]]) {
            self.title = dic[@"title"];
        }else{
            self.title = @"无标题";
        }
        self.type = dic[@"type"];
        self.uid = dic[@"uid"];
    }
    return self;
}

@end
