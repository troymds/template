//
//  interfaceTool.h
//  XinNet
//
//  Created by YY on 14-11-25.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^StatusSuccessBlock)(NSArray *statues);
typedef void (^StatusFailureBlock)(NSError *error);
@interface interfaceTool : NSObject

+ (void)statusesWithSuccess:(StatusSuccessBlock)success page_Num:(NSString * )page_num company_Id:(NSString *)company_id keywords_Str:(NSString *)keywords category_Id:(NSString *)category_id failure:(StatusFailureBlock)failure;
@end
