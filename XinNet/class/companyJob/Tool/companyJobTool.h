//
//  companyJobTool.h
//  XinNet
//
//  Created by YY on 14-11-25.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^StatusSuccessBlock)(NSArray *statues);
typedef void (^StatusFailureBlock)(NSError *error);
@interface companyJobTool : NSObject

+ (void)statusesWithSuccess:(StatusSuccessBlock)success company_Id:(NSString *)company_id keywords_Str:(NSString *)keywords failure:(StatusFailureBlock)failure;

@end
