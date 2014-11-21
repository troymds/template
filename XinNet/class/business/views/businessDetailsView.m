//
//  businessDetailsView.m
//  NewView
//
//  Created by YY on 14-11-18.
//  Copyright (c) 2014年 ___普而摩___. All rights reserved.
//

#import "businessDetailsView.h"
#define YYBODERW 16
@interface businessDetailsView ()

@end

@implementation businessDetailsView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =HexRGB(0xe9f1f6);
    self.title =@"详情";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithSearch:@"nav_code.png" highlightedSearch:@"vav_code_pre.png" target:(self) action:@selector(collectClick:)];
    [self addLabel];
    
}
//收藏
-(void)collectClick:(UIButton *)collect{
    
}
-(void)addLabel{
    UILabel *titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 74, kWidth, 20)];
    titleLabel.text =@"标题";
    titleLabel.font =[UIFont systemFontOfSize:PxFont(23)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor =HexRGB(0x3a3a3a);
    [self.view addSubview:titleLabel];
    
    
    for (int i=0; i<2; i++) {
        NSArray *titleArr =@[@"时间:",@"数量:"];
        UILabel *titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(20+i%3*(kWidth/2), 114, kWidth/2-40, 20)];
        titleLabel.text =titleArr[i];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor =[UIColor clearColor];
        titleLabel.textColor=HexRGB(0x808080);
        titleLabel.font =[UIFont systemFontOfSize:PxFont(16)];
        [self.view addSubview:titleLabel];

    }
    
    UILabel *contentLabel =[[UILabel alloc]initWithFrame:CGRectMake(YYBODERW, 150, kWidth-YYBODERW*2, 150)];
    contentLabel.text =@"我用充满疑惑的眼神看这个世界充满了对未来的憧憬充满了对未来的憧憬充满了对未来的憧憬充满了对未来的憧憬充满了对未来的憧憬充满了对未来的憧憬充满了对未来的憧憬充满了对未来的憧憬充满了对未来的憧憬充满了对未来的憧憬";
    contentLabel.font =[UIFont systemFontOfSize:PxFont(20)];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.textColor =HexRGB(0x3a3a3a);
    [self.view addSubview:contentLabel];
    contentLabel.numberOfLines =0;
    contentLabel.backgroundColor =[UIColor whiteColor];

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
