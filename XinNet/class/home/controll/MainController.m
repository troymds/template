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
#import "adsModel.h"
#import "moduleModel.h"
#import "homeTool.h"
#define khotImageFilePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"hotImage.data"]
#define kadsImageFilePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"adsImage.data"]
#define klogoImageFilePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"logoImage.data"]


@interface MainController ()
{
    NSMutableArray *_adsArray;
    NSMutableArray *_moduleArray;
    homeModel *_homeModel;
    
}
@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    _adsArray =[NSMutableArray array];
    _moduleArray =[NSMutableArray array];
    _hotImageArrayOff =[NSMutableArray array];
    _adsImageArrayOff =[NSMutableArray array];
    _logoArrayOff =[[NSString alloc]init];


    
    _slideImages = [[NSMutableArray alloc] init];

    self.view.backgroundColor =HexRGB(0xf5f0ef);
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithSearch:@"pressent_img" highlightedSearch:@"pressent_img" target:(self) action:@selector(zbarSdk)];
   
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
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        NSDictionary *dict =[statues objectAtIndex:0];
        _homeModel =[[homeModel alloc]init];
        _homeModel.ads =[dict objectForKey:@"ads"];
        _homeModel.module =[dict objectForKey:@"module"];
        _homeModel.logo =[dict objectForKey:@"logo"];
        [self addNavImage];
        [NSKeyedArchiver archiveRootObject:_homeModel.logo  toFile:klogoImageFilePath];

        for (NSDictionary *dict in _homeModel.ads) {
            adsModel *adsMod=[[adsModel alloc]initWithDictionaryForHomeAds:dict];
            [_adsArray addObject:adsMod];
        }
        [NSKeyedArchiver archiveRootObject:_adsArray toFile:kadsImageFilePath];

        for (NSDictionary *moDict in _homeModel.module) {
            moduleModel *modulModel =[[moduleModel alloc]initWithDictionaryForHomeModule:moDict];
            [_moduleArray addObject:modulModel];
        }

        //归档离线数据
        [NSKeyedArchiver archiveRootObject:_moduleArray toFile:khotImageFilePath];

        [self initBannerView];
        [self addADSimageBtn:_adsArray];
        [self addCategorybutton:_moduleArray];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [RemindView showViewWithTitle:@"网络错误" location:BELLOW];

        NSLog(@"error");
        self.hotImageArrayOff = [NSKeyedUnarchiver unarchiveObjectWithFile:khotImageFilePath];
        self.adsImageArrayOff =[NSKeyedUnarchiver unarchiveObjectWithFile:kadsImageFilePath];
        self.logoArrayOff = [NSKeyedUnarchiver unarchiveObjectWithFile:klogoImageFilePath];

        [self addFailbutton:_hotImageArrayOff];
        if (_hotImageArrayOff.count ==0) {
            [self addFirstImage];
        }
        [self initBannerView];
        [self addADSimageBtn:_adsImageArrayOff];
        [self addNavImageFail];
            }];
}

-(void)addNavImage{
    UIView *nav_View =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth-44, 44)];
    [self.view addSubview:nav_View];
    nav_View.backgroundColor =[UIColor clearColor];
    self.navigationItem.titleView =nav_View;

    UIButton * _searchImage =[UIButton buttonWithType:UIButtonTypeCustom];
    _searchImage.frame =CGRectMake(60, 7, kWidth-120, 30);
    _searchImage.backgroundColor =[UIColor clearColor];
    [nav_View addSubview:_searchImage];
    [_searchImage setImage:[UIImage imageNamed:@"nav_searchhome.png"] forState:UIControlStateNormal];
    [_searchImage setImage:[UIImage imageNamed:@"nav_searchhome.png"] forState:UIControlStateHighlighted];
    [_searchImage addTarget:self action:@selector(searchBarBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *navLogoImage =[[UIImageView alloc]initWithFrame:CGRectMake(-60, 0, 60, 30)];
    [_searchImage addSubview:navLogoImage];
    navLogoImage.image =placeHoderImage3;
    navLogoImage.contentMode = UIViewContentModeScaleAspectFit;
    

    [navLogoImage setImageWithURL:[NSURL URLWithString:_homeModel.logo] placeholderImage:placeHoderImage3];
}
-(void)addNavImageFail{
    UIView *nav_View =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth-44, 44)];
    [self.view addSubview:nav_View];
    nav_View.backgroundColor =[UIColor clearColor];
    self.navigationItem.titleView =nav_View;
    
    UIButton * _searchImage =[UIButton buttonWithType:UIButtonTypeCustom];
    _searchImage.frame =CGRectMake(60, 7, kWidth-120, 30);
    _searchImage.backgroundColor =[UIColor clearColor];
    [nav_View addSubview:_searchImage];
    [_searchImage setImage:[UIImage imageNamed:@"nav_searchhome.png"] forState:UIControlStateNormal];
    [_searchImage setImage:[UIImage imageNamed:@"nav_searchhome.png"] forState:UIControlStateHighlighted];
    [_searchImage addTarget:self action:@selector(searchBarBtnFail) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *navLogoImage =[[UIImageView alloc]initWithFrame:CGRectMake(-60, 0, 60, 30)];
    [_searchImage addSubview:navLogoImage];
    navLogoImage.image =placeHoderImage3;
    
    [navLogoImage setImageWithURL:[NSURL URLWithString:_logoArrayOff] placeholderImage:placeHoderImage3];
    

}
-(void)searchBarBtnFail{
    [RemindView showViewWithTitle:@"网络错误" location:BELLOW];
    
    return ;
}

-(void)addADSimageBtn:(NSMutableArray *)tody
{
    
    
    // 创建图片 imageview
    for (int i = 0;i<[tody count];i++)
    {
        adsModel *ads =[tody objectAtIndex:i];
        [_slideImages addObject:ads.image_url];
        
    }
}
-(void)initBannerView{
    UIImageView *bannView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth,118)];
    [self.view addSubview:bannView];
    bannView.image =[UIImage imageNamed:@"load_big.png"];
    _bannerView =[[KDCycleBannerView alloc] initWithFrame:CGRectMake(0, 0,kWidth,118)];
    
    _bannerView.datasource = self;
    _bannerView.delegate = self;
    _bannerView.continuous = YES;
    _bannerView.autoPlayTimeInterval = 3;
    [self.view addSubview:_bannerView];
}
- (NSArray *)numberOfKDCycleBannerView:(KDCycleBannerView *)bannerView{
    
    
    return _slideImages;
}
- (UIViewContentMode)contentModeForImageIndex:(NSUInteger)index{
    return UIViewContentModeScaleAspectFill;
}
- (UIImage *)placeHolderImageOfBannerView:(KDCycleBannerView *)bannerView atIndex:(NSUInteger)index{
    return placeHoderImage3;
}
// 滚动到第几个图片
- (void)cycleBannerView:(KDCycleBannerView *)bannerView didScrollToIndex:(NSUInteger)index{
    
}
// 选中第几个图片
- (void)cycleBannerView:(KDCycleBannerView *)bannerView didSelectedAtIndex:(NSUInteger)index{
    
   }


#pragma mark---UI
-(void)addCategorybutton:(NSMutableArray *)btnImgArray
{
    CGFloat leftDistace;
    CGFloat width;
    CGFloat distance;
    CGFloat topDistace;
    if (IsIos7) {
        leftDistace = 20;                              //第一列图片距离左边的距离
        width = 70;                                    //图片宽高
        distance = (kWidth-width*3-leftDistace*2)/2;   //每行图片的中间距离
        topDistace  = 10;
    }else{

        leftDistace = 25;                              //第一列图片距离左边的距离
        width = 60;                                    //图片宽高
        distance = (kWidth-width*3-leftDistace*2)/2;   //每行图片的中间距离
        topDistace  = 0;

    }
                                 //第一列图片距顶部的距离
    
    for (int i=0; i<_moduleArray.count; i++) {
        moduleModel *homeMode =[btnImgArray objectAtIndex:i];
        UIImageView *MainImage =[[UIImageView alloc]init];
        MainImage.frame =CGRectMake(leftDistace+i%3*(width+distance), topDistace+130+i/3*(kHeight/3-width),width,width);
        [MainImage setImageWithURL:[NSURL URLWithString:homeMode.image_url] placeholderImage:placeHoderImage1];
        MainImage.backgroundColor =[UIColor clearColor];
        [self.view addSubview:MainImage];
        MainImage.userInteractionEnabled = YES;
        
        UIButton *titleBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:titleBtn];
        titleBtn.frame =CGRectMake(leftDistace+i%3*(width+distance), topDistace+130+width+i/3*(kHeight/3-width), width, 30);
        [titleBtn setTitleColor:HexRGB(0x3a3a3a) forState:UIControlStateNormal];
        [titleBtn setTitle:homeMode.name forState:UIControlStateNormal];
        titleBtn.titleLabel.font =[UIFont systemFontOfSize:15];
        [titleBtn setTitleColor:HexRGB(0x666666) forState:UIControlStateNormal];
        
      
        UIButton *bigBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:bigBtn];
        bigBtn.frame =CGRectMake(leftDistace+i%3*(width+distance), topDistace+130+i/3*(kHeight/3-width), width, width+35);
        [bigBtn  addTarget:self action:@selector(titbtnClick:) forControlEvents:UIControlEventTouchUpInside];
        bigBtn.backgroundColor =[UIColor clearColor];
       
        NSString *aNumberString = homeMode.typeID;
        int type_id = [aNumberString intValue];

        bigBtn.tag =type_id;
                   }
}
-(void)addFirstImage{
    UIImageView *adsImageBanner=[[UIImageView alloc]initWithFrame:CGRectMake(16, 0, kWidth-32, 118)];
    [self.view addSubview:adsImageBanner];
    adsImageBanner.image =placeHoderImage3;
    
    CGFloat leftDistace = 20;                              //第一列图片距离左边的距离
    CGFloat width = 70;                                    //图片宽高
    CGFloat distance = (kWidth-width*3-leftDistace*2)/2;   //每行图片的中间距离
    CGFloat topDistace  = 20;
    for (int i=0; i<9; i++) {
        UIButton *MainImage =[UIButton buttonWithType:UIButtonTypeCustom];
        MainImage.frame =CGRectMake(leftDistace+i%3*(width+distance), topDistace+130+i/3*(kHeight/3-70),width,width);
        [MainImage setImage:placeHoderImage1 forState:UIControlStateNormal];
        [self.view addSubview:MainImage];
        MainImage.userInteractionEnabled = YES;
        [MainImage addTarget:self action:@selector(mainImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)mainImageBtnClick:(UIButton *)main{
    [RemindView showViewWithTitle:@"网络断开，请连接！" location:BELLOW];
}
#pragma mark---FailUI
-(void)addFailbutton:(NSMutableArray *)ImgArray
{
    CGFloat leftDistace;
    CGFloat width;
    CGFloat distance;
    CGFloat topDistace;
    if (IsIos7) {
        leftDistace = 20;                              //第一列图片距离左边的距离
        width = 70;                                    //图片宽高
        distance = (kWidth-width*3-leftDistace*2)/2;   //每行图片的中间距离
        topDistace  = 10;
    }else{
        
        leftDistace = 25;                              //第一列图片距离左边的距离
        width = 60;                                    //图片宽高
        distance = (kWidth-width*3-leftDistace*2)/2;   //每行图片的中间距离
        topDistace  = 0;
        
    }
    //第一列图片距顶部的距离
    
    for (int i=0; i<_hotImageArrayOff.count; i++) {
        moduleModel *homeMode =[ImgArray objectAtIndex:i];
        UIImageView *MainImage =[[UIImageView alloc]init];
        MainImage.frame =CGRectMake(leftDistace+i%3*(width+distance), topDistace+130+i/3*(kHeight/3-width),width,width);
        [MainImage setImageWithURL:[NSURL URLWithString:homeMode.image_url] placeholderImage:placeHoderImage1];
        MainImage.backgroundColor =[UIColor clearColor];
        [self.view addSubview:MainImage];
        MainImage.userInteractionEnabled = YES;
        
        UIButton *titleBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:titleBtn];
        titleBtn.frame =CGRectMake(leftDistace+i%3*(width+distance), topDistace+130+width+i/3*(kHeight/3-width), width, 30);
        [titleBtn setTitleColor:HexRGB(0x3a3a3a) forState:UIControlStateNormal];
        [titleBtn setTitle:homeMode.name forState:UIControlStateNormal];
        titleBtn.titleLabel.font =[UIFont systemFontOfSize:15];
        [titleBtn setTitleColor:HexRGB(0x666666) forState:UIControlStateNormal];
        
        
        UIButton *bigBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:bigBtn];
        bigBtn.frame =CGRectMake(leftDistace+i%3*(width+distance), topDistace+130+i/3*(kHeight/3-width), width, width+35);
        [bigBtn  addTarget:self action:@selector(titbtnFailClick:) forControlEvents:UIControlEventTouchUpInside];
        bigBtn.backgroundColor =[UIColor clearColor];
        
        NSString *aNumberString = homeMode.typeID;
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
    if (_adsImageArrayOff.count>0) {
        [RemindView showViewWithTitle:@"网络错误" location:BELLOW];
        
        return ;
    }else{
    PersonCenterController *person = [[PersonCenterController alloc] init];
    [self.navigationController pushViewController:person animated:YES];
    }
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
