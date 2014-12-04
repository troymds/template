//
//  aboutTool.m
//  XinNet
//
//  Created by YY on 14-11-26.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "aboutTool.h"
@implementation aboutTool
+(void)AboutStatusesWithSuccesscategory:(StatusSuccessBlock)success AboutFailure:(StatusFailureBlock)failure{
    [httpTool postWithPath:@"getAboutUs" params:nil success:^(id JSON) {
        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];
        NSDictionary *array =d[@"response"];
        NSLog(@"%@",array);
        if (![array isKindOfClass:[NSNull class]]) {
            [statuses addObject:[array objectForKey:@"data"]];
        }
        else{
            
        }
        success(statuses);    } failure:^(NSError *error) {
        if (failure==nil)return ; {
            failure(error);
        }
    }];

}
@end
