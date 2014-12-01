//
//  CommentItem.h
//  XinNet
//
//  Created by tianj on 14-11-20.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentItem : NSObject

@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *vid;
@property (nonatomic,copy) NSString *create_time;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *user_name;
@property (nonatomic,copy) NSString *user_avatar;
@property (nonatomic,copy) NSString *entity_id;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *type;



- (id)initWithDic:(NSDictionary *)dic;

@end
