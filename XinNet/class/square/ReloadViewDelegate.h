//
//  ReloadViewDelegate.h
//  XinNet
//
//  Created by tianj on 14-11-27.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ReloadViewDelegate <NSObject>

@optional

- (void)reloadView;

- (void)reloadTableView;

@end
