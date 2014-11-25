//
//  businessDetailsTool.m
//  XinNet
//
//  Created by YY on 14-11-25.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "businessDetailsTool.h"
#import "businessDetailsModel.h"
@implementation businessDetailsTool
+ (void)statusesWithSuccess:(StatusSuccessBlock)success  opportunity_Id:(NSString *)opportunity_id failure:(StatusFailureBlock)failure
{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:opportunity_id,@"opportunity_id", nil];
    [httpTool postWithPath:@"getOpportunityDetail" params:dic success:^(id JSON) {
        NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];
        NSDictionary *array =dict[@"response"];
      
        if (![array isKindOfClass:[NSNull class]]) {
            [statuses addObject:[array objectForKey:@"data"]];
        }
        else{
            
        }
        success(statuses);
    } failure:^(NSError *error) {
        
    }];
    
    
    
}

@end
