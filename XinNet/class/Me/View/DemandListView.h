//
//  DemandListView.h
//  XinNet
//
//  Created by tianj on 14-11-20.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemandListView : UIView<UITextFieldDelegate>

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UITextField *textField;

- (void)setTitle:(NSString *)title;



@end
