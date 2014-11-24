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
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"10",@"pagesize",companyid,@"company_id", nil];
    [httpTool postWithPath:@"getCompanyList" params:dic success:^(id JSON) {
        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];
        NSDictionary *array =[d[@"response"]objectForKey:@"data"];
        if (array) {
            if (![array isKindOfClass:[NSNull class]]){
                for (NSDictionary *dict in array) {
                    companyDetailsModel *s =[[companyDetailsModel alloc] initWithDictionaryForCompany:dict];
                    
                    [statuses addObject:s];
                }
            }
        }
        success(statuses);
        
    } failure:^(NSError *error) {
        if (failure==nil)return ; {
            failure(error);
        }
    }];
 
}
@end
