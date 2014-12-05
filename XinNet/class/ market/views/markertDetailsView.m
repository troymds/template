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
    UIButton *_collectBtn;//收藏
    UIButton *_shareBtn;//分享
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
    
    
}
#pragma mark----加载数据
-(void)addLoadStatus{
    [mardetDetailsTool statusesWithSuccess:^(NSArray *statues) {
        NSDictionary *dict = [statues objectAtIndex:0];
        mardetModel =[[mardetDetailsModel alloc]init];
        mardetModel.wapUrl =[dict objectForKey:@"wapUrl"];
        self.collectionId = [dict objectForKey:@"collection_id"];
        if ([self.collectionId intValue] != 0) {
            [ _collectBtn setImage:[UIImage imageNamed:@"collect_selected.png"] forState:UIControlStateNormal];
        }else
        {
            [ _collectBtn setImage:[UIImage imageNamed:@"collect0.png"] forState:UIControlStateNormal];
        }
        [self addLabel];
    } newsID:_markIndex failure:^(NSError *error) {
        
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
    
    UIButton * collectionBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    collectionBtn.frame =CGRectMake(160+0%3*40, 8, 40, 30);
    
    collectionBtn. titleLabel.font =[UIFont systemFontOfSize:PxFont(15)];
    [collectionBtn addTarget:self action:@selector(collectionBtn) forControlEvents:UIControlEventTouchUpInside];
    [backCollectView addSubview:collectionBtn];
    _collectBtn = collectionBtn;
    
    UIButton * shareBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame =CGRectMake(160+1%3*40, 8, 40, 30);
    [shareBtn setImage:[UIImage imageNamed:@"collect1.png"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnBtn) forControlEvents:UIControlEventTouchUpInside];
    [backCollectView addSubview:shareBtn];
    _shareBtn = shareBtn;
}

-(void)shareBtnBtn
{
    [self share];
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
            }
            
        } entityId:_markIndex entityType:@"1" withFailure:^(NSError *error) {
            
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
