//
//  businessDetailsTool.h
//  XinNet
//
//  Created by YY on 14-11-25.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^StatusSuccessBlock)(NSArray *statues);
typedef void (^StatusFailureBlock)(NSError *error);
@interface businessDetailsTool : NSObject

+ (void)statusesWithSuccess:(StatusSuccessBlock)success  opportunity_Id:(NSString *)opportunity_id failure:(StatusFailureBlock)failure;
@end
