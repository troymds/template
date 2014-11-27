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
#import "interfaceController.h"
#import "companyJOBController.h"
#import "marketController.h"
#import "RemindView.h"
#import "searchTableViewController.h"
#define YYBODERW 16
#define YYBODERY 11
#define BtnWidth 288
@interface SearchViewController ()
{
    UIView *backMenuView;
    UIButton *classBackBtn;
    UIButton *_selectBtn;
    UIButton *classBtn;
    UITextField *keyText;
}
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =HexRGB(0xe9f1f6);
    self.title = @"关键词搜索";
    _selectBtn =[[UIButton alloc]init];

    [self addChooseClass];
    
    

}
-(void)addChooseClass{
    
    
   UIView *backClassView =[[UIView alloc]initWithFrame:CGRectMake(YYBODERW, YYBODERY+64, BtnWidth, 45)];
    [self.view addSubview:backClassView];
    backClassView.backgroundColor =[UIColor lightGrayColor];
    
     classBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [classBtn setTitle:@"请选择分类" forState:UIControlStateNormal];
    [self.view addSubview:classBtn];
    [classBtn setTitleColor:HexRGB(0xc3c3c3) forState:UIControlStateNormal];
    classBtn.backgroundColor =[UIColor whiteColor];
    classBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    classBtn.frame =CGRectMake(YYBODERW+1, YYBODERY+65, kWidth-YYBODERW*2-2, 43);
    [classBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [classBtn setImage:[UIImage imageNamed:@"menu_up_img.png"] forState:UIControlStateNormal];
    [classBtn setImage:[UIImage imageNamed:@"menu_down_img.png"] forState:UIControlStateSelected];
    classBtn.imageEdgeInsets =UIEdgeInsetsMake(0, kWidth-YYBODERW*2-35, 0, 0);
    [classBtn addTarget:self action:@selector(classBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    classBtn.selected = YES;
    
    
    UIView *backView =[[UIView alloc]initWithFrame:CGRectMake(kWidth-YYBODERW*2-40 , 5, 1, 35)];
    [classBtn addSubview:backView];
    backView.backgroundColor =[UIColor lightGrayColor];
    
    UIView *backLineField =[[UIView alloc]initWithFrame:CGRectMake(YYBODERW-1, 131, BtnWidth+2, 45)];
    [self.view addSubview:backLineField];
    backLineField.backgroundColor =[UIColor lightGrayColor];
    
     keyText =[[UITextField alloc]initWithFrame:CGRectMake(YYBODERW, 132, BtnWidth, 43)];
    [self.view addSubview:keyText];
    keyText.borderStyle =UITextBorderStyleNone;
    keyText.backgroundColor =HexRGB(0xffffff);
    keyText.placeholder =@"   请输入关键词";
    keyText.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    YYSearchButton *searchBtn =[YYSearchButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setTitleColor:HexRGB(0xffffff) forState:UIControlStateNormal];
    [self.view addSubview:searchBtn];
    searchBtn.backgroundColor =HexRGB(0x9be4aa);
    searchBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentCenter;
    searchBtn.frame =CGRectMake(YYBODERW, 300, kWidth-YYBODERW*2, 42);
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
    
    
     backMenuView =[[UIView alloc]initWithFrame:CGRectMake(YYBODERW, YYBODERY+110, kWidth-YYBODERW*2, 91)];
    [self.view addSubview:backMenuView];
    backMenuView.backgroundColor =[UIColor lightGrayColor];
    
    for (int i=0; i<3; i++) {
        NSArray *titleArr=@[@"产品管理",@"供求商机",@"企业招聘"];
        UIButton *classMenuBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        classMenuBtn.frame =CGRectMake(1, 1+i%3*30, kWidth-YYBODERW*2-2, 29);
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
    if (_selectBtn.tag ==0) {
        [RemindView showViewWithTitle:@"请选择分类!" location:MIDDLE];
    }else{
    searchTableViewController *searchVC =[[searchTableViewController alloc]init];
    searchVC.searchSelectedIndex = _selectBtn.tag;
    searchVC.titleStr =classBtn.titleLabel.text;
    searchVC.keyWordesIndex =keyText.text;
    [self.navigationController pushViewController:searchVC animated:YES];
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
