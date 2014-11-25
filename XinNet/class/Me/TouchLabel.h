//
//  TouchLabel.h
//  XinNet
//
//  Created by Tianj on 14/11/23.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TouchLabel;
@protocol TouchLabelDelegate <NSObject>

@optional

- (void)touchLabelClicked:(TouchLabel *)view;

@end

@interface TouchLabel : UILabel

@property (nonatomic,weak) id <TouchLabelDelegate> delegate;

@end
