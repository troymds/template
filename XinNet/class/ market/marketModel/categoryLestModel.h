//
//  categoryLestModel.h
//  XinNet
//
//  Created by YY on 14-11-24.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface categoryLestModel : NSObject
@property (nonatomic, strong)NSString *typeID;//时间
@property (nonatomic,strong)NSString *categoryNmae;

- (instancetype)initWithDictionaryForMarket:(NSDictionary *)dict;

@end
