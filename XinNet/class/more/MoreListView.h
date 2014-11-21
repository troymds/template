//
//  MoreListView.h
//  XinNet
//
//  Created by tianj on 14-11-19.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MoreListView;
@protocol MoreListViewDelegate <NSObject>

@optional

- (void)moreListViewClick:(MoreListView *)view;

@end

@interface MoreListView : UIView

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,weak) id<MoreListViewDelegate> delegate;

@end
