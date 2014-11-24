//
//  categoryLestModel.m
//  XinNet
//
//  Created by YY on 14-11-24.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "categoryLestModel.h"

@implementation categoryLestModel
@synthesize typeID,categoryNmae;
- (instancetype)initWithDictionaryForMarket:(NSDictionary *)dict{
    if ([super self]) {
        self.typeID = dict[@"id"];
        self.categoryNmae = dict[@"name"];

    }
    return self;
}
@end
