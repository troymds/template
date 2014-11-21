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

@interface markertDetailsView ()<YYalertViewDelegate>

@end

@implementation markertDetailsView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =HexRGB(0xe9f1f6);
    
    
    [self addCollectionAndShareSDK];

    [self addLabel];
    

}

//收藏与分享
-(void)addCollectionAndShareSDK{
    
    
    UIView *backCollectView =[[UIView alloc]init];
    backCollectView.frame = CGRectMake(0, 20, 300, 44);
    backCollectView.backgroundColor =[UIColor clearColor];
    self.navigationItem.titleView = backCollectView;
    
    UILabel *titiLabel =[[UILabel alloc]initWithFrame:CGRectMake(70, 0, 100, 44)];
    titiLabel.text =@"详情";
    titiLabel.font =[UIFont systemFontOfSize:PxFont(23)];
    [backCollectView addSubview:titiLabel];
    titiLabel.backgroundColor =[UIColor clearColor];
    
    for (int i=0; i<2; i++) {
        NSArray *titleArr =@[@"收藏",@"分享"];
        YYSearchButton * collectionBtn =[YYSearchButton buttonWithType:UIButtonTypeCustom];
        collectionBtn.frame =CGRectMake(170+i%3*40, 18, 30, 20);
        collectionBtn. titleLabel.font =[UIFont systemFontOfSize:PxFont(15)];
        collectionBtn.tag = 2000+i;
        [collectionBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        [collectionBtn addTarget:self action:@selector(collectionBtn:) forControlEvents:UIControlEventTouchUpInside];
        [backCollectView addSubview:collectionBtn];
    }
    
   
    
   
    

}

-(void)collectionBtn:(UIButton *)sender{
    if (sender.tag == 2001) {
        [self share];
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
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 70, kWidth, 30)];
    [self.view addSubview:titleLabel];
    titleLabel.text =@"新闻标题";
    titleLabel.font =[UIFont systemFontOfSize:PxFont(22)];
    titleLabel.textAlignment =NSTextAlignmentCenter;
    
    for (int i=0; i<2; i++) {
        NSArray *titleArr =@[@"时间",@"来源"];
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(i%3*(kWidth/2), 100, kWidth/2, 30)];
        [self.view addSubview:titleLabel];
        titleLabel.text =titleArr[i];
        titleLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        titleLabel.textAlignment =NSTextAlignmentCenter;
        
        UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, 135+i%3*(100+370), kWidth, 1)];
        line.backgroundColor =[UIColor lightGrayColor];
        [self.view addSubview:line];
    }
    
    
    UIImageView *headerImage =[[UIImageView alloc]initWithFrame:CGRectMake(16, 145, kWidth-32, 100)];
    headerImage.backgroundColor =[UIColor purpleColor];
    headerImage.image =[UIImage imageNamed:@"Loa_img.png"];
    [self.view addSubview:headerImage];
    
    
    UILabel *contentLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 240, kWidth, 130)];
    [self.view addSubview:contentLable];
    contentLable.text =@"新闻正文";
    contentLable.numberOfLines = 0;
    contentLable.font =[UIFont systemFontOfSize:PxFont(22)];
    contentLable.textAlignment =NSTextAlignmentCenter;
    
    YYSearchButton *writeBtn =[YYSearchButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:writeBtn];
    writeBtn.frame = CGRectMake(40, kHeight-44, kWidth-85, 34);
    writeBtn.contentHorizontalAlignment =UIControlContentVerticalAlignmentCenter;
    [writeBtn setTitle:@"写评论" forState:UIControlStateNormal];
    [writeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    writeBtn.titleLabel.font =[UIFont systemFontOfSize:20];
    
    [writeBtn addTarget:self action:@selector(writeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)addwriteView{
    
}
-(void)writeBtnClick:(UIButton *)write{
    YYalertView *aleartView =[[YYalertView alloc]init];
    aleartView.delegate = self;
    [aleartView showView ];
    
}
@end
