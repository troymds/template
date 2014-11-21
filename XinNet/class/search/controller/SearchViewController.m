//
//  SearchViewController.m
//  XinNet
//
//  Created by YY on 14-11-19.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "SearchViewController.h"
#import "YYSearchButton.h"
#import "productController.h"
#import "businessController.h"
#import "companyYellowController.h"
#define YYBODERW 20
#define YYBODERY 10

@interface SearchViewController ()
{
    UIView *backMenuView;
    UIButton *classBackBtn;
    UIButton *_selectBtn;
    UIButton *classBtn;
    
}
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    self.title = @"关键词搜索";
    _selectBtn =[[UIButton alloc]init];

    [self addChooseClass];
    
    

}
-(void)addChooseClass{
    
    
   UIView *backClassView =[[UIView alloc]initWithFrame:CGRectMake(YYBODERW, YYBODERY+64, kWidth-YYBODERW*2, 30)];
    [self.view addSubview:backClassView];
    backClassView.backgroundColor =[UIColor lightGrayColor];
    
     classBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [classBtn setTitle:@"请选择分类" forState:UIControlStateNormal];
    [self.view addSubview:classBtn];
    classBtn.backgroundColor =[UIColor whiteColor];
    classBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    classBtn.frame =CGRectMake(YYBODERW+1, YYBODERY+65, kWidth-YYBODERW*2-2, 28);
    [classBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [classBtn setImage:[UIImage imageNamed:@"finish.png"] forState:UIControlStateNormal];
    [classBtn setImage:[UIImage imageNamed:@"finish1.png"] forState:UIControlStateSelected];
    classBtn.imageEdgeInsets =UIEdgeInsetsMake(0, kWidth-YYBODERW*2-20, 0, 10);
    [classBtn addTarget:self action:@selector(classBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    classBtn.selected = YES;
    
    
    UIView *backView =[[UIView alloc]initWithFrame:CGRectMake(kWidth-YYBODERW*2-30 , 0, 1, 30)];
    [classBtn addSubview:backView];
    backView.backgroundColor =[UIColor lightGrayColor];
    
    
    UITextField *keyText =[[UITextField alloc]initWithFrame:CGRectMake(YYBODERW, 120, kWidth-YYBODERW*2, 30)];
    [self.view addSubview:keyText];
    keyText.borderStyle =UITextBorderStyleBezel;
    keyText.placeholder =@"   请输入关键词";
    keyText.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    YYSearchButton *searchBtn =[YYSearchButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [self.view addSubview:searchBtn];
    searchBtn.backgroundColor =[UIColor lightGrayColor];
    searchBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentCenter;
    searchBtn.frame =CGRectMake(YYBODERW, 160, kWidth-YYBODERW*2, 30);
    [searchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)addClassBackView{
    classBackBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:classBackBtn];
    classBackBtn.alpha =.1;
    classBackBtn.backgroundColor =[UIColor whiteColor];
    classBackBtn.frame =CGRectMake(0, 0, kWidth, kHeight);
    [classBackBtn addTarget:self action:@selector(classBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
 
}
-(void)classBackBtnClick{
    classBtn.selected = YES;

    [classBackBtn removeFromSuperview];
    [backMenuView removeFromSuperview];
}
-(void)addclassMenu{
    
    
     backMenuView =[[UIView alloc]initWithFrame:CGRectMake(YYBODERW, YYBODERY+94, kWidth-YYBODERW*2, 90)];
    [self.view addSubview:backMenuView];
    backMenuView.backgroundColor =[UIColor lightGrayColor];
    
    for (int i=0; i<3; i++) {
        NSArray *titleArr=@[@"产品管理",@"供求商机",@"企业招聘"];
        UIButton *classMenuBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        classMenuBtn.frame =CGRectMake(1, 1+i%3*30, kWidth-YYBODERW*2-2, 28);
        classMenuBtn .backgroundColor =[UIColor whiteColor];
        [classMenuBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [classMenuBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        [backMenuView addSubview:classMenuBtn];
        [classMenuBtn addTarget:self action:@selector(classMenuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        classMenuBtn.selected = _selectBtn.selected;
        classMenuBtn.tag = 200+i;

    }

}
-(void)classBtnClick:(UIButton *)class{
    class.selected =!class.selected;

    if (class.selected==NO) {
        [self addClassBackView];
        [self addclassMenu];
    }else {
        [backMenuView removeFromSuperview];
        [classBackBtn removeFromSuperview];
    }
  }
-(void)classMenuBtnClick:(UIButton *)menu{
    
    _selectBtn.tag = menu.tag;
    classBtn.selected = YES;
    [backMenuView removeFromSuperview];
    [classBackBtn removeFromSuperview];
    
    NSString *currentTitle = menu.currentTitle;
    [classBtn setTitle:currentTitle forState:UIControlStateNormal];

    
   
}

-(void)searchBtnClick:(UIButton *)sear{
    MYNSLog(@"%ld",(long)_selectBtn.tag);

    if (_selectBtn.tag ==200) {
        productController *produVc =[[productController alloc]init];
        [self.navigationController pushViewController:produVc animated:YES];
        
    }else if (_selectBtn.tag ==201){
        businessController *businessVc =[[businessController alloc]init];
        [self.navigationController pushViewController:businessVc animated:YES];
    }else{
        companyYellowController *companyVc =[[companyYellowController alloc]init];
        [self.navigationController pushViewController:companyVc animated:YES];
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
