//
//  interfaceDetailsView.m
//  NewView
//
//  Created by YY on 14-11-18.
//  Copyright (c) 2014年 ___普而摩___. All rights reserved.
//

#import "interfaceDetailsView.h"
#import "YYSearchButton.h"
#import "YYalertView.h"
#import "interfaecDetailesTool.h"
#import "interfaceDetailModel.h"
#import "collectionModel.h"
#import "collectionHttpTool.h"
#import "CommentController.h"
#import "LoginController.h"
#import "ShareView.h"
#define YYBODER 16
@interface interfaceDetailsView ()<YYalertViewDelegate,UIWebViewDelegate,ReloadViewDelegate>
{
    UIScrollView *_backScrollView;
    UIWebView *interfaceWebView;
    interfaceDetailModel *interfaceModel;
    CGFloat headerLabelHeight;
    UIButton *_collectBtn;
}
@property (nonatomic, strong)NSString *collectionId;

@end

@implementation interfaceDetailsView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =HexRGB(0xe9f1f6);
    
    [self addCollectionAndShareSDK];
    
    [self addWriteBtn];
    [self addLoadStatus];
    [self addMBprogressView];
    
    
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
    
    UILabel *titiLabel =[[UILabel alloc]initWithFrame:CGRectMake(63, 0, 100, 44)];
    titiLabel.text =@"展会信息";
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
            
        } entityId:_interfaceIndex entityType:@"7" withFailure:^(NSError *error) {
            
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
    [interfaecDetailesTool CompanyStatusesWithSuccesscategory:^(NSArray *statues) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        NSDictionary *dict =[statues objectAtIndex:0];
        interfaceModel=[[interfaceDetailModel alloc]init];
        interfaceModel.cover =[dict objectForKey:@"cover"];
        interfaceModel.title =[dict objectForKey:@"title"];
        interfaceModel.create_time =[dict objectForKey:@"create_time"];
        interfaceModel.from =[dict objectForKey:@"from"];
        interfaceModel.wapUrl =[dict objectForKey:@"wapUrl"];
        interfaceModel.indexId =[dict objectForKey:@"id"];
        interfaceModel.start_time = [dict objectForKey:@"start_time"];
        self.collectionId = [dict objectForKey:@"collection_id"];
        if ([self.collectionId intValue] != 0) {
            [ _collectBtn setImage:[UIImage imageNamed:@"collect_selected.png"] forState:UIControlStateNormal];
        }else
        {
            [ _collectBtn setImage:[UIImage imageNamed:@"collect0.png"] forState:UIControlStateNormal];
        }

        [self addheaderView];
        
    } company_id:_interfaceIndex CompanyFailure:^(NSError *error) {
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
    
    interfaceWebView.frame = CGRectMake(0, 60+headerLabelHeight, kWidth, webheight);
    
    _backScrollView.contentSize = CGSizeMake(kWidth,webheight+70+headerLabelHeight);
    
}
#pragma mark--添加UI
-(void)addheaderView{
    
    
    _backScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-114)];
    _backScrollView.userInteractionEnabled=YES;
    _backScrollView.backgroundColor=HexRGB(0xededed);
    [self.view addSubview:_backScrollView];
    _backScrollView.bounces = NO;
    _backScrollView.showsVerticalScrollIndicator = NO;
    _backScrollView.showsHorizontalScrollIndicator = NO;
    
    UIImageView *headerImage =[[UIImageView alloc]initWithFrame:CGRectMake(YYBODER, 10, 65, 70)];
    [_backScrollView addSubview:headerImage];
    [headerImage setImageWithURL:[NSURL URLWithString:interfaceModel.cover] placeholderImage:placeHoderImage2];
    
     headerLabelHeight =[interfaceModel.title sizeWithFont:[UIFont systemFontOfSize:PxFont(23)] constrainedToSize:CGSizeMake(kWidth-YYBODER*2-80, MAXFLOAT)].height;
    UILabel *headerLabel =[[UILabel alloc]initWithFrame:CGRectMake(YYBODER+80, 5, kWidth-YYBODER*2-80, headerLabelHeight)];
    headerLabel.text =interfaceModel.title;
    headerLabel.textAlignment = NSTextAlignmentLeft;
    headerLabel.numberOfLines = 0;
    headerLabel.backgroundColor =[UIColor clearColor];
    headerLabel.textColor=HexRGB(0x3a3a3a);
    headerLabel.font =[UIFont systemFontOfSize:PxFont(23)];
    [_backScrollView addSubview:headerLabel];
    
    for (int i=0; i<2; i++) {
        NSArray *titleArr =@[[NSString stringWithFormat:@"时间:%@",interfaceModel.start_time],[NSString stringWithFormat:@"来源:%@",interfaceModel.from]];
        UILabel *titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(YYBODER+80,5+ headerLabelHeight+i%3*(20),kWidth-YYBODER*2-80, 20)];
        titleLabel.text =titleArr[i];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.backgroundColor =[UIColor clearColor];
        titleLabel.textColor=HexRGB(0x808080);
        titleLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        [_backScrollView addSubview:titleLabel];
        
    }
    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, 59+headerLabelHeight, kWidth, 1)];
    [_backScrollView addSubview:line];
    line.backgroundColor =HexRGB(0xe6e3e4);

    interfaceWebView =[[UIWebView alloc]initWithFrame:CGRectMake(0, 90, kWidth, kHeight-130)];
    interfaceWebView.scrollView.bounces = NO;
    interfaceWebView.delegate =self;
    interfaceWebView.scrollView.showsHorizontalScrollIndicator = NO;
    interfaceWebView.scrollView.showsVerticalScrollIndicator =NO;
    [interfaceWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:interfaceModel.wapUrl]] ];
    [_backScrollView addSubview:interfaceWebView];
    interfaceWebView.backgroundColor =[UIColor clearColor];

}
-(void)addWriteBtn{
    
    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, kHeight-114, kWidth, 1)];
    [self.view addSubview:line];
    line.backgroundColor =HexRGB(0xe6e3e4);
    YYSearchButton *findBtn = [YYSearchButton buttonWithType:UIButtonTypeCustom];
    findBtn.frame = CGRectMake(20, kHeight-100,kWidth-YYBODER*2,30);
    findBtn.backgroundColor =[UIColor clearColor];
    [findBtn addTarget:self action:@selector(wirteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [findBtn setTitle:@"  评论" forState:UIControlStateNormal];
    [findBtn setImage:[UIImage imageNamed:@"write_pre.png"] forState:UIControlStateNormal];
    findBtn.titleLabel.font = [UIFont systemFontOfSize:PxFont(20)];
    [findBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [self.view addSubview:findBtn];
}
-(void)wirteBtnClick:(UIButton *)write{
    CommentController *ctl = [[CommentController alloc] init];
    ctl.entityID = _interfaceIndex;
    [self.navigationController pushViewController:ctl animated:YES];
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
