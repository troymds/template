//
//  ShareView.h
//  XinNet
//
//  Created by tianj on 14-12-1.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ShareView : NSObject

+ (void)showViewWithTitle:(NSString *)title content:(NSString *)content description:(NSString *)description url:(NSString *)url delegate:(id)delegate;


- (id)initWithTitle:(NSString *)title Content:(NSString *)content description:(NSString *)description url:(NSString *)url delegate:(id)delegate;

- (void)showShareView;

@end
