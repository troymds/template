//
//  marketTOOL.m
//  XinNet
//
//  Created by YY on 14-11-24.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "marketTOOL.h"
#import "httpTool.h"
@implementation marketTOOL
+ (void)statusesWithSuccess:(StatusSuccessBlock)success lastID:(NSString * )lastid failure:(StatusFailureBlock)failure
{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"ios",@"os",@"10",@"pagesize",lastid,@"page", nil];

    
    [httpTool postWithPath:@"getNewsList" params:dic success:^(id JSON) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [array addObject:dict];
        success(array);
        
        MYNSLog(@"-----%@",dict);
        
    } failure:^(NSError *error) {
        
    }];
}
@end
