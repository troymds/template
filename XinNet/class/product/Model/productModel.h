//
//  productModel.h
//  XinNet
//
//  Created by YY on 14-11-25.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface productModel : NSObject
@property (nonatomic, strong)NSString *indexID;//
@property (nonatomic,strong)NSString *company_id;
@property (nonatomic, strong)NSString *company_name;//
@property (nonatomic, strong)NSString *cover;//
@property (nonatomic,strong)NSString *create_time;
@property (nonatomic, strong)NSString *name;//
@property (nonatomic, strong)NSString *old_price;//
@property (nonatomic,strong)NSString *price;
@property (nonatomic, strong)NSString *read_num;//
- (instancetype)initWithDictionaryForBusiness:(NSDictionary *)dict;
@end
