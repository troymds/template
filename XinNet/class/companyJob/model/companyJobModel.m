//
//  companyJobModel.m
//  XinNet
//
//  Created by YY on 14-11-25.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "companyJobModel.h"

@implementation companyJobModel
@synthesize company_id,content,create_time,indexId,read_num,title,company_name,company_url,job_url;
- (instancetype)initWithDictionaryForCompanyJob:(NSDictionary *)dict{
    if ([super self]) {
        
        self.company_name =dict[@"company_name"];
        self.company_id =dict[@"company_id"];
        self.content =dict[@"content"];
        self.create_time =dict[@"create_time"];
        self.read_num =dict[@"read_num"];
        self.title =dict[@"title"];
        self.indexId =dict[@"id"];
        self.job_url =dict[@"job_url"];
        self.company_url =dict[@"company_url"];
           }
    return self;
}

@end
