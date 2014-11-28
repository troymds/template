//
//  LoginController.h
//  XinNet
//
//  Created by Tianj on 14/11/20.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReloadViewDelegate.h"

@interface LoginController : UIViewController<ReloadViewDelegate>

@property (nonatomic,assign) id <ReloadViewDelegate> delegate;

@end
