//
//  CategoryView.h
//  XinNet
//
//  Created by tianj on 14-12-2.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryListView.h"

@protocol CategoryViewDelegate <NSObject>

@optional

- (void)categoryClick:(CategoryListView *)view;

- (void)tapClick;

@end

@interface CategoryView : UIView<categoryListViewDelegate>

@property (nonatomic,weak) id <CategoryViewDelegate> delegate;


@end
