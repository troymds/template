//
//  TJImageView.h
//  XinNet
//
//  Created by Tianj on 14/11/18.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TJImageView;

@protocol TJImageViewDelegate <NSObject>

@optional

- (void)imageViewClick:(TJImageView *)view;

@end

@interface TJImageView : UIImageView

@property (nonatomic,weak) id <TJImageViewDelegate> delegate;

@end
