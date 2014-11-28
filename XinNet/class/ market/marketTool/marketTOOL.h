//
//  marketTOOL.h
//  XinNet
//
//  Created by YY on 14-11-24.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^StatusSuccessBlock)(NSArray *statues);
typedef void (^StatusFailureBlock)(NSError *error);
@interface marketTOOL : NSObject

+ (void)statusesWithSuccess:(StatusSuccessBlock)success  keywords_Id:(NSString *)keywords category_Id:(NSString *)category_id page:(NSString *)page failure:(StatusFailureBlock)failure;

@end
