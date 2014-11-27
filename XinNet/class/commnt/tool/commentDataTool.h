//
//  commentDataTool.h
//  XinNet
//
//  Created by promo on 14-11-25.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^successBlock)(NSArray *data, int code, NSString * msg);
typedef void(^failureBlock)(NSError *error);

@interface commentDataTool : NSObject

+ (void) GetCommentDataWithSuccess:(successBlock)success entityId:(NSString *) entityID entityType:(NSString *)entityType page:(NSString *)page withFailure:(failureBlock)failure;
@end
