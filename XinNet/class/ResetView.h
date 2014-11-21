//
//  ResetView.h
//  XinNet
//
//  Created by Tianj on 14/11/20.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemandListView.h"

@interface ResetView : UIView

@property (nonatomic,strong) DemandListView *titleListView;
@property (nonatomic,strong) DemandListView *numListView;
@property (nonatomic,strong) DemandListView *contentListView;

- (id)initWithTitle:(NSString *)title;


- (void)show;


@end
