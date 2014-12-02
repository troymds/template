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
#define YYBODERW 16
@interface businessDetailsView ()<UIWebViewDelegate>
{
    businessDetailsModel *businessModel;
    UIWebView *marketWebView;
    UIScrollView *_backScrollView;
}
@property (nonatomic, strong)NSString *collectionId;

@end

@implementation businessDetailsView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =HexRGB(0xe9f1f6);
    self.title =@"详情";
   
    [self addLoadStatus];
    [self addCollection];
    [self addMBprogressView];
    
}
#pragma  mark ------显示指示器
-(void)addMBprogressView{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    
    
}
//收藏
-(void)addCollection{
    
    
    UIView *backCollectView =[[UIView alloc]init];
    backCollectView.frame = CGRectMake(0, 20, 300, 44);
    backCollectView.backgroundColor =[UIColor clearColor];
    self.navigationItem.titleView = backCollectView;
    
    UILabel *titiLabel =[[UILabel alloc]initWithFrame:CGRectMake(60, 0, 100, 44)];
    titiLabel.text =@"详情";
    titiLabel.font =[UIFont systemFontOfSize:PxFont(23)];
    [backCollectView addSubview:titiLabel];
    titiLabel.backgroundColor =[UIColor clearColor];
    
    
    YYSearchButton * collectionBtn =[YYSearchButton buttonWithType:UIButtonTypeCustom];
    collectionBtn.frame =CGRectMake(200, 8, 40, 30);
    collectionBtn. titleLabel.font =[UIFont systemFontOfSize:PxFont(15)];
    [collectionBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [collectionBtn setBackgroundImage:[UIImage imageNamed:@"nav_back_img.png"] forState:UIControlStateNormal];
    [collectionBtn setBackgroundImage:[UIImage imageNamed:@"nav_back_img.png"] forState:UIControlStateHighlighted];


    [collectionBtn addTarget:self action:@selector(collectionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backCollectView addSubview:collectionBtn];
}








-(void)collectionBtn:(UIButton *)sender{
    
    
    if ([sender.titleLabel.text isEqualToString:@"收藏"]) {//收藏
        [collectionHttpTool addCollectionWithSuccess:^(NSArray *data, int code, NSString *msg) {
            if (code == 100) {
                [RemindView showViewWithTitle:@"收藏成功" location:MIDDLE];
                collectionModel *model = [data objectAtIndex:0];
                [sender setTitle:@"取消" forState:UIControlStateNormal];
                self.collectionId = model.data;
            }else
            {
                [RemindView showViewWithTitle:msg location:MIDDLE];
            }
            
        } entityId:_businessDetailIndex entityType:@"3" withFailure:^(NSError *error) {
            
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

-(void)addLoadStatus{
    [businessDetailsTool statusesWithSuccess:^(NSArray *statues) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        NSDictionary *dict =[statues objectAtIndex:0];
        businessModel =[[businessDetailsModel alloc]init];
        businessModel.wapUrl =[dict objectForKey:@"wapUrl"];
        businessModel.title =[dict objectForKey:@"title"];
        businessModel.read_num =[dict objectForKey:@"read_num"];
        businessModel.create_time =[dict objectForKey:@"create_time"];


        
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
    
    marketWebView.frame = CGRectMake(1, 80, kWidth, webheight);
    
    _backScrollView.contentSize = CGSizeMake(kWidth,webheight+350);
    
    
}
-(void)addLabel{
    
    _backScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    _backScrollView.userInteractionEnabled=YES;
    _backScrollView.backgroundColor=HexRGB(0xededed);
    [self.view addSubview:_backScrollView];
    _backScrollView.bounces = NO;
    _backScrollView.showsVerticalScrollIndicator = NO;
    _backScrollView.showsHorizontalScrollIndicator = NO;

    UILabel *titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 10, kWidth, 20)];
    titleLabel.text =businessModel.title;
    titleLabel.font =[UIFont systemFontOfSize:PxFont(23)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor =HexRGB(0x3a3a3a);
    [_backScrollView addSubview:titleLabel];
    
    
    for (int i=0; i<2; i++) {
        NSArray *titleArr =@[[NSString stringWithFormat:@"时间:%@",businessModel.create_time],[NSString stringWithFormat:@"数量:%@",businessModel.read_num]];
        UILabel *titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(20+i%3*(kWidth/2), 50, kWidth/2-40, 20)];
        titleLabel.text =titleArr[i];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.backgroundColor =[UIColor clearColor];
        if (i==1) {
            titleLabel.textAlignment = NSTextAlignmentRight;

        }
        titleLabel.textColor=HexRGB(0x808080);
        titleLabel.font =[UIFont systemFontOfSize:PxFont(16)];
        [_backScrollView addSubview:titleLabel];

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
