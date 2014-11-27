//
//  interfaecDetailesTool.m
//  XinNet
//
//  Created by YY on 14-11-27.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "interfaecDetailesTool.h"

@implementation interfaecDetailesTool
+(void)CompanyStatusesWithSuccesscategory:(StatusSuccessBlock)success company_id:(NSString *)companyid CompanyFailure:(StatusFailureBlock)failure{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:companyid,@"id", nil];
    [httpTool postWithPath:@"getShowDetail" params:dic success:^(id JSON) {
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
