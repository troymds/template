//
//  GlobalInstance.m
//  XinNet
//
//  Created by Tianj on 14/11/20.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "GlobalInstance.h"

@implementation GlobalInstance

+ (GlobalInstance *)sharedInstance{
    static GlobalInstance *config = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        config = [[self alloc] init];
    });
    return config;
}


@end
