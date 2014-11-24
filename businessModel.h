//
//  businessModel.h
//  XinNet
//
//  Created by YY on 14-11-24.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface businessModel : NSObject
@property (nonatomic, strong)NSString *company_id;//
@property (nonatomic,strong)NSString *create_time;//时间
@property (nonatomic, strong)NSString *indexID;//
@property (nonatomic,strong)NSString *read_num;
@property (nonatomic, strong)NSString *title;//
- (instancetype)initWithDictionaryForBusiness:(NSDictionary *)dict;

@end
