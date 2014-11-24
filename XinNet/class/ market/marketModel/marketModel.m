//
//  marketModel.m
//  XinNet
//
//  Created by YY on 14-11-24.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "marketModel.h"

@implementation marketModel
@synthesize typeID,coverimage,nametitle,author,create_time,from,read_num;
- (instancetype)initWithDictionaryForMarket:(NSDictionary *)dict{
    if ([super self]) {
        self.typeID =dict[@"id"];
        self.coverimage =dict[@"cover"];
        self.nametitle =dict[@"title"];
        self.author =dict[@"author"];
        self.create_time =dict[@"create_time"];
        self.from =dict[@"from"];
        self.read_num =dict[@"read_num"];

    }
    return  self;
}
@end
