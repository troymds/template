//
//  companyDetailsView.m
//  NewView
//
//  Created by YY on 14-11-18.
//  Copyright (c) 2014年 ___普而摩___. All rights reserved.
//

#import "companyDetailsView.h"
#import "YYalertView.h"
#import "collectionModel.h"
#import "collectionHttpTool.h"
#import "companyProfilesView.h"
#import "productController.h"
#import "businessController.h"
#import "companyJOBController.h"
#import <ShareSDK/ShareSDK.h>
#import "CommentController.h"
#import "companyDetailTool.h"
#import "companyDetailsModel.h"
#import "LoginController.h"
#import "companyDetailsModel.h"
#import "ShareView.h"
#import "YYSearchButton.h"
#define YYBODER 16
@interface companyDetailsView ()<YYalertViewDelegate,ReloadViewDelegate>
{
    companyDetailsModel   *companyModel;
    UIScrollView *_backScrollView;
    UIButton *_collectBtn;
    }
@property (nonatomic, strong)NSString *collectionId;

@end

@implementation companyDetailsView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"企业详情";

    self.view.backgroundColor =HexRGB(0xe9f1f6);
    
    
    [self addCollectionAndShareSDK];
    [self addLoadStatus];
    [self addMBprogressView];
    }
-(void)addScrollView{
    _backScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    if (kHeight==568.00) {
        _backScrollView.contentSize =CGSizeMake(kWidth, kHeight-64);

    }else{
        _backScrollView.contentSize =CGSizeMake(kWidth, kHeight+40);
 
    }
    _backScrollView.userInteractionEnabled=YES;
    _backScrollView.backgroundColor=HexRGB(0xededed);
    [self.view addSubview:_backScrollView];
    _backScrollView.bounces = NO;
    _backScrollView.showsVerticalScrollIndicator = NO;
    _backScrollView.showsHorizontalScrollIndicator = NO;
    [self addImageView];
    }
//收藏与分享
-(void)addCollectionAndShareSDK{
    
    
    UIView *backCollectView =[[UIView alloc]init];
    backCollectView.frame = CGRectMake(0, 20, 300, 44);
    backCollectView.backgroundColor =[UIColor clearColor];
    self.navigationItem.titleView = backCollectView;
    
    UILabel *titiLabel =[[UILabel alloc]initWithFrame:CGRectMake(63, 0, 100, 44)];
    titiLabel.text =@"企业详情";
    titiLabel.font =[UIFont systemFontOfSize:PxFont(23)];
    [backCollectView addSubview:titiLabel];
    titiLabel.backgroundColor =[UIColor clearColor];
    
    UIButton * collectionBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    collectionBtn.frame =CGRectMake(180+0%3*30, 8, 30, 30);
    
    collectionBtn. titleLabel.font =[UIFont systemFontOfSize:PxFont(15)];
    [collectionBtn addTarget:self action:@selector(collectionBtn) forControlEvents:UIControlEventTouchUpInside];
    [backCollectView addSubview:collectionBtn];
    _collectBtn = collectionBtn;
    
    UIButton * shareBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame =CGRectMake(180+1%3*30, 8, 30, 30);
    [shareBtn setImage:[UIImage imageNamed:@"collect1.png"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnBtn) forControlEvents:UIControlEventTouchUpInside];
    [backCollectView addSubview:shareBtn];
    
}

-(void)shareBtnBtn{
    [ShareView showViewWithTitle:@"分享" content:@"这是一段分享内容" description:@"这是一段分享内容" url:@"www.ebingoo.com" delegate:self];

}
-(void)collectionBtn{
    
    if ([self.collectionId intValue] == 0 && self.collectionId) {//收藏
        [collectionHttpTool addCollectionWithSuccess:^(NSArray *data, int code, NSString *msg) {
            if (code == 100) {
                [RemindView showViewWithTitle:@"收藏成功" location:MIDDLE];
                collectionModel *model = [data objectAtIndex:0];
                [_collectBtn setImage:[UIImage imageNamed:@"collect_selected.png"] forState:UIControlStateNormal];
                
                self.collectionId = model.data;
            }else
            {
                [RemindView showViewWithTitle:msg location:MIDDLE];
                LoginController *loginView =[[LoginController alloc]init];
                loginView.delegate =self;
                [self.navigationController pushViewController:loginView animated:YES];
                
            }
            
        } entityId:_companyDetailIndex entityType:@"2" withFailure:^(NSError *error) {
            
            [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
        }];
    }else//取消收藏
    {
        [collectionHttpTool cancleCollectionWithSuccess:^(NSArray *data, int code, NSString *msg) {
            if (code == 100) {
                [RemindView showViewWithTitle:msg location:MIDDLE];
                [_collectBtn setImage:[UIImage imageNamed:@"collect0.png"] forState:UIControlStateNormal];
                self.collectionId = @"0";
            }else
            {
                [RemindView showViewWithTitle:msg location:MIDDLE];
            }
            
        } collectionId:self.collectionId withFailure:^(NSError *error) {
            
            [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
        }];
    }
    
}


#pragma  mark ------显示指示器
-(void)addMBprogressView{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    
    
}

#pragma mark---加载数据
-(void)addLoadStatus{
    [companyDetailTool CompanyStatusesWithSuccesscategory:^(NSArray *statues) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        companyModel =[[companyDetailsModel alloc]init];
        NSDictionary *dict =[statues objectAtIndex:0];
        companyModel.wapUrl =[dict objectForKey:@"wapUrl"];
        companyModel.address =[dict objectForKey:@"address"];
        companyModel.province =[dict objectForKey:@"province"];
        companyModel.tel =[dict objectForKey:@"tel"];
        companyModel.name =[dict objectForKey:@"name"];
        companyModel.logo =[dict objectForKey:@"logo"];
        companyModel.contact =[dict objectForKey:@"contact"];
        companyModel.position =[dict objectForKey:@"position"];
        companyModel.city =[dict objectForKey:@"city"];
        companyModel.is_delete =[dict objectForKey:@"is_delete"];
        companyModel.indexID =[dict objectForKey:@"id"];
        self.collectionId = [dict objectForKey:@"collection_id"];
        if ([self.collectionId intValue] != 0) {
            [ _collectBtn setImage:[UIImage imageNamed:@"collect_selected.png"] forState:UIControlStateNormal];
        }else
        {
            [ _collectBtn setImage:[UIImage imageNamed:@"collect0.png"] forState:UIControlStateNormal];
        }

        [self addScrollView];
       
          } company_id:_companyDetailIndex CompanyFailure:^(NSError *error) {
              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
              [RemindView showViewWithTitle:@"网络错误" location:BELLOW];


    }];
}


-(void)addImageView{
    
    UIImageView *headerImage =[[UIImageView alloc]initWithFrame:CGRectMake(YYBODER, 6, kWidth-YYBODER*2, 100)];
    [headerImage setImageWithURL:[NSURL URLWithString:_headerImage] placeholderImage:placeHoderImage3];
    
    [_backScrollView addSubview:headerImage];
    
    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(YYBODER-1, 115, kWidth-YYBODER*2, 165)];
    line.backgroundColor =HexRGB(0xe6e3e4);
    [_backScrollView addSubview:line];
    
    
    for (int i=0; i<4; i++) {
        NSArray *titleArr= @[[NSString stringWithFormat:@"   公司名称:%@",companyModel.name],[NSString stringWithFormat:@"   联系人:%@",companyModel.contact],[NSString stringWithFormat:@"   联系方式:%@",companyModel.tel],[NSString stringWithFormat:@"   公司地址:%@",companyModel.address]];
        
        
        
        UILabel *contentLable=[[UILabel alloc]initWithFrame:CGRectMake(1, 1+i%4*41, kWidth-YYBODER*2-2, 40)];
        [line addSubview:contentLable];
        contentLable.text =titleArr[i];
        contentLable.backgroundColor =[UIColor whiteColor];
        contentLable.numberOfLines = 0;
        contentLable.font =[UIFont systemFontOfSize:PxFont(18)];
        
        
        
    }
    
    
    
    
    UIView *line1 =[[UIView alloc]initWithFrame:CGRectMake(YYBODER-1, 290, kWidth-YYBODER*2, 165)];
    line1.backgroundColor =HexRGB(0xe6e3e4);
    [_backScrollView addSubview:line1];
    
    for (int l=0; l<4; l++) {
        NSArray *titleArr1 =@[@"企业简介:",@"产品管理:",@"供求商机:",@"企业招聘:"];
        UIButton *contentLable1=[UIButton buttonWithType:UIButtonTypeCustom];
        contentLable1.frame = CGRectMake(1, 1+l%4*41, kWidth-YYBODER*2-2, 40);
        [line1 addSubview:contentLable1];
        [contentLable1 setImage:[UIImage imageNamed:@"reture_left.png"] forState:UIControlStateNormal];
        contentLable1.imageEdgeInsets = UIEdgeInsetsMake(0, 250, 0, 10);
        contentLable1.titleEdgeInsets =UIEdgeInsetsMake(0, -20, 0, 215);
        [contentLable1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [contentLable1 setTitle:titleArr1[l] forState:UIControlStateNormal];
        contentLable1.backgroundColor =[UIColor whiteColor];
        contentLable1.titleLabel.font =[UIFont systemFontOfSize:18];
        [contentLable1 addTarget:self action:@selector(contentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        contentLable1.titleLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        
        contentLable1.tag = 100+l;
    }
    
    YYSearchButton *findBtn = [YYSearchButton buttonWithType:UIButtonTypeCustom];
    findBtn.frame = CGRectMake(YYBODER, kHeight-104,kWidth-YYBODER*2,30);
    [findBtn addTarget:self action:@selector(wirteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [findBtn setTitle:@"  评论" forState:UIControlStateNormal];
    findBtn .backgroundColor =[UIColor whiteColor];
    [findBtn setImage:[UIImage imageNamed:@"write_pre.png"] forState:UIControlStateNormal];
    findBtn.titleLabel.font = [UIFont systemFontOfSize:PxFont(20)];
    [findBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [self.view addSubview:findBtn];
    
    
    
}


-(void)contentBtnClick:(UIButton *)content{
   
    if (content.tag ==100) {
        companyProfilesView *profileVc =[[companyProfilesView alloc]init];
        profileVc.companyIndex =companyModel.wapUrl;
        [self.navigationController pushViewController:profileVc animated:YES];
    }else if (content.tag ==101) {
        productController *productVc =[[productController alloc]init];
        productVc.company_id=companyModel.indexID;
        [self.navigationController pushViewController:productVc animated:YES];
    }else if (content.tag ==102) {
        businessController *businessVc =[[businessController alloc]init];
        businessVc.company_id=companyModel.indexID;

        [self.navigationController pushViewController:businessVc animated:YES];
       }else{
           companyJOBController *jobVC =[[companyJOBController alloc]init];
           jobVC.company_id=companyModel.indexID;

           [self.navigationController pushViewController:jobVC animated:YES];

    }



}

-(void)wirteBtnClick:(UIButton *)write{
    CommentController *ctl = [[CommentController alloc] init];
    ctl.entityID = _companyDetailIndex;
    [self.navigationController pushViewController:ctl animated:YES];
}



@end
