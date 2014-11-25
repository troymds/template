//
//  productTool.m
//  XinNet
//
//  Created by YY on 14-11-25.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "productTool.h"
#import "productModel.h"
@implementation productTool
+ (void)statusesWithSuccess:(StatusSuccessBlock)success page_num:(NSString * )page keywords_Id:(NSString *)keywords category_Id:(NSString *)category_id failure:(StatusFailureBlock)failure

{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"10",@"pagesize",page,@"page",keywords,@"keywords",category_id,@"category_id", nil];
    [httpTool postWithPath:@"getProductList" params:dic success:^(id JSON) {
        NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];
        NSDictionary *array =[dict[@"response"]objectForKey:@"data"];
        
        if (array) {
            if ([array isKindOfClass:[NSNull class]])
            {
            }else{
                
                for (NSDictionary *diction in array) {
                    productModel *s =[[productModel alloc] initWithDictionaryForBusiness:diction];
                    [statuses addObject:s];
                }
            }
        }
        success(statuses);
        
    } failure:^(NSError *error) {
        
    }];
    
    
}
@end
