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
#define YYBODER 16
@interface companyDetailsView ()<YYalertViewDelegate>
{
        companyDetailsModel *companyModel;
    UIScrollView *_backScrollView;
}
@property (nonatomic, strong)NSString *collectionId;

@end

@implementation companyDetailsView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"企业详情";

    self.view.backgroundColor =HexRGB(0xe9f1f6);
    
    [self addShareBtn];
   
    [self addLoadStatus];
    [self addMBprogressView];
    }
-(void)addScrollView{
    _backScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    if (IsIos7) {
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
//收藏
-(void)addShareBtn{
    
    
    UIView *backCollectView =[[UIView alloc]init];
    backCollectView.frame = CGRectMake(0, 20, 300, 44);
    backCollectView.backgroundColor =[UIColor clearColor];
    self.navigationItem.titleView = backCollectView;
    
    UILabel *titiLabel =[[UILabel alloc]initWithFrame:CGRectMake(60, 0, 100, 44)];
    titiLabel.text =@"企业详情";
    titiLabel.font =[UIFont systemFontOfSize:PxFont(23)];
    [backCollectView addSubview:titiLabel];
    titiLabel.backgroundColor =[UIColor clearColor];
    
    
    YYSearchButton * collectionBtn =[YYSearchButton buttonWithType:UIButtonTypeCustom];
    collectionBtn.frame =CGRectMake(200, 8, 40, 30);
    collectionBtn. titleLabel.font =[UIFont systemFontOfSize:PxFont(15)];
    [collectionBtn setTitle:@"分享" forState:UIControlStateNormal];
    [collectionBtn setBackgroundImage:[UIImage imageNamed:@"nav_back_img.png"] forState:UIControlStateHighlighted];
    
    
    
    [collectionBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backCollectView addSubview:collectionBtn];
}
-(void)shareBtnClick:(UIButton *)shar{
    [self addShare];
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


        
        
        [self addScrollView];
       
          } company_id:_companyDetailIndex CompanyFailure:^(NSError *error) {
              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    }];
}

- (void)addShare
{
    //分享的 底ViewControoler
    id<ISSContainer> container = [ShareSDK container];
    
    [container setIPhoneContainerWithViewController:self];
    
    NSArray *shareList = [ShareSDK getShareListWithType:
                          ShareTypeSinaWeibo,
                          ShareTypeQQ,
                          ShareTypeQQSpace,
                          ShareTypeWeixiSession,
                          ShareTypeWeixiTimeline,
                          ShareTypeWeixiFav,
                          ShareTypeSMS,
                          nil];
    
    //分享的内容
    id<ISSContent> publishContent = nil;
    NSString *contentString = @"这是一段分享内容";
    NSString *urlString     = @"www.ebingoo.com";
    NSString *description   = @"这是一段分享内容";
    
    SSPublishContentMediaType shareType = SSPublishContentMediaTypeText;
    
    publishContent = [ShareSDK content:contentString
                        defaultContent:@""
                                 image:nil
                                 title:@"易宾购"
                                   url:urlString
                           description:description
                             mediaType:shareType];
    
    id<ISSShareOptions> shareOptions =
    [ShareSDK defaultShareOptionsWithTitle:@""
                           oneKeyShareList:shareList
                        cameraButtonHidden:YES
                       mentionButtonHidden:NO
                         topicButtonHidden:NO
                            qqButtonHidden:NO
                     wxSessionButtonHidden:NO
                    wxTimelineButtonHidden:NO
                      showKeyboardOnAppear:NO
                         shareViewDelegate:nil
                       friendsViewDelegate:nil
                     picViewerViewDelegate:nil];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:shareOptions
                            result:^(ShareType type,
                                     SSResponseState state,
                                     id<ISSPlatformShareInfo> statusInfo,
                                     id<ICMErrorInfo> error, BOOL end)
     {
         if (state == SSPublishContentStateSuccess)
         {
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功!" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
             [alertView show];
         }
         else if (state == SSPublishContentStateFail)
         {
             if ([error errorCode] == -22003) {
                 if ([error errorCode] == -22003) {
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败" message:@"尚未安装微信,请安装后重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                     [alertView show];
                 }
             }else if ([error errorCode] == -24002){
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败" message:@"尚未安装QQ,请安装后重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                 [alertView show];
             }else if ([error errorCode] == -6004){
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败" message:@"尚未安装QQ或者QQ空间客户端，请安装后重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                 [alertView show];
             }
         }
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
        NSArray *titleArr= @[[NSString stringWithFormat:@"  公司名称:%@",companyModel.name],[NSString stringWithFormat:@"   联系人:%@",companyModel.contact],[NSString stringWithFormat:@"   联系方式:%@",companyModel.tel],[NSString stringWithFormat:@"   公司地址:%@",companyModel.address]];
        
        
        
        UILabel *contentLable=[[UILabel alloc]initWithFrame:CGRectMake(1, 1+i%4*41, kWidth-YYBODER*2-2, 40)];
        [line addSubview:contentLable];
        contentLable.text =titleArr[i];
        contentLable.backgroundColor =[UIColor whiteColor];
        contentLable.numberOfLines = 0;
        contentLable.font =[UIFont systemFontOfSize:PxFont(18)];
        
        
        
    }
    UIButton * collectionBtn;
   
        collectionBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        collectionBtn.frame =CGRectMake(kWidth-80, 10,40, 50);
        [collectionBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [collectionBtn setTitle:@"取消" forState:UIControlStateSelected];

        [collectionBtn addTarget:self action:@selector(collectionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        collectionBtn.imageEdgeInsets =UIEdgeInsetsMake(-10, 0, 30, 0);
        [collectionBtn setImage:[UIImage imageNamed:@"collect0"] forState:UIControlStateNormal];
        [collectionBtn setImage:[UIImage imageNamed:@"collect_selected.png"] forState:UIControlStateSelected];
        [line addSubview:collectionBtn];
        collectionBtn.backgroundColor =[UIColor clearColor];
        [collectionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        collectionBtn.titleLabel.font =[UIFont systemFontOfSize:PxFont(13)];
    
        UIImageView *failImg =[[UIImageView alloc]initWithFrame:CGRectMake(kWidth-80, 43,40, 30 )];
        [line addSubview:failImg];
        failImg.backgroundColor =[UIColor whiteColor];
        failImg.userInteractionEnabled = YES;
    if (IsIos7) {
        collectionBtn.titleEdgeInsets=UIEdgeInsetsMake(0, -35, 0, 5);
        
    }else{
        collectionBtn.titleEdgeInsets=UIEdgeInsetsMake(0, -25, 0, 5);
        
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
-(void)collectionBtnClick:(UIButton *)sender{
    
    if ([sender.titleLabel.text isEqualToString:@"收藏"]) {//收藏
        [collectionHttpTool addCollectionWithSuccess:^(NSArray *data, int code, NSString *msg) {
            if (code == 100) {
                sender.selected=!sender.selected;

                [RemindView showViewWithTitle:@"收藏成功" location:MIDDLE];
                collectionModel *model = [data objectAtIndex:0];
                [sender setTitle:@"取消" forState:UIControlStateNormal];
                self.collectionId = model.data;
            }else
            {
                [RemindView showViewWithTitle:msg location:MIDDLE];
            }
            
        } entityId:_companyDetailIndex entityType:@"2" withFailure:^(NSError *error) {
            
            [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
        }];
    }else//取消收藏
    {
        [collectionHttpTool cancleCollectionWithSuccess:^(NSArray *data, int code, NSString *msg) {
            
            [RemindView showViewWithTitle:msg location:MIDDLE];
            [sender setTitle:@"收藏" forState:UIControlStateNormal];
        } collectionId:self.collectionId withFailure:^(NSError *error) {
            
            [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
        }];
    }
    
    
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
    ctl.entityType = @"2";
    [self.navigationController pushViewController:ctl animated:YES];
}



@end
