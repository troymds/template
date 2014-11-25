//
//  interfaceModel.m
//  XinNet
//
//  Created by YY on 14-11-25.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "interfaceModel.h"

@implementation interfaceModel
@synthesize company_name,company_id,indexId,read_num,title,cover,create_time,wapUrl;
- (instancetype)initWithDictionaryForInterface:(NSDictionary *)dict{
    if ([super self]) {
        self.cover=dict[@"cover"];
         self.company_id=dict[@"company_id"];
         self.company_name=dict[@"company_name"];
         self.indexId=dict[@"id"];
         self.read_num=dict[@"read_num"];
         self.title=dict[@"title"];
         self.create_time=dict[@"create_time"];
        self.wapUrl=dict[@"wapUrl"];

    }
    return self;
}

@end
