//
//  MainController.m
//  NewView
//
//  Created by YY on 14-11-18.
//  Copyright (c) 2014年 ___普而摩___. All rights reserved.
//

#import "MainController.h"
#import "AppMacro.h"
#import "UIBarButtonItem+MJ.h"
#import "WBNavigationController.h"

#import "marketController.h"//市场行情
#import "aboutController.h"//关于我们
#import "businessController.h"//"供求商机
#import "companyJOBController.h"//企业招聘
#import "companyYellowController.h"//企业黄页
#import "interfaceController.h"//展会信息
#import "moreController.h"//更多内容
#import "productController.h"//产品管理
#import "squareController.h"//话题广场
#import "SearchViewController.h"//搜索热词
#import "PersonCenterController.h"

@interface MainController ()

@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =[UIColor whiteColor];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    UIButton * _searchImage =[UIButton buttonWithType:UIButtonTypeCustom];
    _searchImage.frame =CGRectMake(0, 0, kWidth-120, 30);
    [self.view addSubview:_searchImage];
    self.navigationItem.titleView =_searchImage;
    [_searchImage setImage:[UIImage imageNamed:@"nav_searchhome.png"] forState:UIControlStateNormal];
    [_searchImage setImage:[UIImage imageNamed:@"nav_searchhome.png"] forState:UIControlStateHighlighted];
    [_searchImage addTarget:self action:@selector(searchBarBtn) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithSearch:@"nav_code.png" highlightedSearch:@"vav_code_pre.png" target:(self) action:@selector(zbarSdk)];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithSearch:@"nav_logo.png" highlightedSearch:@"nav_logo.png" target:(self) action:nil];
    self.view.userInteractionEnabled = YES;
    
    
    [self ADDMainBtn];//添加首页按钮
    
  
}

-(void)ADDMainBtn{
    CGFloat leftDistace = 20;                              //第一列图片距离左边的距离
    CGFloat width = 80;                                    //图片宽高
    CGFloat distance = (kWidth-width*3-leftDistace*2)/2;   //每行图片的中间距离
    CGFloat topDistace  = 20;                              //第一列图片距顶部的距离
    
    for (int i=0; i<9; i++) {
        NSArray *titleArray =@[@"市场行情",@"企业黄页",@"供求商机",@"产品管理",@"话题广场",@"关于我们",@"企业招聘",@"展会信息",@"更多内容"];
        UIImageView *MainImage =[[UIImageView alloc]init];
        MainImage.frame =CGRectMake(leftDistace+i%3*(width+distance), topDistace+10+i/3*(kHeight/3-30),width,width);
        MainImage.backgroundColor =[UIColor redColor];
        [self.view addSubview:MainImage];
        MainImage.userInteractionEnabled = YES;
        
        UIButton *titleBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:titleBtn];
        titleBtn.frame =CGRectMake(leftDistace+i%3*(width+distance), topDistace+100+i/3*(kHeight/3-30), width, 30);
        [titleBtn setTitle:titleArray[i] forState:UIControlStateNormal];
        titleBtn.titleLabel.font =[UIFont systemFontOfSize:16];
        [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage:)];
        [MainImage addGestureRecognizer:singleTap];
        MainImage.tag = 10+i;
    }
}



-(void)onClickImage:(UITapGestureRecognizer *)img{
    
    UIImageView *view = (UIImageView *)[img view ];
    NSInteger tagvalue = view.tag;
    
    if (tagvalue==10) {
        marketController *marketVC =[[marketController alloc]init];
        

        [self.navigationController pushViewController:marketVC animated:YES];
    }else if(tagvalue ==11)
    {
        companyYellowController *companyYellowVC =[[companyYellowController alloc]init];
        [self.navigationController pushViewController:companyYellowVC animated:YES];
    }else if(tagvalue ==12)
    {
        businessController *businessVC =[[businessController alloc]init];
        [self.navigationController pushViewController:businessVC animated:YES];
    }else if(tagvalue ==13)
    {
        productController *productVC =[[productController alloc]init];
        [self.navigationController pushViewController:productVC animated:YES];
    }else if(tagvalue ==14)
    {
        squareController *squareVC =[[squareController alloc]init];
        [self.navigationController pushViewController:squareVC animated:YES];
    }else if(tagvalue ==15)
    {
        aboutController *aboutVC =[[aboutController alloc]init];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }else if(tagvalue ==16)
    {
        companyJOBController *companyJOBVC =[[companyJOBController alloc]init];
        [self.navigationController pushViewController:companyJOBVC animated:YES];
    }else if(tagvalue ==17)
    {
        interfaceController *interfaceVC =[[interfaceController alloc]init];
        [self.navigationController pushViewController:interfaceVC animated:YES];
    }else
    {
        moreController *moreVC =[[moreController alloc]init];
        [self.navigationController pushViewController:moreVC animated:YES];
    }
}
-(void)backItem{
    [self.navigationController popViewControllerAnimated:YES];}
-(void)searchBarBtn{
    SearchViewController *search =[[SearchViewController alloc]init];
    [self.navigationController pushViewController:search animated:YES];
}
-(void)zbarSdk{
    PersonCenterController *person = [[PersonCenterController alloc] init];
    [self.navigationController pushViewController:person animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
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
