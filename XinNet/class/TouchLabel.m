//
//  TouchLabel.m
//  XinNet
//
//  Created by Tianj on 14/11/23.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "TouchLabel.h"

@implementation TouchLabel
- (id)init
{
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
    }
    return self;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(touchLabelClicked:)]) {
        [self.delegate touchLabelClicked:self];
    }
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


@end
