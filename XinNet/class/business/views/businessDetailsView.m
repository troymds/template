//
//  businessDetailsView.m
//  NewView
//
//  Created by YY on 14-11-18.
//  Copyright (c) 2014年 ___普而摩___. All rights reserved.
//

#import "businessDetailsView.h"

@interface businessDetailsView ()

@end

@implementation businessDetailsView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    self.title =@"详情";
    [self addLabel];
}
-(void)addLabel{
    UILabel *titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 74, kWidth, 20)];
    titleLabel.text =@"标题";
    titleLabel.font =[UIFont systemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    
    for (int i=0; i<2; i++) {
        NSArray *titleArr =@[@"时间:",@"数量:"];
        UILabel *titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(20+i%3*(kWidth/2), 114, kWidth/2-40, 20)];
        titleLabel.text =titleArr[i];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor =[UIColor clearColor];

        titleLabel.font =[UIFont systemFontOfSize:15];
        [self.view addSubview:titleLabel];

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
