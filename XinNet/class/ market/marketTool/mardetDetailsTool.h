//
//  mardetDetailsTool.h
//  XinNet
//
//  Created by YY on 14-11-24.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^StatusSuccessBlock)(NSArray *statues);
typedef void (^StatusFailureBlock)(NSError *error);
@interface mardetDetailsTool : NSObject

+ (void)statusesWithSuccess:(StatusSuccessBlock)success newsID:(NSString * )newid failure:(StatusFailureBlock)failure;
@end
