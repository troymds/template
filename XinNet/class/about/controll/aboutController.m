//
//  aboutController.m
//  NewView
//
//  Created by YY on 14-11-18.
//  Copyright (c) 2014年 ___普而摩___. All rights reserved.
//

#import "aboutController.h"
#import "marketCell.h"
#import "ListView.h"

@interface aboutController ()
{
//    ListView *_nameView;  //软件名称
//    ListView *_addressView; //客户地址
//    ListView *_phoneView;   //客户电话
//    ListView *_emailView;   //客户邮箱
//    ListView *_websiteView; //客户官方网址
}


@end

@implementation aboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.title = @"关于我们";
    self.view.backgroundColor =[UIColor whiteColor];
    
    [self addView];
}


- (void)addView
{
    CGFloat imgWidth = 250;   //图片宽度
    CGFloat imgHeight= 100;   //图片高度
    CGFloat topDistance = 10;  //图片距离顶部的距离
    
    //顶部图片
    UIImageView *topImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    topImg.frame = CGRectMake((kWidth-imgWidth)/2,topDistance,imgWidth,imgHeight);
    topImg.backgroundColor = [UIColor redColor];
    [self.view addSubview:topImg];
    
    CGFloat leftDistance = 10;    //左边距
    CGFloat width = kWidth - leftDistance*2;    //列表宽度
    CGFloat height = 35;   //列表高度
    
    NSArray *array = [NSArray arrayWithObjects:@"软件名称:",@"客户地址:",@"客户电话:",@"客户邮箱:",@"客户官方网址:", nil];
    NSArray *detailArray = [NSArray arrayWithObjects:@"XXXX",@"XXXXXXX",@"XXXXXX",@"XXXXXXXX",@"XXXX",@"XXXXXXX", nil];
    
    UIView *bottomBgView = [[UIView alloc] initWithFrame:CGRectMake(leftDistance,topImg.frame.origin.y+topImg.frame.size.height+10,width,array.count*height)];
    bottomBgView.layer.borderColor = HexRGB(0xd5d5d5).CGColor;
    bottomBgView.layer.borderWidth= 1;
    for (int i = 1 ; i < array.count; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,height*i,width,1)];
        line.backgroundColor = HexRGB(0xd5d5d5);
        [bottomBgView addSubview:line];
    }
    [self.view addSubview:bottomBgView];
    
    for (int i = 0 ; i < array.count ; i++) {
        ListView *listView = [[ListView alloc] initWithFrame:CGRectMake(0, height*i, width, height)];
        [listView setTitle:[array objectAtIndex:i]];
        listView.detailLabel.text = [detailArray objectAtIndex:i];
        [bottomBgView addSubview:listView];
    }
    
//    _nameView = [[ListView alloc] initWithFrame:CGRectMake(0,0,width,height)];
//    _nameView.nameLabel.text = [array objectAtIndex:0];
//    [bottomBgView addSubview:_nameView];
//    
//    _addressView = [[ListView alloc] initWithFrame:CGRectMake(0,height,width,height)];
//    _addressView.nameLabel.text = [array objectAtIndex:1];
//    [bottomBgView addSubview:_addressView];
//    
//    _phoneView = [[ListView alloc] initWithFrame:CGRectMake(0,height*2,width,height)];
//    _phoneView.nameLabel.text = [array objectAtIndex:2];
//    [bottomBgView addSubview:_phoneView];
//    
//    _emailView = [[ListView alloc] initWithFrame:CGRectMake(0,height*3,width,height)];
//    _emailView.nameLabel.text = [array objectAtIndex:3];
//    [bottomBgView addSubview:_emailView];
//    
//    _websiteView = [[ListView alloc] initWithFrame:CGRectMake(0,height*4,width,height)];
//    _websiteView.nameLabel.text = [array objectAtIndex:4];
//    [bottomBgView addSubview:_websiteView];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
