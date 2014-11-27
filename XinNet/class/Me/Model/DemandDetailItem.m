//
//  DemandDetailItem.m
//  XinNet
//
//  Created by Tianj on 14/11/23.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "DemandDetailItem.h"

@implementation DemandDetailItem

- (id)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.company_id = dic[@"company_id"];
        self.uid = dic[@"id"];
        self.title = dic[@"title"];
        self.create_time = dic[@"create_time"];
        self.read_num = dic[@"read_num"];
        self.content = dic[@"content"];
        self.num = dic[@"num"];
    }
    return self;
}

@end
