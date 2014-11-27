//
//  collectionModel.h
//  XinNet
//
//  Created by promo on 14-11-26.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface collectionModel : NSObject

@property (nonatomic, strong) NSString *data;//收藏id

- (id)initWithDic:(NSDictionary *)dic;
@end
