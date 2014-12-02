//
//  adsModel.h
//  XinNet
//
//  Created by YY on 14-12-2.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface adsModel : NSObject
@property (nonatomic, strong)NSString *app_id;//
@property (nonatomic, strong)NSString *typeID;//

@property (nonatomic,strong)NSString *image_url;

- (instancetype)initWithDictionaryForHomeAds:(NSDictionary *)dict;
@end
