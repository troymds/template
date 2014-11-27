//
//  PublishController.h
//  XinNet
//
//  Created by Tianj on 14/11/22.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishController : UIViewController

@property (nonatomic,assign) BOOL isPublish;  //用于判断是求购发布页面还是编辑页面
@property (nonatomic,copy) NSString *uid;

@end
