//
//  interfaceTool.m
//  XinNet
//
//  Created by YY on 14-11-25.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "interfaceTool.h"
#import "interfaceModel.h"
@implementation interfaceTool
+ (void)statusesWithSuccess:(StatusSuccessBlock)success page_Num:(NSString * )page_num company_Id:(NSString *)company_id keywords_Str:(NSString *)keywords category_Id:(NSString *)category_id failure:(StatusFailureBlock)failure{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"10",@"pagesize",page_num,@"page",company_id,@"company_id",keywords,@"keywords",category_id,@"category_id" ,nil];
    
    
    [httpTool postWithPath:@"getShowList" params:dic success:^(id JSON) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];
        NSDictionary *array =[dict[@"response"]objectForKey:@"data"];
        NSLog(@"%@",array);

        
        if (array) {
            if ([array isKindOfClass:[NSNull class]])
            {
            }else{
                
                for (NSDictionary *diction in array) {
                    interfaceModel *s =[[interfaceModel alloc] initWithDictionaryForInterface:diction];
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
