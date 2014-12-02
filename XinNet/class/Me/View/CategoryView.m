//
//  CategoryView.m
//  XinNet
//
//  Created by tianj on 14-12-2.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "CategoryView.h"

@interface CategoryView ()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UITapGestureRecognizer *_tap;
}
@end

@implementation CategoryView



- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.3;
        [self addSubview:bgView];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(frame.size.width-150,0, 150,frame.size.height)];
        _scrollView.backgroundColor = HexRGB(0xededed);
        _scrollView.delegate = self;
        _scrollView.layer.borderColor = HexRGB(0xd5d5d5).CGColor;
        [self addSubview:_scrollView];
        
        NSMutableArray *imgArray = [NSMutableArray arrayWithObjects:@"",@"catemarket.png",@"catecompany.png",@"catebusiness.png",@"cateplay.png",@"catemanager.png",@"cateadvitise.png", nil];
        NSMutableArray *titileArray = [NSMutableArray arrayWithObjects:@"全部",@"市场行情",@"企业黄页",@"供求商机",@"展会信息",@"产品管理",@"企业招聘",nil];
        
        for (int i = 0 ; i < titileArray.count; i++) {
            UIView *line;
            if (i ==0) {
                line  = [[UIView alloc] initWithFrame:CGRectMake(0,55-1,150,1)];
            }else{
                line = [[UIView alloc] initWithFrame:CGRectMake(0,55+70*i-1,150,1)];
            }
            line.backgroundColor = HexRGB(0xd5d5d5);
            [_scrollView addSubview:line];
        }
        for (int i =0 ; i < titileArray.count; i++) {
            CategoryListView *listView;
            if (i == 0) {
                listView = [[CategoryListView alloc] initWithFrame:CGRectMake(0, 0,150,55)];
                listView.imgView.hidden = YES;
            }else{
                listView = [[CategoryListView alloc] initWithFrame:CGRectMake(0,55+70*(i-1), 150, 70)];
                listView.imgView.image = [UIImage imageNamed:[imgArray objectAtIndex:i]];
                
            }
            listView.titleLabel.text = [titileArray objectAtIndex:i];
            listView.delegate = self;
            listView.tag = 3000+i;
            [_scrollView addSubview:listView];
        }
        if (70*(titileArray.count -1)+55<frame.size.height) {
            [_scrollView setContentSize:CGSizeMake(150,frame.size.height)];
        }else{
            [_scrollView setContentSize:CGSizeMake(150,70*(titileArray.count -1)+55)];
        }
        
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDown)];
        [bgView addGestureRecognizer:_tap];
    }
    return self;
}

- (void)cateListClick:(CategoryListView *)view
{
    if ([self.delegate respondsToSelector:@selector(categoryClick:)]) {
        [self.delegate categoryClick:view];
    }
}

- (void)tapDown
{
    if ([self.delegate respondsToSelector:@selector(tapClick)]) {
        [self.delegate tapClick];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<=0) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    if (scrollView.contentOffset.y>scrollView.contentSize.height) {
        scrollView.contentOffset = CGPointMake(0,scrollView.contentSize.height);
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
