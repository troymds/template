//
//  productModel.m
//  XinNet
//
//  Created by YY on 14-11-25.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "productModel.h"

@implementation productModel
@synthesize company_id,indexID,read_num,cover,create_time,company_name,price,old_price,name;
- (instancetype)initWithDictionaryForBusiness:(NSDictionary *)dict{
    if ([super self]) {
        self.company_id =dict[@"company_id"];
        self.indexID =dict[@"id"];
        self.read_num =dict[@"read_num"];
        self.company_name =dict[@"company_name"];
        
        self.create_time =dict[@"create_time"];
        self.name =dict[@"name"];
        self.cover =dict[@"cover"];
        self.old_price =dict[@"old_price"];
        self.price =dict[@"price"];
        
    }
    return self;
}
@end
