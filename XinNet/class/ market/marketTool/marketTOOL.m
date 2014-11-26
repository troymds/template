//
//  marketTOOL.m
//  XinNet
//
//  Created by YY on 14-11-24.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "marketTOOL.h"
#import "marketModel.h"
@implementation marketTOOL
+ (void)statusesWithSuccess:(StatusSuccessBlock)success keywords_Id:(NSString *)keywords category_Id:(NSString *)category_id failure:(StatusFailureBlock)failure
{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"10",@"pagesize",@"page",@"page",keywords,@"keywords",category_id,@"category_id" ,nil];

    
    [httpTool postWithPath:@"getNewsList" params:dic success:^(id JSON) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];
        NSDictionary *array =[dict[@"response"]objectForKey:@"data"];
        
        if (array) {
            if ([array isKindOfClass:[NSNull class]])
            {
            }else{
                
                for (NSDictionary *diction in array) {
                    marketModel *s =[[marketModel alloc] initWithDictionaryForMarket:diction];
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
