//
//  httpTool.m
//  XinNet
//
//  Created by YY on 14-11-24.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "httpTool.h"

#import "AFHTTPClient.h"
#import <objc/message.h>
#import "AFHTTPRequestOperation.h"

@implementation httpTool
+ (void)requestWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure method:(NSString *)method
{
    // 1.创建post请求
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:kURL]];
    
    NSMutableDictionary *allParams = [NSMutableDictionary dictionary];
    //    // 拼接传进来的参数
    if (params) {
        [allParams setDictionary:params];
    }
    NSString *time =[DateManeger getCurrentTimeStamps];
    NSString *uuid = [SystemConfig sharedInstance].uuidStr;
    NSString *md5 = [NSString stringWithFormat:@"%@%@%@",uuid,time,@"ju34s4&6d567nuwe678l89kjdf56o34iw!e"];
    md5 = [md5 md5Encrypt];
    NSString *ios =@"ios";
    [allParams setObject:ios forKey:@"os"];

    [allParams setObject:time forKey:@"time"];
    [allParams setObject:uuid forKey:@"uuid"];
    [allParams setObject:md5 forKey:@"secret"];
    
    //注册和登陆不需要传入参数uid  其他接口都要传
    if ([SystemConfig sharedInstance].uid) {
        [allParams setObject:[SystemConfig sharedInstance].uid forKey:@"uid"];
    }else{
        [allParams setObject:@"0" forKey:@"uid"];
    }
    
    [allParams setObject:App_key forKey:@"app_key"];
    
    NSDictionary *dic = [NSBundle mainBundle].infoDictionary;
    NSString *version = [dic objectForKey:(NSString *)kCFBundleVersionKey];
    [allParams setObject:version forKey:@"version"];
    
    NSString *pathStr = [NSString stringWithFormat:@"/xinnet/index.php?s=/Home/Api/%@",path];
    
    NSURLRequest *request = [client requestWithMethod:method path:pathStr parameters:allParams];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    [op start];
    
}

+ (void)postWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
    [self requestWithPath:path params:params success:success failure:failure method:@"POST"];
}

+ (void)getWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
    
    [self requestWithPath:path params:params success:success failure:failure method:@"GET"];
}
+ (void)downloadImage:(NSString *)url place:(UIImage *)place imageView:(UIImageView *)imageView
{
    [imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:place options:SDWebImageLowPriority | SDWebImageRetryFailed];
}
@end
