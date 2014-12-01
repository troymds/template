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
#import "homeModel.h"
#import "homeTool.h"
#define khotImageFilePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"hotImage.data"]
@interface MainController ()
{
    NSMutableArray *_homeArray;
}
@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    _homeArray =[NSMutableArray array];
    _hotImageArrayOff =[NSMutableArray array];

    self.view.backgroundColor =HexRGB(0xededed);
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
    
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithSearch:@"pressent_img" highlightedSearch:@"pressent_img" target:(self) action:@selector(zbarSdk)];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithSearch:@"nav_logo.png" highlightedSearch:@"nav_logo.png" target:(self) action:nil];
    self.view.userInteractionEnabled = YES;
    
    [self addMBprogressView];
    [self addLoadStatus];
   
    
  
}
#pragma  mark ------显示指示器
-(void)addMBprogressView{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    
    
}

#pragma mark---加载数据
-(void)addLoadStatus{
    [homeTool statusesWithSuccess:^(NSArray *statues) {
        [_hotImageArrayOff removeAllObjects];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [_homeArray addObjectsFromArray:statues];
        [self ADDMainBtn];
        //归档离线数据
        [NSKeyedArchiver archiveRootObject:_homeArray toFile:khotImageFilePath];
    } failure:^(NSError *error) {
        self.hotImageArrayOff = [NSKeyedUnarchiver unarchiveObjectWithFile:khotImageFilePath];
        [self ADDMainBtnFail];
        if (_hotImageArrayOff.count ==0) {
            [self addFirstImage];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [RemindView showViewWithTitle:@"网络错误" location:BELLOW];
    }];
}
#pragma mark---UI
-(void)ADDMainBtn{
    CGFloat leftDistace = 20;                              //第一列图片距离左边的距离
    CGFloat width = 80;                                    //图片宽高
    CGFloat distance = (kWidth-width*3-leftDistace*2)/2;   //每行图片的中间距离
    CGFloat topDistace  = 20;                              //第一列图片距顶部的距离
    
    for (int i=0; i<_homeArray.count; i++) {
        homeModel *homeMode =[_homeArray objectAtIndex:i];
        UIImageView *MainImage =[[UIImageView alloc]init];
        MainImage.frame =CGRectMake(leftDistace+i%3*(width+distance), topDistace+10+i/3*(kHeight/3-30),width,width);
        [MainImage setImageWithURL:[NSURL URLWithString:homeMode.image_url] placeholderImage:placeHoderImage1];
        MainImage.backgroundColor =[UIColor clearColor];
        [self.view addSubview:MainImage];
        MainImage.userInteractionEnabled = YES;
        
        UIButton *titleBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:titleBtn];
        titleBtn.frame =CGRectMake(leftDistace+i%3*(width+distance), topDistace+100+i/3*(kHeight/3-30), width, 30);
        [titleBtn setTitleColor:HexRGB(0x3a3a3a) forState:UIControlStateNormal];
        [titleBtn setTitle:homeMode.name forState:UIControlStateNormal];
        titleBtn.titleLabel.font =[UIFont systemFontOfSize:18];
        [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
      
        UIButton *bigBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:bigBtn];
        bigBtn.frame =CGRectMake(leftDistace+i%3*(width+distance), topDistace+10+i/3*(kHeight/3-30), width, width+35);
        [bigBtn  addTarget:self action:@selector(titbtnClick:) forControlEvents:UIControlEventTouchUpInside];
        bigBtn.backgroundColor =[UIColor clearColor];
       
        NSString *aNumberString = homeMode.typeId;
        int type_id = [aNumberString intValue];

        bigBtn.tag =type_id;
                   }
}
-(void)addFirstImage{
    CGFloat leftDistace = 20;                              //第一列图片距离左边的距离
    CGFloat width = 80;                                    //图片宽高
    CGFloat distance = (kWidth-width*3-leftDistace*2)/2;   //每行图片的中间距离
    CGFloat topDistace  = 20;
    for (int i=0; i<9; i++) {
        UIImageView *MainImage =[[UIImageView alloc]init];
        MainImage.frame =CGRectMake(leftDistace+i%3*(width+distance), topDistace+10+i/3*(kHeight/3-30),width,width);
        MainImage.image = placeHoderImage1;
        MainImage.backgroundColor =[UIColor clearColor];
        [self.view addSubview:MainImage];
        MainImage.userInteractionEnabled = YES;
    }
}
#pragma mark---FailUI
-(void)ADDMainBtnFail{
    CGFloat leftDistace = 20;                              //第一列图片距离左边的距离
    CGFloat width = 80;                                    //图片宽高
    CGFloat distance = (kWidth-width*3-leftDistace*2)/2;   //每行图片的中间距离
    CGFloat topDistace  = 20;                              //第一列图片距顶部的距离
    
    for (int i=0; i<_hotImageArrayOff.count; i++) {
        homeModel *homeMode =[_hotImageArrayOff objectAtIndex:i];
        UIImageView *MainImage =[[UIImageView alloc]init];
        MainImage.frame =CGRectMake(leftDistace+i%3*(width+distance), topDistace+10+i/3*(kHeight/3-30),width,width);
        [MainImage setImageWithURL:[NSURL URLWithString:homeMode.image_url] placeholderImage:placeHoderImage1];
        MainImage.backgroundColor =[UIColor clearColor];
        [self.view addSubview:MainImage];
        MainImage.userInteractionEnabled = YES;
        
        UIButton *titleBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:titleBtn];
        titleBtn.frame =CGRectMake(leftDistace+i%3*(width+distance), topDistace+100+i/3*(kHeight/3-30), width, 30);
        [titleBtn setTitleColor:HexRGB(0x3a3a3a) forState:UIControlStateNormal];
        [titleBtn setTitle:homeMode.name forState:UIControlStateNormal];
        titleBtn.titleLabel.font =[UIFont systemFontOfSize:18];
        [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        
        UIButton *bigBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:bigBtn];
        bigBtn.frame =CGRectMake(leftDistace+i%3*(width+distance), topDistace+10+i/3*(kHeight/3-30), width, width+35);
        [bigBtn  addTarget:self action:@selector(titbtnFailClick:) forControlEvents:UIControlEventTouchUpInside];
        bigBtn.backgroundColor =[UIColor clearColor];
        
        NSString *aNumberString = homeMode.typeId;
        int type_id = [aNumberString intValue];
        
        bigBtn.tag =type_id;
    }
}
-(void)titbtnFailClick:(UIButton *)tit{
    
    
        [RemindView showViewWithTitle:@"网络错误" location:BELLOW];
        
        return ;
    }


-(void)titbtnClick:(UIButton *)tit{
    
       if (tit.tag==1) {
        marketController *marketVC =[[marketController alloc]init];
        
        
        [self.navigationController pushViewController:marketVC animated:YES];
    }else if(tit.tag ==2)
    {
        companyYellowController *companyYellowVC =[[companyYellowController alloc]init];
        [self.navigationController pushViewController:companyYellowVC animated:YES];
    }else if(tit.tag ==3)
    {
        businessController *businessVC =[[businessController alloc]init];
        [self.navigationController pushViewController:businessVC animated:YES];
    }else if(tit.tag ==4)
    {
        productController *productVC =[[productController alloc]init];
        [self.navigationController pushViewController:productVC animated:YES];
    }else if(tit.tag ==5)
    {
        squareController *squareVC =[[squareController alloc]init];
        [self.navigationController pushViewController:squareVC animated:YES];
    }else if(tit.tag ==6)
    {
        aboutController *aboutVC =[[aboutController alloc]init];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }else if(tit.tag ==7)
    {
        companyJOBController *companyJOBVC =[[companyJOBController alloc]init];
        [self.navigationController pushViewController:companyJOBVC animated:YES];
    }else if(tit.tag ==8)
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
