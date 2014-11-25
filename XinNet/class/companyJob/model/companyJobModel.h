//
//  companyJobModel.h
//  XinNet
//
//  Created by YY on 14-11-25.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface companyJobModel : NSObject
@property (nonatomic, strong)NSString *indexId;//查看次数
@property (nonatomic, strong)NSString *company_id;//起源
@property (nonatomic, strong)NSString *content;
@property (nonatomic,strong)NSString *create_time;//时间
@property (nonatomic, strong)NSString *read_num;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *company_name;
@property (nonatomic, strong)NSString *job_url;
@property (nonatomic, strong)NSString *company_url;




- (instancetype)initWithDictionaryForCompanyJob:(NSDictionary *)dict;

@end
