//
//  DemandItem.m
//  XinNet
//
//  Created by tianj on 14-11-20.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "DemandItem.h"

@implementation DemandItem


- (id)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.uid = dic[@"id"];
        self.title = dic[@"title"];
        self.type = dic[@"type"];
    }
    return self;
}


@end
