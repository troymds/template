//
//  categoryLestTool.h
//  XinNet
//
//  Created by YY on 14-11-24.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^StatusSuccessBlock)(NSArray *statues);
typedef void (^StatusFailureBlock)(NSError *error);
@interface categoryLestTool : NSObject

+ (void)statusesWithSuccess:(StatusSuccessBlock)success entity_Type:(NSString * )entity_type failure:(StatusFailureBlock)failure;

@end
