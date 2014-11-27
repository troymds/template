//
//  DemandItem.h
//  XinNet
//
//  Created by tianj on 14-11-20.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DemandItem : NSObject

@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *type;



- (id)initWithDic:(NSDictionary *)dic;

@end
