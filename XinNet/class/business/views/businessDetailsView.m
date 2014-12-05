//
//  businessDetailsView.m
//  NewView
//
//  Created by YY on 14-11-18.
//  Copyright (c) 2014年 ___普而摩___. All rights reserved.
//

#import "businessDetailsView.h"
#import "businessDetailsTool.h"
#import "businessDetailsModel.h"
#import "YYSearchButton.h"
#import "collectionModel.h"
#import "collectionHttpTool.h"
#import "LoginController.h"
#import "ShareView.h"

#define YYBODERW 16
@interface businessDetailsView ()<UIWebViewDelegate,ReloadViewDelegate>
{
    businessDetailsModel *businessModel;
    UIWebView *marketWebView;
    UIScrollView *_backScrollView;
    CGFloat titleLabelHeight;
    UIButton * _collectBtn;
}
@property (nonatomic, strong)NSString *collectionId;

@end

@implementation businessDetailsView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =HexRGB(0xe9f1f6);
    self.title =@"详情";
   
    [self addLoadStatus];
    [self addMBprogressView];
    [self addCollectionAndShareSDK];
    
}
#pragma  mark ------显示指示器
-(void)addMBprogressView{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    
    
}
//收藏与分享
-(void)addCollectionAndShareSDK{
    
    
    UIView *backCollectView =[[UIView alloc]init];
    backCollectView.frame = CGRectMake(0, 20, 300, 44);
    backCollectView.backgroundColor =[UIColor clearColor];
    self.navigationItem.titleView = backCollectView;
    
    UILabel *titiLabel =[[UILabel alloc]initWithFrame:CGRectMake(75, 0, 100, 44)];
    titiLabel.text =@"详情";
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
            
        } entityId:_businessDetailIndex entityType:@"3" withFailure:^(NSError *error) {
            
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








-(void)addLoadStatus{
    [businessDetailsTool statusesWithSuccess:^(NSArray *statues) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        NSDictionary *dict =[statues objectAtIndex:0];
        businessModel =[[businessDetailsModel alloc]init];
        businessModel.wapUrl =[dict objectForKey:@"wapUrl"];
        businessModel.title =[dict objectForKey:@"title"];
        businessModel.read_num =[dict objectForKey:@"read_num"];
        businessModel.create_time =[dict objectForKey:@"create_time"];
        businessModel.num =[dict objectForKey:@"num"];
        self.collectionId = [dict objectForKey:@"collection_id"];
        self.collectionId = [dict objectForKey:@"collection_id"];
        if ([self.collectionId intValue] != 0) {
            [ _collectBtn setImage:[UIImage imageNamed:@"collect_selected.png"] forState:UIControlStateNormal];
        }else
        {
            [ _collectBtn setImage:[UIImage imageNamed:@"collect0.png"] forState:UIControlStateNormal];
        }



        
        [self addLabel];


    } opportunity_Id:_businessDetailIndex failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
 
    }];
}


#pragma mark webViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    float  webheight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    
    marketWebView.frame = CGRectMake(1, 60+titleLabelHeight, kWidth, webheight);
    
    _backScrollView.contentSize = CGSizeMake(kWidth,webheight+80+titleLabelHeight);
    
    
}
-(void)addLabel{
    titleLabelHeight =[businessModel.title sizeWithFont:[UIFont systemFontOfSize:PxFont(23)] constrainedToSize:CGSizeMake(kWidth-30, MAXFLOAT)].height;
    _backScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    _backScrollView.userInteractionEnabled=YES;
    _backScrollView.backgroundColor=[UIColor colorWithRed:248.0/255.0 green:247.0/255.0 blue:245.0/255.0 alpha:1];

    [self.view addSubview:_backScrollView];
    _backScrollView.bounces = NO;
    _backScrollView.showsVerticalScrollIndicator = NO;
    _backScrollView.showsHorizontalScrollIndicator = NO;
    
    UIView *backLineW=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 90)];
    backLineW.backgroundColor=HexRGB(0xededed);
    [_backScrollView addSubview:backLineW];
    
    UILabel *titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(15, 10, kWidth-30, titleLabelHeight)];
    
    titleLabel.text =businessModel.title;
    titleLabel.numberOfLines = 0;
    titleLabel.font =[UIFont systemFontOfSize:PxFont(23)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor =HexRGB(0x3a3a3a);
    titleLabel.backgroundColor =[UIColor clearColor];
    [backLineW addSubview:titleLabel];
    
    
    for (int i=0; i<2; i++) {
        NSArray *titleArr =@[[NSString stringWithFormat:@"时间:%@",businessModel.create_time],[NSString stringWithFormat:@"数量:%@",businessModel.num]];
        UILabel *titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(20+i%3*(kWidth/2), 50, 200, 20)];
        if (i==1) {
            titleLabel.frame =CGRectMake(20+i%3*(kWidth/2), 50, 100, 20);
        }
        titleLabel.text =titleArr[i];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.backgroundColor =[UIColor clearColor];
        if (i==1) {
            titleLabel.textAlignment = NSTextAlignmentRight;

        }
        titleLabel.textColor=HexRGB(0x808080);
        titleLabel.font =[UIFont systemFontOfSize:PxFont(16)];
        [backLineW addSubview:titleLabel];

    }
    
    
    marketWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 80, kWidth, kHeight-120)];
    
    [marketWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:businessModel.wapUrl]]];
    marketWebView.userInteractionEnabled = NO;
    marketWebView.delegate =self;
    marketWebView.backgroundColor =[UIColor redColor];
    [_backScrollView addSubview:marketWebView];

   

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
