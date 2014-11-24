//
//  marketModel.h
//  XinNet
//
//  Created by YY on 14-11-24.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface marketModel : NSObject
@property (nonatomic, strong)NSString *coverimage;//图片
@property (nonatomic, strong)NSString *nametitle;//名称
@property (nonatomic, strong)NSString *author;//作者
@property (nonatomic, strong)NSString *read_num;//查看次数
@property (nonatomic, strong)NSString *from;//起源
@property (nonatomic, strong)NSString *typeID;//时间
@property (nonatomic,strong)NSString *create_time;

- (instancetype)initWithDictionaryForMarket:(NSDictionary *)dict;
@end
