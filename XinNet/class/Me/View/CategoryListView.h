//
//  CategoryListView.h
//  XinNet
//
//  Created by tianj on 14-11-25.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CategoryListView;

@protocol categoryListViewDelegate <NSObject>


@optional

- (void)cateListClick:(CategoryListView *)view;


@end


@interface CategoryListView : UIView


@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,weak) id<categoryListViewDelegate> delegate;

@end

