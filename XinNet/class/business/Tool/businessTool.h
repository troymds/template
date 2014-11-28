//
//  businessTool.h
//  XinNet
//
//  Created by YY on 14-11-24.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^StatusSuccessBlock)(NSArray *statues);
typedef void (^StatusFailureBlock)(NSError *error);
@interface businessTool : NSObject
+ (void)statusesWithSuccess:(StatusSuccessBlock)success keywords_Id:(NSString *)keywords type_ID:(NSString *)type_id company_Id:(NSString *)company_id page:(NSString *)page failure:(StatusFailureBlock)failure;

+ (void)statusesWithSuccess:(StatusSuccessBlock)success  type_ID:(NSString *)type_id page:(NSString *)page failure:(StatusFailureBlock)failure;


@end
