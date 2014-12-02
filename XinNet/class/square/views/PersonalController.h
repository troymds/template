//
//  PersonalController.h
//  XinNet
//
//  Created by tianj on 14-11-19.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReloadViewDelegate.h"

@interface PersonalController : UIViewController

@property (nonatomic,copy) NSString *email;
@property (nonatomic,weak) id <ReloadViewDelegate> delegate;

@end
