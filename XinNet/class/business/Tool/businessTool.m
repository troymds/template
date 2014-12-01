//
//  businessTool.m
//  XinNet
//
//  Created by YY on 14-11-24.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "businessTool.h"
#import "businessModel.h"
@implementation businessTool
+ (void)statusesWithSuccess:(StatusSuccessBlock)success  type_ID:(NSString *)type_id page:(NSString *)page failure:(StatusFailureBlock)failure
{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:type_id,@"type", @"10",@"pagesize",page,@"page", nil];
    [httpTool postWithPath:@"getOpportunityList" params:dic success:^(id JSON) {
        NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];
        NSDictionary *array =[dict[@"response"]objectForKey:@"data"];
      
        if (array) {
            if ([array isKindOfClass:[NSNull class]])
            {
            }
            else{
                for (NSDictionary *diction in array) {
                    businessModel *s =[[businessModel alloc] initWithDictionaryForBusiness:diction];
                    [statuses addObject:s];
                    
                }
            }
        success(statuses);
        }

    } failure:^(NSError *error) {
        
    }];
    
    
}

+ (void)statusesWithSuccess:(StatusSuccessBlock)success keywords_Id:(NSString *)keywords type_ID:(NSString *)type_id company_Id:(NSString *)company_id page:(NSString *)page failure:(StatusFailureBlock)failure
{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:keywords,@"keywords",company_id,@"company_id", @"10",@"pagesize",page,@"page",type_id,@"type", nil];
    [httpTool postWithPath:@"getOpportunityList" params:dic success:^(id JSON) {
        NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];
        NSDictionary *array =[dict[@"response"]objectForKey:@"data"];
        
        if (array) {
            if ([array isKindOfClass:[NSNull class]])
            {
            }
            else{
                for (NSDictionary *diction in array) {
                    businessModel *s =[[businessModel alloc] initWithDictionaryForBusiness:diction];
                    [statuses addObject:s];
                    
                }
            }
            
        }
        success(statuses);
        
    } failure:^(NSError *error) {
        
    }];
    
    
}

@end
