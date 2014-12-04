//
//  markertDetailsView.m
//  NewView
//
//  Created by YY on 14-11-18.
//  Copyright (c) 2014年 ___普而摩___. All rights reserved.
//

#import "markertDetailsView.h"
#import "YYSearchButton.h"
#import "YYalertView.h"
#import <ShareSDK/ShareSDK.h>
#import "mardetDetailsModel.h"
#import "mardetDetailsTool.h"
#import "CommentController.h"
#import "collectionModel.h"
#import "collectionHttpTool.h"
#import "RemindView.h"

@interface markertDetailsView ()<YYalertViewDelegate>
{
    mardetDetailsModel *mardetModel;
}
@property (nonatomic, strong)NSString *collectionId;
@end

@implementation markertDetailsView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =HexRGB(0xe9f1f6);
    
    if (IsIos7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self addCollectionAndShareSDK];

    [self addLoadStatus];
     [self addMBprogressView];

}
#pragma  mark ------显示指示器
-(void)addMBprogressView{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    
    
}
#pragma mark----加载数据
-(void)addLoadStatus{
   
    [mardetDetailsTool statusesWithSuccess:^(NSArray *statues) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *dict = [statues objectAtIndex:0];
         mardetModel =[[mardetDetailsModel alloc]init];
        mardetModel.wapUrl =[dict objectForKey:@"wapUrl"];
        [self addLabel];
    } newsID:_markIndex failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    }];
}

//收藏与分享
-(void)addCollectionAndShareSDK{
    
    
    UIView *backCollectView =[[UIView alloc]init];
    backCollectView.frame = CGRectMake(0, 20, 300, 44);
    backCollectView.backgroundColor =[UIColor clearColor];
    self.navigationItem.titleView = backCollectView;
    
    UILabel *titiLabel =[[UILabel alloc]initWithFrame:CGRectMake(70, 0, 100, 44)];
    titiLabel.text =@"市场详情";
    titiLabel.font =[UIFont systemFontOfSize:PxFont(23)];
    [backCollectView addSubview:titiLabel];
    titiLabel.backgroundColor =[UIColor clearColor];
    
    for (int i=0; i<2; i++) {
        NSArray *titleArr =@[@"收藏",@"分享"];
        UIButton * collectionBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        collectionBtn.frame =CGRectMake(160+i%3*40, 8, 40, 30);
        collectionBtn. titleLabel.font =[UIFont systemFontOfSize:PxFont(15)];
        [collectionBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"collect%d",i]] forState:UIControlStateNormal];
        if (i==0) {
            [collectionBtn setImage:[UIImage imageNamed:@"collect_selected.png"] forState:UIControlStateSelected];

        }

        collectionBtn.tag = 2000+i;
        [collectionBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        [collectionBtn setTitleColor:[UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1] forState:UIControlStateNormal];
        [collectionBtn addTarget:self action:@selector(collectionBtn:) forControlEvents:UIControlEventTouchUpInside];
        [backCollectView addSubview:collectionBtn];
    }
    
   
    
   
    

}

-(void)collectionBtn:(UIButton *)sender{
        if (sender.tag == 2001) {
        [self share];
    }else
    {
        if ([sender.titleLabel.text isEqualToString:@"收藏"]) {//收藏
            [collectionHttpTool addCollectionWithSuccess:^(NSArray *data, int code, NSString *msg) {
                if (code == 100) {
                    sender.selected=!sender.selected;

                    [RemindView showViewWithTitle:@"收藏成功" location:MIDDLE];
                    collectionModel *model = [data objectAtIndex:0];
                    [sender setTitle:@"取消收藏" forState:UIControlStateNormal];
                    [sender setImage:[UIImage imageNamed:@"collect_selected.png"] forState:UIControlStateSelected];

                    self.collectionId = model.data;
                }else
                {
                    [RemindView showViewWithTitle:msg location:MIDDLE];
                }
                
            } entityId:_markIndex entityType:@"1" withFailure:^(NSError *error) {
                
                [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
            }];
        }else//取消收藏
        {
            [collectionHttpTool cancleCollectionWithSuccess:^(NSArray *data, int code, NSString *msg) {
                if (code == 100) {
                    [RemindView showViewWithTitle:msg location:MIDDLE];
                    [sender setTitle:@"收藏" forState:UIControlStateNormal];
                    [sender setImage:[UIImage imageNamed:@"collect.png"] forState:UIControlStateSelected];

                }else
                {
                    [RemindView showViewWithTitle:msg location:MIDDLE];
                }

            } collectionId:self.collectionId withFailure:^(NSError *error) {
                
                [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
            }];
        }

    }
}

- (void)share
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

-(void)addLabel{
    UIWebView *marketWebView =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-120)];
    [self.view addSubview:marketWebView];
    [marketWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:mardetModel.wapUrl]] ];
    [self.view addSubview:marketWebView];
    marketWebView.backgroundColor =[UIColor clearColor];

    
    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, kHeight-120, kWidth, 1)];
    [self.view addSubview:line];
    line.backgroundColor =HexRGB(0xe6e3e4);
    
    
    
    YYSearchButton *writeBtn =[YYSearchButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:writeBtn];
    writeBtn.frame = CGRectMake(40, kHeight-44-64, kWidth-85, 34);
    writeBtn.contentHorizontalAlignment =UIControlContentVerticalAlignmentCenter;
    [writeBtn setTitle:@"  评论" forState:UIControlStateNormal];
    writeBtn.backgroundColor =[UIColor whiteColor];
    [writeBtn setImage:[UIImage imageNamed:@"write_pre.png"] forState:UIControlStateNormal];

    [writeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    writeBtn.titleLabel.font =[UIFont systemFontOfSize:20];
    
    [writeBtn addTarget:self action:@selector(writeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)addwriteView{
    
}
-(void)writeBtnClick:(UIButton *)write{

    
    CommentController *ctl = [[CommentController alloc] init];
    ctl.entityID = _markIndex;
    [self.navigationController pushViewController:ctl animated:YES];
    
}
@end
