//
//  SystemMsgItem.h
//  XinNet
//
//  Created by tianj on 14-11-20.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemMsgItem : NSObject

@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *create_time;

- (id)initWithDic:(NSDictionary *)dic;


@end
