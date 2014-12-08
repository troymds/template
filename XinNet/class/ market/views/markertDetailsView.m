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
#import "LoginController.h"
#import "ShareView.h"
@interface markertDetailsView ()<YYalertViewDelegate,ReloadViewDelegate>
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
        self.collectionId = [dict objectForKey:@"collection_id"];
        if ([self.collectionId intValue] != 0) {
            [ _collectBtn setImage:[UIImage imageNamed:@"collect_selected.png"] forState:UIControlStateNormal];
        }else
        {
            [ _collectBtn setImage:[UIImage imageNamed:@"collect0.png"] forState:UIControlStateNormal];
        }
        [self addLabel];
    } newsID:_markIndex failure:^(NSError *error) {
        [RemindView showViewWithTitle:@"网络错误" location:BELLOW];
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
    _shareBtn = shareBtn;
}

-(void)shareBtnBtn
{
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
                LoginController *logionVc=[[LoginController alloc]init];
                logionVc.delegate =self;
                [self.navigationController pushViewController:logionVc animated:YES];
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


-(void)addLabel{
    UIWebView *marketWebView =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-120)];
    [self.view addSubview:marketWebView];
    [marketWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:mardetModel.wapUrl]] ];
    [self.view addSubview:marketWebView];
    marketWebView.backgroundColor =[UIColor clearColor];
    
    
    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, kHeight-120, kWidth, 1)];
    [self.view addSubview:line];
    line.backgroundColor =HexRGB(0xe6e3e4);
    
    
    
    UIView *linew =[[UIView alloc]initWithFrame:CGRectMake(0, kHeight-120, kWidth, 1)];
    [self.view addSubview:linew];
    linew.backgroundColor =HexRGB(0xe6e3e4);
    YYSearchButton *findBtn = [YYSearchButton buttonWithType:UIButtonTypeCustom];
    findBtn.frame = CGRectMake(20, kHeight-100,kWidth-40,30);
    findBtn.backgroundColor =[UIColor clearColor];
    [findBtn addTarget:self action:@selector(wirteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [findBtn setTitle:@"  评论" forState:UIControlStateNormal];
    [findBtn setImage:[UIImage imageNamed:@"write_pre.png"] forState:UIControlStateNormal];
    findBtn.titleLabel.font = [UIFont systemFontOfSize:PxFont(20)];
    [findBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [self.view addSubview:findBtn];
    
}

-(void)addwriteView{
    
}
-(void)wirteBtnClick:(UIButton *)write{
    
    
    CommentController *ctl = [[CommentController alloc] init];
    ctl.entityID = _markIndex;
    ctl.entityType = @"1";
    [self.navigationController pushViewController:ctl animated:YES];
    
}
@end
