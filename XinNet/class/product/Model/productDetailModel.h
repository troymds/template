//
//  productDetailModel.h
//  XinNet
//
//  Created by YY on 14-11-25.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface productDetailModel : NSObject
@property (nonatomic, strong)NSString *indexID;//
@property (nonatomic, strong)NSString *commentNum;//
@property (nonatomic,strong)NSString *company_id;
@property (nonatomic, strong)NSString *company_name;//
@property (nonatomic, strong)NSString *cover;//
@property (nonatomic,strong)NSString *create_time;
@property (nonatomic, strong)NSString *name;//
@property (nonatomic, strong)NSString *old_price;//
@property (nonatomic,strong)NSString *price;
@property (nonatomic, strong)NSString *read_num;//
@property (nonatomic, strong)NSString *category_id;//
@property(nonatomic,retain)NSString *description;

@end
