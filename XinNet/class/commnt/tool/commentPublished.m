//
//  commentPublished.m
//  XinNet
//
//  Created by promo on 14-11-26.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "commentPublished.h"

@implementation commentPublished

+ (void) publishCommentWithSuccess:(successBlock) success entityID:(NSString *)entityId entityType:(NSString *)entityType content:(NSString *)content failure:(failureBlock) failure
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:content,@"content", entityId,@"entity_id",entityType,@"entity_type",@"ios",@"os", nil];
    
    [httpTool postWithPath:@"addComment" params:dic success:^(id JSON) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];
        
        int code = [[[dict objectForKey:@"response"] objectForKey:@"code"] intValue];
        NSString * message = nil;
        if (code == 100) {
            message = @"发布成功";
        }else
        {
            message = [[dict objectForKey:@"response"] objectForKey:@"msg"];
        }
        success(statuses, code,message);
        
    } failure:^(NSError *error) {
        if (failure==nil)return ; {
            failure(error);
        }
    }];
}
@end
