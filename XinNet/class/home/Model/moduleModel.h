//
//  moduleModel.h
//  XinNet
//
//  Created by YY on 14-12-2.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface moduleModel : NSObject
@property (nonatomic, strong)NSString *image_url;//
@property (nonatomic, strong)NSString *typeID;//

@property (nonatomic,strong)NSString *name;

- (instancetype)initWithDictionaryForHomeModule:(NSDictionary *)dict;

@end
