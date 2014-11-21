//
//  TJImageView.m
//  XinNet
//
//  Created by Tianj on 14/11/18.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "TJImageView.h"

@implementation TJImageView

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

- (id)initWithImage:(UIImage *)image
{
    if (self = [super initWithImage:image]) {
        self.userInteractionEnabled = YES;
    }
    return self;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(imageViewClick:)]) {
        [self.delegate imageViewClick:self];
    }
}

@end
