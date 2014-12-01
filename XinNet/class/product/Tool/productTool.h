//
//  productTool.h
//  XinNet
//
//  Created by YY on 14-11-25.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^StatusSuccessBlock)(NSArray *statues);
typedef void (^StatusFailureBlock)(NSError *error);
@interface productTool : NSObject

+ (void)statusesWithSuccess:(StatusSuccessBlock)success company_Id:(NSString *)company_id keywords_Id:(NSString *)keywords category_Id:(NSString *)category_id failure:(StatusFailureBlock)failure;

+ (void)statusesWithSuccess:(StatusSuccessBlock)success company_Id:(NSString *)company_id keywords_Id:(NSString *)keywords category_Id:(NSString *)category_id  page:(NSString *)page failure:(StatusFailureBlock)failure;

+ (void)statusesWithSuccess:(StatusSuccessBlock)success category_Id:(NSString *)category_id  page:(NSString *)page failure:(StatusFailureBlock)failure;
@end
