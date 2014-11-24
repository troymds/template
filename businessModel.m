//
//  businessModel.m
//  XinNet
//
//  Created by YY on 14-11-24.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "businessModel.h"

@implementation businessModel
@synthesize company_id,indexID,read_num,title,create_time;
- (instancetype)initWithDictionaryForBusiness:(NSDictionary *)dict{
    if ([super self]) {
        self.company_id =dict[@"company_id"];
         self.indexID =dict[@"id"];
        self.read_num =dict[@"read_num"];
        self.title =dict[@"title"];
        self.create_time =dict[@"create_time"];
        
    }
    return self;
}

@end
