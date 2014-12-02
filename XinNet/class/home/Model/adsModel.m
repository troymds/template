//
//  adsModel.m
//  XinNet
//
//  Created by YY on 14-12-2.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "adsModel.h"

@implementation adsModel
@synthesize app_id,image_url,typeID;
- (instancetype)initWithDictionaryForHomeAds:(NSDictionary *)dict{
    if ([super self]) {
        self.app_id =dict[@"app_id"];
        self.image_url =dict[@"image_url"];
        self.typeID =dict[@"id"];

        
    }
    return  self;
}
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.app_id forKey:@"app_id"];
    [coder encodeObject:self.typeID forKey:@"id"];
    [coder encodeObject:self.image_url forKey:@"image_url"];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.image_url =  [coder decodeObjectForKey:@"image_url"];
        self.app_id =  [coder decodeObjectForKey:@"app_id"];
        self.typeID =  [coder decodeObjectForKey:@"id"];
    }
    return self;
}

@end
