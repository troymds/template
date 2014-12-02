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

+ (void)statusesWithSuccess:(StatusSuccessBlock)success company_Id:(NSString *)company_id keywords_Id:(NSString *)keywords category_Id:(NSString *)category_id  page:(NSString *)page failure:(StatusFailureBlock)failure
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:company_id,@"company_id",@"10",@"pagesize",page,@"page",keywords,@"keywords",category_id,@"category_id", nil];
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

+ (void)statusesWithSuccess:(StatusSuccessBlockOne)success category_Id:(NSString *)category_id  page:(NSString *)page failure:(StatusFailureBlock)failure
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"10",@"pagesize",page,@"page",category_id,@"category_id", nil];
    [httpTool postWithPath:@"getProductList" params:dic success:^(id JSON) {
        NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];
        NSDictionary *array =[dict[@"response"]objectForKey:@"data"];
        int code = [[[dict objectForKey:@"response"] objectForKey:@"code"] intValue];
        NSString * message = nil;
        if (code == 100) {
            if (![array isKindOfClass:[NSNull class]]) {
                for (NSDictionary *diction in array) {
                    productModel *s =[[productModel alloc] initWithDictionaryForBusiness:diction];
                    [statuses addObject:s];
                }
                success(statuses,code,message);
            }else
            {
                message = @"没有更多数据";
                success(statuses,code,message);
            }
        }
        else
        {
            message = [[dict objectForKey:@"response"] objectForKey:@"msg"];
            success(statuses,code,message);
        }
        
    } failure:^(NSError *error) {
        
    }];
}
@end
