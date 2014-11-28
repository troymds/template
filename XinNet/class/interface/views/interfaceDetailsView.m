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
#define YYBODER 16
@interface interfaceDetailsView ()<YYalertViewDelegate,UIWebViewDelegate>
{
    UIScrollView *_backScrollView;
    UIWebView *interfaceWebView;
    interfaceDetailModel *interfaceModel;
}
@end

@implementation interfaceDetailsView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =HexRGB(0xe9f1f6);
    self.title =@"展会详情";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithSearch:@"colloct_img.png" highlightedSearch:@"colloct_img.png" target:(self) action:@selector(collectItem)];

    
    [self addWriteBtn];
    [self addLoadStatus];
}
-(void)collectItem{
    
}
-(void)addLoadStatus{
    [interfaecDetailesTool CompanyStatusesWithSuccesscategory:^(NSArray *statues) {
        NSDictionary *dict =[statues objectAtIndex:0];
        interfaceModel=[[interfaceDetailModel alloc]init];
        interfaceModel.cover =[dict objectForKey:@"cover"];
        interfaceModel.title =[dict objectForKey:@"title"];
        interfaceModel.create_time =[dict objectForKey:@"create_time"];
        interfaceModel.from =[dict objectForKey:@"from"];
        interfaceModel.wapUrl =[dict objectForKey:@"wapUrl"];
        interfaceModel.indexId =[dict objectForKey:@"id"];
        [self addheaderView];
        
    } company_id:_interfaceIndex CompanyFailure:^(NSError *error) {
        
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
    
    interfaceWebView.frame = CGRectMake(0, 100, kWidth, webheight);
    
    _backScrollView.contentSize = CGSizeMake(kWidth,webheight+100);
    NSLog(@"%f",webheight);
    
}
#pragma mark--添加UI
-(void)addheaderView{
    
    
    _backScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    _backScrollView.userInteractionEnabled=YES;
    _backScrollView.backgroundColor=HexRGB(0xededed);
    [self.view addSubview:_backScrollView];
    _backScrollView.bounces = NO;
    _backScrollView.showsVerticalScrollIndicator = NO;
    _backScrollView.showsHorizontalScrollIndicator = NO;
    
    UIImageView *headerImage =[[UIImageView alloc]initWithFrame:CGRectMake(YYBODER, 5, 65, 65)];
    [_backScrollView addSubview:headerImage];
    [headerImage setImageWithURL:[NSURL URLWithString:interfaceModel.cover] placeholderImage:placeHoderImage];
    
    
    UILabel *headerLabel =[[UILabel alloc]initWithFrame:CGRectMake(YYBODER+80, 5, kWidth-YYBODER*2-80, 30)];
    headerLabel.text =interfaceModel.title;
    headerLabel.textAlignment = NSTextAlignmentLeft;
    headerLabel.backgroundColor =[UIColor clearColor];
    headerLabel.textColor=HexRGB(0x3a3a3a);
    headerLabel.font =[UIFont systemFontOfSize:PxFont(23)];
    [_backScrollView addSubview:headerLabel];
    
    for (int i=0; i<2; i++) {
        NSArray *titleArr =@[[NSString stringWithFormat:@"时间:%@",interfaceModel.create_time],[NSString stringWithFormat:@"来源:%@",interfaceModel.from]];
        UILabel *titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(YYBODER+80, 35+i%3*(20),kWidth-YYBODER*2-80, 20)];
        titleLabel.text =titleArr[i];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.backgroundColor =[UIColor clearColor];
        titleLabel.textColor=HexRGB(0x808080);
        titleLabel.font =[UIFont systemFontOfSize:PxFont(18)];
        [_backScrollView addSubview:titleLabel];
        
    }
    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, 90, kWidth, 1)];
    [_backScrollView addSubview:line];
    line.backgroundColor =HexRGB(0xe6e3e4);

    interfaceWebView =[[UIWebView alloc]initWithFrame:CGRectMake(0, 100, kWidth, kHeight-100)];
    interfaceWebView.scrollView.bounces = YES;
    interfaceWebView.delegate =self;
    interfaceWebView.scrollView.showsHorizontalScrollIndicator = NO;
    interfaceWebView.scrollView.showsVerticalScrollIndicator =NO;
    [interfaceWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_interface_Url]] ];
    [_backScrollView addSubview:interfaceWebView];
    interfaceWebView.backgroundColor =[UIColor clearColor];



}
-(void)addWriteBtn{
    YYSearchButton *wirteBtn = [YYSearchButton buttonWithType:UIButtonTypeCustom];
    wirteBtn.frame = CGRectMake(20, kHeight-40,kWidth-YYBODER*2,30);
    [wirteBtn addTarget:self action:@selector(wirteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [wirteBtn setTitle:@"       写评论" forState:UIControlStateNormal];
    [wirteBtn setImage:[UIImage imageNamed:@"write.png"] forState:UIControlStateNormal];
    wirteBtn.titleLabel.font = [UIFont systemFontOfSize:PxFont(20)];
    wirteBtn.backgroundColor =[UIColor whiteColor];
    [wirteBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [self.view addSubview:wirteBtn];
    
}
-(void)wirteBtnClick:(UIButton *)write{
    YYalertView *aleartView =[[YYalertView alloc]init];
    aleartView.delegate = self;
    [aleartView showView ];

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
