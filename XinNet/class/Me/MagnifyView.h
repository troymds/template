//
//  MagnifyView.h
//  XinNet
//
//  Created by tianj on 14-12-5.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ManifyViewDelegate <NSObject>

@optional

- (void)ManifyViewClick;

@end

@interface MagnifyView : UIView

@property (nonatomic,weak) id<ManifyViewDelegate> delegate;

- (id)initWithImageView:(UIImageView *)imageView;

- (void)show;

@end
