//
//  collectionHttpTool.m
//  XinNet
//
//  Created by promo on 14-11-26.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "collectionHttpTool.h"
#import "collectionModel.h"

@implementation collectionHttpTool

+ (void) addCollectionWithSuccess:(addsuccessBlock)success entityId:(NSString *) entityID entityType:(NSString *)entityType  withFailure:(addfailureBlock)failure
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:entityID,@"entity_id",entityType,@"entity_type",@"ios",@"os", nil];
    
    [httpTool postWithPath:@"addCollection" params:dic success:^(id JSON) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];
        
        int code = [[[dict objectForKey:@"response"] objectForKey:@"code"] intValue];
        NSString * message = nil;
        if (code == 100) {
            collectionModel * model = [[collectionModel alloc] initWithDic:[dict objectForKey:@"response"]];
            [statuses addObject:model];
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

+ (void) cancleCollectionWithSuccess:(canclesuccessBlock)success collectionId:(NSString *) collectionId   withFailure:(canclefailureBlock)failure
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:collectionId,@"collection_id",@"ios",@"os", nil];
    
    [httpTool postWithPath:@"cancelCollection" params:dic success:^(id JSON) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *statuses =[NSMutableArray array];
        
        int code = [[[dict objectForKey:@"response"] objectForKey:@"code"] intValue];
        NSString * message = nil;
        if (code == 100) {
            message = [[dict objectForKey:@"response"] objectForKey:@"data"];
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
