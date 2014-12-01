//
//  categoryLestTool.m
//  XinNet
//
//  Created by YY on 14-11-24.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "categoryLestTool.h"
#import "categoryLestModel.h"
@implementation categoryLestTool
+ (void)statusesWithSuccess:(StatusSuccessBlock)success entity_Type:(NSString * )entity_type failure:(StatusFailureBlock)failure
{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:entity_type,@"entity_type", nil];
    
    [httpTool postWithPath:@"getCategoryList" params:dic success:^(id JSON) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];
        NSDictionary *array =[dict[@"response"]objectForKey:@"data"];
        
        if (array) {
            if ([array isKindOfClass:[NSNull class]])
            {
            }else{
                
                for (NSDictionary *diction in array) {
                    categoryLestModel *s =[[categoryLestModel alloc] initWithDictionaryForMarket:diction];
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
