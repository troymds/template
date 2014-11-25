//
//  companyListTool.h
//  XinNet
//
//  Created by YY on 14-11-24.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^StatusSuccessBlock)(NSArray *statues);
typedef void (^StatusFailureBlock)(NSError *error);
@interface companyListTool : NSObject


+ (void)statusesWithSuccess:(StatusSuccessBlock)success page_num:(NSString * )page keywords_Id:(NSString *)keywords failure:(StatusFailureBlock)failure;
@end
