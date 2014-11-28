//
//  homeModel.m
//  XinNet
//
//  Created by YY on 14-11-27.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "homeModel.h"

@implementation homeModel
@synthesize image_url,name,typeId;
- (instancetype)initWithDictionaryForMarket:(NSDictionary *)dict{
    if ([super self]) {
        self.image_url =dict[@"image_url"];
        self.name =dict[@"name"];
        self.typeId =dict[@"type"] ;
            }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.image_url forKey:@"image_url"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.typeId forKey:@"type"];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.image_url =  [coder decodeObjectForKey:@"image_url"];
        self.name =  [coder decodeObjectForKey:@"name"];
        self.typeId =  [coder decodeObjectForKey:@"type"];
    }
    return self;
}

@end
