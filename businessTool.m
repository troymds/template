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
+ (void)statusesWithSuccess:(StatusSuccessBlock)success page_Num:(NSString * )page_num type_ID:(NSString *)type_id failure:(StatusFailureBlock)failure
{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"ios",@"os",@"10",@"pagesize",page_num,@"page",type_id,@"type", nil];
    [httpTool postWithPath:@"getOpportunityList" params:dic success:^(id JSON) {
        NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];
        NSDictionary *array =[dict[@"response"]objectForKey:@"data"];
        
        NSLog(@"%@",array);
        if (array) {
            if ([array isKindOfClass:[NSNull class]])
            {
            }else{
                
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
