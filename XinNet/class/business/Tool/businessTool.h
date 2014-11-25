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

+ (void)statusesWithSuccess:(StatusSuccessBlock)success page_num:(NSString * )page keywords_Id:(NSString *)keywords type_ID:(NSString *)type_id category_Id:(NSString *)category_id failure:(StatusFailureBlock)failure;


@end
