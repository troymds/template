//
//  jobDetailTool.h
//  XinNet
//
//  Created by YY on 14-11-27.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^StatusSuccessBlock)(NSArray *statues);
typedef void (^StatusFailureBlock)(NSError *error);
@interface jobDetailTool : NSObject


+(void)CompanyStatusesWithSuccesscategory:(StatusSuccessBlock)success company_id:(NSString *)companyid CompanyFailure:(StatusFailureBlock)failure;
@end
