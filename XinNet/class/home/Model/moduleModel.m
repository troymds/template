//
//  moduleModel.m
//  XinNet
//
//  Created by YY on 14-12-2.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "moduleModel.h"

@implementation moduleModel
@synthesize typeID,name,image_url;
- (instancetype)initWithDictionaryForHomeModule:(NSDictionary *)dict{
    if ([super self]) {
        self.typeID =dict[@"type"];
        self.name =dict[@"name"];
        self.image_url =dict[@"image_url"];
        
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.image_url forKey:@"image_url"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.typeID forKey:@"type"];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.image_url =  [coder decodeObjectForKey:@"image_url"];
        self.name =  [coder decodeObjectForKey:@"name"];
        self.typeID =  [coder decodeObjectForKey:@"type"];
    }
    return self;
}

@end
