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
#import "aboutTool.h"
#import "aboutModel.h"

#define aboutUsFilePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"aboutus.data"]

@interface aboutController ()
{

    aboutModel *abModel;
}


@end

@implementation aboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.title = @"关于我们";
    self.view.backgroundColor = HexRGB(0xededed);
  
    [self addLoadStatus];
}
-(void)addLoadStatus{

        [aboutTool AboutStatusesWithSuccesscategory:^(NSArray *statues) {
            abModel =[[aboutModel alloc]init];
            NSDictionary *dict =[statues objectAtIndex:0];
            abModel.name =[dict objectForKey:@"name"];
            abModel.company_about =[dict objectForKey:@"company_about"];
            abModel.company_address =[dict objectForKey:@"company_address"];
            abModel.company_email =[dict objectForKey:@"company_email"];
            abModel.company_logo =[dict objectForKey:@"company_logo"];
            abModel.company_tel =[dict objectForKey:@"company_tel"];
            abModel.company_website =[dict objectForKey:@"company_website"];
            abModel.company_weixin =[dict objectForKey:@"company_weixin"];
            
            
            [self addViewWithModel:abModel];
            
        } AboutFailure:^(NSError *error) {
            
        } ];

    
}

- (void)addViewWithModel:(aboutModel *)model
{
    CGFloat leftDistance = 10;    //左边距
    CGFloat topDistance = 10;  //图片距离顶部的距离
    CGFloat imgWidth = kWidth-leftDistance*2;   //图片宽度
    CGFloat imgHeight= 134;   //图片高度
    
    //顶部图片
    UIImageView *topImg = [[UIImageView alloc] init];
    topImg.frame = CGRectMake((kWidth-imgWidth)/2,topDistance,imgWidth,imgHeight);
    
    [topImg setImageWithURL:[NSURL URLWithString:abModel.company_logo] placeholderImage:placeHoderImage3];
    [self.view addSubview:topImg];
    
    CGFloat width = kWidth - leftDistance*2;    //列表宽度
    CGFloat height = 35;   //列表高度
    
    NSArray *array = [NSArray arrayWithObjects:@"软件名称:",@"客户地址:",@"客户电话:",@"客户邮箱:",@"客户官方网址:", nil];
    NSArray *detailArray = [NSArray arrayWithObjects:model.name,model.company_address,model.company_tel,model.company_email,model.company_website, nil];
    
    UIView *bottomBgView = [[UIView alloc] initWithFrame:CGRectMake(leftDistance,topImg.frame.origin.y+topImg.frame.size.height+10,width,array.count*height)];
    bottomBgView.backgroundColor = HexRGB(0xffffff);
    bottomBgView.layer.borderColor = HexRGB(0xd5d5d5).CGColor;
    bottomBgView.layer.borderWidth= 1;
    bottomBgView.layer.cornerRadius = 3.0f;
    bottomBgView.layer.masksToBounds = YES;
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
