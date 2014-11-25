//
//  productDetailTool.m
//  XinNet
//
//  Created by YY on 14-11-25.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "productDetailTool.h"
@implementation productDetailTool
+ (void)statusesWithSuccess:(StatusSuccessBlock)success product_ID:(NSString * )product_id failure:(StatusFailureBlock)failure{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:product_id,@"product_id", nil];
    [httpTool postWithPath:@"getProductDetail" params:dic success:^(id JSON) {
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
