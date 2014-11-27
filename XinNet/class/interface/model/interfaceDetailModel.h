//
//  interfaceDetailModel.h
//  XinNet
//
//  Created by YY on 14-11-27.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface interfaceDetailModel : NSObject
@property (nonatomic, strong)NSString *indexId;//查看次数
@property (nonatomic, strong)NSString *company_id;//起源
@property (nonatomic, strong)NSString *cover;
@property (nonatomic,strong)NSString *create_time;//时间
@property (nonatomic, strong)NSString *from;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *company_name;
@property (nonatomic, strong)NSString *wapUrl;
@end
