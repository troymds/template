//
//  productDetailsView.m
//  NewView
//
//  Created by YY on 14-11-18.
//  Copyright (c) 2014年 ___普而摩___. All rights reserved.
//

#import "productDetailsView.h"
#import "YYSearchButton.h"
#import "CommentController.h"
#import "collectionHttpTool.h"
#import "collectionModel.h"
#import "productDetailModel.h"
#import "productDetailTool.h"
#import "TYMyLabel.h"
#import "ShareView.h"
#import "LoginController.h"
#define YYBODER 16
@interface productDetailsView ()<UIWebViewDelegate,ReloadViewDelegate>
{
    productDetailModel *prodModel;
    UIScrollView *_backScrollView;
    UIView *line;//背景线条
    UIButton *_collectBtn;
}
@property(nonatomic,strong)NSString *collectionId;
@end

@implementation productDetailsView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"产品详情";
    self.view.backgroundColor =HexRGB(0xe9f1f6);
    [self addLoadStatus];
    [self addMBprogressView];
    [self addCollectionAndShareSDK];
}
#pragma  mark ------显示指示器
-(void)addMBprogressView{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    
    
}



#pragma mark ---加载数据
-(void)addLoadStatus{
    [productDetailTool statusesWithSuccess:^(NSArray *statues) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        NSDictionary *dict =[statues objectAtIndex:0];
        prodModel =[[productDetailModel alloc]init];
        prodModel.description =[dict objectForKey:@"description"];
        prodModel.cover =[dict objectForKey:@"cover"];
        prodModel.name =[dict objectForKey:@"name"];
        prodModel.price =[dict objectForKey:@"price"];
        prodModel.old_price =[dict objectForKey:@"old_price"];
        prodModel.company_name=[dict objectForKey:@"company_name"];
        self.collectionId = [dict objectForKey:@"collection_id"];
        if ([self.collectionId intValue] != 0) {
            [ _collectBtn setImage:[UIImage imageNamed:@"collect_selected.png"] forState:UIControlStateNormal];
        }else
        {
            [ _collectBtn setImage:[UIImage imageNamed:@"collect0.png"] forState:UIControlStateNormal];
        }

        [self addImageView];

    } product_ID:_productIndex failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    }];
}
//收藏与分享
-(void)addCollectionAndShareSDK{
    
    
    UIView *backCollectView =[[UIView alloc]init];
    backCollectView.frame = CGRectMake(0, 20, 300, 44);
    backCollectView.backgroundColor =[UIColor clearColor];
    self.navigationItem.titleView = backCollectView;
    
    UILabel *titiLabel =[[UILabel alloc]initWithFrame:CGRectMake(63, 0, 100, 44)];
    titiLabel.text =@"产品详情";
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
    [ShareView showViewWithTitle:@"分享" content:@"分享内容" description:@"分享内容" url:@"分享内容" delegate:self];
    
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
            
        } entityId:_productIndex entityType:@"4" withFailure:^(NSError *error) {
            
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

#pragma mark---添加UI
-(void)addImageView{
    CGFloat desriptionHeight;
    desriptionHeight = [prodModel.description sizeWithFont:[UIFont systemFontOfSize:PxFont(20)] constrainedToSize:CGSizeMake(kWidth-YYBODER*2-2, MAXFLOAT)].height;
    _backScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-114)];
    _backScrollView.contentSize = CGSizeMake(kWidth,323+desriptionHeight);
    _backScrollView.userInteractionEnabled=YES;
    _backScrollView.backgroundColor=HexRGB(0xededed);
    [self.view addSubview:_backScrollView];
    _backScrollView.bounces = NO;
    _backScrollView.showsVerticalScrollIndicator = NO;
    _backScrollView.showsHorizontalScrollIndicator = NO;
    

    
    UIImageView *headerImage =[[UIImageView alloc]initWithFrame:CGRectMake(YYBODER,10, kWidth-YYBODER*2, 100)];
    headerImage.backgroundColor =[UIColor clearColor];
    [headerImage setImageWithURL:[NSURL URLWithString:prodModel.cover] placeholderImage:placeHoderImage3];
    [_backScrollView addSubview:headerImage];
    
    
    line =[[UIView alloc]initWithFrame:CGRectMake(YYBODER-1, 120, kWidth-YYBODER*2, 189+desriptionHeight)];
    line.backgroundColor =HexRGB(0xe6e3e4);
    [_backScrollView addSubview:line];
    
   

    for (int i=0; i<5; i++) {
        NSArray *titleArr =@[[NSString stringWithFormat:@"产品名称:%@",prodModel.name],[NSString stringWithFormat:@"现价:%@",prodModel.price],[NSString stringWithFormat:@"原价:%@",prodModel.old_price],[NSString stringWithFormat:@"所属企业:%@",prodModel.company_name],[NSString stringWithFormat:@"产品简介:%@",prodModel.description]];
        TYMyLabel *contentLable=[[TYMyLabel alloc]initWithFrame:CGRectMake(1, 1+i%5*41, kWidth-YYBODER*2-2, 40)withInsets:UIEdgeInsetsMake(0,15,0,0)];
       
        if (i==4) {
            contentLable.frame=CGRectMake(1, 1+i%5*41, kWidth-YYBODER*2-2, desriptionHeight+23);
        }
        [line addSubview:contentLable];
        contentLable.text =titleArr[i];
        contentLable.backgroundColor =[UIColor whiteColor];
        contentLable.numberOfLines = 0;
        contentLable.font =[UIFont systemFontOfSize:PxFont(20)];
    }
    UIView *writeLine =[[UIView alloc]initWithFrame:CGRectMake(0, kHeight-114, kWidth, 1)];
    [self.view addSubview:writeLine];
    writeLine.backgroundColor =HexRGB(0xe6e3e4);
    
    YYSearchButton *findBtn = [YYSearchButton buttonWithType:UIButtonTypeCustom];
    findBtn.frame = CGRectMake(20, kHeight-100,kWidth-YYBODER*2,30);
    [findBtn addTarget:self action:@selector(wirteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [findBtn setTitle:@"  评论" forState:UIControlStateNormal];
    [findBtn setImage:[UIImage imageNamed:@"write_pre.png"] forState:UIControlStateNormal];
    findBtn.titleLabel.font = [UIFont systemFontOfSize:PxFont(20)];
    
    [findBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [self.view addSubview:findBtn];
    
    
    
}
-(void)wirteBtnClick:(UIButton *)write{
    CommentController *ctl = [[CommentController alloc] init];
    ctl.entityID = _productIndex;
    [self.navigationController pushViewController:ctl animated:YES];
}


@end
