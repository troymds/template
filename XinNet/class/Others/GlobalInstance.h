//
//  GlobalInstance.h
//  XinNet
//
//  Created by Tianj on 14/11/20.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalInstance : NSObject

@property (nonatomic,assign) BOOL isLogin;

+ (GlobalInstance *)sharedInstance;


@end
