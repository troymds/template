//
//  mardetDetailsTool.m
//  XinNet
//
//  Created by YY on 14-11-24.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "mardetDetailsTool.h"
@implementation mardetDetailsTool
+ (void)statusesWithSuccess:(StatusSuccessBlock)success newsID:(NSString * )newid failure:(StatusFailureBlock)failure
{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:newid,@"news_id", nil];
    
    [httpTool postWithPath:@"getNewsDetail" params:dic success:^(id JSON) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];
        NSDictionary *array =dict[@"response"];
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
