//
//  commentModel.h
//  XinNet
//
//  Created by promo on 14-11-25.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface commentModel : NSObject
@property (nonatomic, strong)NSString *uid;//uid
@property (nonatomic, strong)NSString *Id;//id
@property (nonatomic, strong)NSString *createTime;//创建时间
@property (nonatomic, strong)NSString *content;//内容
@property (nonatomic, strong)NSString *userName;//用户名
@property (nonatomic, strong)NSString *userAvata;//用户头像

- (instancetype)initWithDictionaryForComment:(NSDictionary *)dict;
@end
