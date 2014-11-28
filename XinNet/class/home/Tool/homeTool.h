//
//  homeTool.h
//  XinNet
//
//  Created by YY on 14-11-27.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^StatusSuccessBlock)(NSArray *statues);
typedef void (^StatusFailureBlock)(NSError *error);
@interface homeTool : NSObject

+ (void)statusesWithSuccess:(StatusSuccessBlock)success  failure:(StatusFailureBlock)failure;
@end
