//
//  aboutTool.h
//  XinNet
//
//  Created by YY on 14-11-26.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^StatusSuccessBlock)(NSArray *statues);
typedef void (^StatusFailureBlock)(NSError *error);
@interface aboutTool : NSObject


+(void)AboutStatusesWithSuccesscategory:(StatusSuccessBlock)success AboutFailure:(StatusFailureBlock)failure;
@end
