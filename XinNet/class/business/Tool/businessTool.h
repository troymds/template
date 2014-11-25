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

+ (void)statusesWithSuccess:(StatusSuccessBlock)success page_Num:(NSString * )page_num type_ID:(NSString *)type_id failure:(StatusFailureBlock)failure;

@end
