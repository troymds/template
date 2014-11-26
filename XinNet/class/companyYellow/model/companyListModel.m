//
//  companyListModel.m
//  XinNet
//
//  Created by YY on 14-11-24.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "companyListModel.h"

@implementation companyListModel
@synthesize address,city,contact,type_id,is_vip,logo,name,province,tel;
-(instancetype)initWithDictionaryForCompany:(NSDictionary *)dict{
    if ([super self]) {
        self.address =dict[@"address"];
        self.city =dict[@"city"];
        self.contact =dict[@"contact"];
        self.type_id =dict[@"id"];
        self.is_vip =dict[@"is_vip"];
        self.logo =dict[@"logo"];
        self.name =dict[@"name"];
        self.province =dict[@"province"];
        self.tel =dict[@"tel"];

    }
    return self;
}

@end
