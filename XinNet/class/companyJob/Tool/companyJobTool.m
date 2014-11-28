//
//  companyJobTool.m
//  XinNet
//
//  Created by YY on 14-11-25.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "companyJobTool.h"
#import "companyJobModel.h"
@implementation companyJobTool
+ (void)statusesWithSuccess:(StatusSuccessBlock)success company_Id:(NSString *)company_id keywords_Str:(NSString *)keywords page:(NSString *)page failure:(StatusFailureBlock)failure{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"10",@"pagesize",page,@"page",company_id,@"company_id",keywords,@"keywords", nil];
    
    
    [httpTool postWithPath:@"getJobList" params:dic success:^(id JSON) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];
        NSDictionary *array =[dict[@"response"]objectForKey:@"data"];
       
        if (array) {
            if ([array isKindOfClass:[NSNull class]])
            {
            }else{

                for (NSDictionary *diction in array) {
                    companyJobModel *s =[[companyJobModel alloc] initWithDictionaryForCompanyJob:diction];
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
