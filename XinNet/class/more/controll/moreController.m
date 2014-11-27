//
//  moreController.m
//  NewView
//
//  Created by YY on 14-11-18.
//  Copyright (c) 2014年 ___普而摩___. All rights reserved.
//

#import "moreController.h"
#import "MoreListView.h"
#import "SettingController.h"
#import "AdviceController.h"
#import <ShareSDK/ShareSDK.h>

#define Set_Type 1000
#define Advice_Type 1001
#define Share_Type 1002

@interface moreController ()<MoreListViewDelegate>
{
    MoreListView *_setView;
    MoreListView *_adviceView;
    MoreListView *_shareView;
}
@end

@implementation moreController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    self.title = @"更多内容";
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self addView];
}

- (void)addView
{
    CGFloat height = 50;      //列表高度
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth,height*3)];
    [self.view addSubview:bgView];
    for (int i = 0 ; i < 3; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,(i+1)*height-1,kWidth, 1)];
        line.backgroundColor = HexRGB(0xd5d5d5);
        [bgView addSubview:line];
    }
    
    _setView = [[MoreListView alloc] initWithFrame:CGRectMake(0, 0, kWidth,height)];
    _setView.titleLabel.text = @"设置";
    _setView.titleLabel.frame = CGRectMake(20,0,120,height);
    _setView.imgView.hidden = YES;
    _setView.delegate = self;
    _setView.tag = Set_Type;
    [bgView addSubview:_setView];
    //加右侧箭头
    UIImageView *img1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_sore.png"]];
    img1.frame = CGRectMake(0,0, 30, 30);
    img1.center = CGPointMake(kWidth-(30/2)-5,height/2);
    [_setView addSubview:img1];
    
    
    _adviceView = [[MoreListView alloc] initWithFrame:CGRectMake(0,height, kWidth,height)];
    _adviceView.titleLabel.text = @"意见反馈";
    _adviceView.titleLabel.frame = CGRectMake(20,0,120,height);
    _adviceView.imgView.hidden = YES;
    _adviceView.delegate  = self;
    _adviceView.tag = Advice_Type;
    [bgView addSubview:_adviceView];
    //加右侧箭头
    UIImageView *img2= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_sore.png"]];
    img2.frame = CGRectMake(0,0, 30, 30);
    img2.center = CGPointMake(kWidth-(30/2)-5,height/2);
    [_adviceView addSubview:img2];
    
    
    _shareView = [[MoreListView alloc] initWithFrame:CGRectMake(0,height*2, kWidth,height)];
    _shareView.titleLabel.text = @"分享软件";
    _shareView.titleLabel.frame = CGRectMake(20,0,120,height);
    _shareView.imgView.hidden = YES;
    _shareView.delegate = self;
    _shareView.tag = Share_Type;
    [bgView addSubview:_shareView];
    //加右侧箭头
    UIImageView *img3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_sore.png"]];
    img3.frame = CGRectMake(0,0, 30, 30);
    img3.center = CGPointMake(kWidth-(30/2)-5,height/2);
    [_shareView addSubview:img3];
    
    
}

- (void)moreListViewClick:(MoreListView *)view
{
    switch (view.tag) {
        case Set_Type:
        {
            SettingController *set = [[SettingController alloc] init];
            [self.navigationController pushViewController:set animated:YES];
        }
            break;
        case Advice_Type:
        {
            AdviceController *adc = [[AdviceController alloc] init];
            [self.navigationController pushViewController:adc animated:YES];
        }
            break;
        case Share_Type:
        {
            [self share];
        }
            break;
            
        default:
            break;
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
