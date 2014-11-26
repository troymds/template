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
+ (void)statusesWithSuccess:(StatusSuccessBlock)success keywords_Id:(NSString *)keywords type_ID:(NSString *)type_id category_Id:(NSString *)category_id failure:(StatusFailureBlock)failure
{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:keywords,@"keywords",category_id,@"category_id", @"10",@"pagesize",@"page",@"page",type_id,@"type", nil];
    [httpTool postWithPath:@"getOpportunityList" params:dic success:^(id JSON) {
        NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];
        NSDictionary *array =[dict[@"response"]objectForKey:@"data"];
        
        if (array) {
            if (![array isKindOfClass:[NSNull class]])
            { for (NSDictionary *diction in array) {
                businessModel *s =[[businessModel alloc] initWithDictionaryForBusiness:diction];
                [statuses addObject:s];
            }

            }
            else{
                
                           }
        }
        success(statuses);

    } failure:^(NSError *error) {
        
    }];
    
    
}

@end
