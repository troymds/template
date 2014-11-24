//
//  httpTool.h
//  XinNet
//
//  Created by YY on 14-11-24.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "NSString+MD5.h"
#import "SystemConfig.h"
#import "DateManeger.h"
#import "UIImageView+WebCache.h"

typedef void (^HttpSuccessBlock)(id JSON);
typedef void (^HttpFailureBlock)(NSError *error);

@interface httpTool : NSObject



+ (void)getWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;
+ (void)postWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;
+ (void)downloadImage:(NSString *)url place:(UIImage *)place imageView:(UIImageView *)imageView;

@end
