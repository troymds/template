//
//  homeModel.h
//  XinNet
//
//  Created by YY on 14-11-27.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface homeModel : NSObject
@property(nonatomic,strong)NSString *image_url;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,copy)NSString* typeId;
- (instancetype)initWithDictionaryForMarket:(NSDictionary *)dict;

@end
