//
//  collectionHttpTool.h
//  XinNet
//
//  Created by promo on 14-11-26.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^addsuccessBlock)(NSArray *data, int code, NSString * msg);
typedef void(^addfailureBlock)(NSError *error);

typedef void(^canclesuccessBlock)(NSArray *data, int code, NSString * msg);
typedef void(^canclefailureBlock)(NSError *error);

@interface collectionHttpTool : NSObject

+ (void) addCollectionWithSuccess:(addsuccessBlock)success entityId:(NSString *) entityID entityType:(NSString *)entityType  withFailure:(addfailureBlock)failure;

+ (void) cancleCollectionWithSuccess:(canclesuccessBlock)success collectionId:(NSString *) collectionId   withFailure:(canclefailureBlock)failure;

@end
