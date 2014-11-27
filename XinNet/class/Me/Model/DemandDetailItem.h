//
//  DemandDetailItem.h
//  XinNet
//
//  Created by Tianj on 14/11/23.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DemandDetailItem : NSObject


@property (nonatomic,copy) NSString *company_id;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *create_time;
@property (nonatomic,copy) NSString *read_num;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *num;

- (id)initWithDic:(NSDictionary *)dic;

@end
