//
//  collectionModel.m
//  XinNet
//
//  Created by promo on 14-11-26.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "collectionModel.h"

@implementation collectionModel

- (id)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.data  = dic[@"data"];

    }
    return self;
}
@end
