//
//  homeModel.m
//  XinNet
//
//  Created by YY on 14-11-27.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "homeModel.h"

@implementation homeModel
@synthesize ads,module,logo;
- (void)encodeWithCoder:(NSCoder *)coder
{
       [coder encodeObject:self.logo forKey:@"logo"];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
               self.logo =  [coder decodeObjectForKey:@"logo"];
    }
    return self;
}

@end
