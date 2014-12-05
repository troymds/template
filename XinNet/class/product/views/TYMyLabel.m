//
//  TYMyLabel.m
//  ZSEL
//
//  Created by apple on 14-12-4.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "TYMyLabel.h"

@implementation TYMyLabel

-(id) initWithFrame:(CGRect)frame withInsets:(UIEdgeInsets)insets
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.insets = insets;
    }
    return self;
}
-(id)initWithInsets:(UIEdgeInsets)insets
{
    self = [super init];
    if(self)
    {
        self.insets = insets;
    }
    return self;
}

-(void)drawTextInRect:(CGRect)rect
{
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}

@end
