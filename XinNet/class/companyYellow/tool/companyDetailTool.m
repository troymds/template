//
//  companyDetailTool.m
//  XinNet
//
//  Created by YY on 14-11-24.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "companyDetailTool.h"
#import "companyDetailsModel.h"
@implementation companyDetailTool
+(void)CompanyStatusesWithSuccesscategory:(StatusSuccessBlock)success company_id:(NSString *)companyid CompanyFailure:(StatusFailureBlock)failure{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:companyid,@"company_id", nil];
    [httpTool postWithPath:@"getCompanyDetail" params:dic success:^(id JSON) {
        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];
        NSDictionary *array =d[@"response"];
       
        if (![array isKindOfClass:[NSNull class]]) {
            [statuses addObject:[array objectForKey:@"data"]];
        }
        else{
            
        }
        success(statuses);
    } failure:^(NSError *error) {
        if (failure==nil)return ; {
            failure(error);
        }
    }];
 
}
@end
