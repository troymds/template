//
//  commentDataTool.m
//  XinNet
//
//  Created by promo on 14-11-25.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "commentDataTool.h"
#import "httpTool.h"
#import "commentModel.h"

@implementation commentDataTool
+ (void) GetCommentDataWithSuccess:(successBlock)success entityId:(NSString *) entityID entityType:(NSString *)entityType page:(NSString *)page withFailure:(failureBlock)failure
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:entityID,@"entity_id",entityType,@"entity_type",page,@"page",@"10",@"pagesize",@"ios",@"os", nil];
    
    [httpTool postWithPath:@"getCommentList" params:dic success:^(id JSON) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];
        
        int code = [[[dict objectForKey:@"response"] objectForKey:@"code"] intValue];
        NSString * message = nil;
        if (code == 100) {
            NSDictionary *array = [[dict objectForKey:@"response"] objectForKey:@"data"];
            
            if (![array isKindOfClass:[NSNull class]]) {
                for (NSDictionary * d in array) {
                    commentModel *model = [[commentModel alloc] initWithDictionaryForComment:d];
                    [statuses addObject:model];
                }
            }
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
