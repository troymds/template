//
//  companyListModel.h
//  XinNet
//
//  Created by YY on 14-11-24.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface companyListModel : NSObject
@property (nonatomic, strong)NSString *address;//
@property (nonatomic, strong)NSString *city;//
@property (nonatomic, strong)NSString *contact;//
@property (nonatomic, strong)NSString *type_id;//
@property (nonatomic, strong)NSString *is_vip;//
@property (nonatomic, strong)NSString *logo;//
@property (nonatomic,strong)NSString *name;//
@property (nonatomic, strong)NSString *province;//省份
@property (nonatomic,strong)NSString *tel;//
-(instancetype)initWithDictionaryForCompany:(NSDictionary *)dict;
@end
