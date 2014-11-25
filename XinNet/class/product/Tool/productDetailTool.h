//
//  productDetailTool.h
//  XinNet
//
//  Created by YY on 14-11-25.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^StatusSuccessBlock)(NSArray *statues);
typedef void (^StatusFailureBlock)(NSError *error);
@interface productDetailTool : NSObject

+ (void)statusesWithSuccess:(StatusSuccessBlock)success product_ID:(NSString * )product_id failure:(StatusFailureBlock)failure;
@end
