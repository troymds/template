//
//  commentPublished.h
//  XinNet
//
//  Created by promo on 14-11-26.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^successBlock)(NSArray *data, int code, NSString * msg);
typedef void(^failureBlock)(NSError *error);

@interface commentPublished : NSObject

+ (void) publishCommentWithSuccess:(successBlock) success entityID:(NSString *)entityId entityType:(NSString *)entityType content:(NSString *)content failure:(failureBlock) failure;
@end
