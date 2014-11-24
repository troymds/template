//
//  companyListTool.m
//  XinNet
//
//  Created by YY on 14-11-24.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "companyListTool.h"
#import "companyListModel.h"
@implementation companyListTool
+(void)CompanyStatusesWithSuccesscategory:(StatusSuccessBlock)success Page:(NSString *)page CompanyFailure:(StatusFailureBlock)failure;
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"10",@"pagesize",page,@"page", nil];
    [httpTool postWithPath:@"getCompanyList" params:dic success:^(id JSON) {
        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];
        NSDictionary *array =[d[@"response"]objectForKey:@"data"];
        
        if (array) {
            if (![array isKindOfClass:[NSNull class]]){
                for (NSDictionary *dict in array) {
                    companyListModel *s =[[companyListModel alloc] initWithDictionaryForCompany:dict];
                    
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
