//
//  SquareUserItem.h
//  XinNet
//
//  Created by Tianj on 14/11/18.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SquareUserItem : NSObject

@property (nonatomic,copy) NSString *iconImg;   //用户头像
@property (nonatomic,copy) NSString *userName;   //用户名
@property (nonatomic,copy) NSString *content;    //文字内容
@property (nonatomic,copy) NSString *create_time;       //发布日期
@property (nonatomic,copy) NSString *image; //用户发布图片
@property (nonatomic,copy) NSString *uid;


- (id)initWithDic:(NSDictionary *)dic;


@end
