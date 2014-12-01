//
//  jobDetailsView.m
//  XinNet
//
//  Created by YY on 14-11-20.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "jobDetailsView.h"
#import "YYSearchButton.h"
#import "YYalertView.h"
#import "collectionModel.h"
#import "collectionHttpTool.h"
#import "jobDetailTool.h"
#import "jobDetailModel.h"
#define YYBODER 16
@interface jobDetailsView ()<UIScrollViewDelegate,YYalertViewDelegate>
{
    UIScrollView *_bigScrollView;
    UIView *_jobScrollView;
    UIScrollView *_companyScrollView;
    UIButton *_selectedBtn;
    jobDetailModel *jobModel;
}
@property (nonatomic, strong)NSString *collectionId;

@end

@implementation jobDetailsView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =HexRGB(0xe9f1f6);
    self.title = @"招聘详情";
    
    _selectedBtn =[[UIButton alloc]init];
    [self addChooseBtn];
    [self addWriteBtn];
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
    titiLabel.text =@"招聘详情";
    titiLabel.font =[UIFont systemFontOfSize:PxFont(23)];
    [backCollectView addSubview:titiLabel];
    titiLabel.backgroundColor =[UIColor clearColor];
    
    
    YYSearchButton * collectionBtn =[YYSearchButton buttonWithType:UIButtonTypeCustom];
    collectionBtn.frame =CGRectMake(200, 8, 40, 30);
    collectionBtn. titleLabel.font =[UIFont systemFontOfSize:PxFont(15)];
    [collectionBtn setBackgroundImage:[UIImage imageNamed:@"nav_back_img.png"] forState:UIControlStateNormal];
    [collectionBtn setBackgroundImage:[UIImage imageNamed:@"nav_back_img.png"] forState:UIControlStateHighlighted];
    [collectionBtn setTitle:@"收藏" forState:UIControlStateNormal];
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
            
        } entityId:_jobDetailsIndex entityType:@"1" withFailure:^(NSError *error) {
            
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

#pragma mark ---加载数据
-(void)addLoadStatus{
    [jobDetailTool CompanyStatusesWithSuccesscategory:^(NSArray *statues) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        NSDictionary *dict =[statues objectAtIndex:0];
        jobModel =[[jobDetailModel alloc]init];
        jobModel.company_url=[dict objectForKey:@"company_url"];
        jobModel.job_url=[dict objectForKey:@"job_url"];
        jobModel.indexId=[dict objectForKey:@"id"];

        [self addScrollview];
    } company_id:_jobDetailsIndex CompanyFailure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
  
    }];
}
#pragma mark ---添加UI
-(void)addScrollview{
    
    _bigScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 116, kWidth, kHeight-94)];
    _bigScrollView.contentSize = CGSizeMake(kWidth*2, kHeight-64);
    _bigScrollView.backgroundColor =[UIColor whiteColor];
    _bigScrollView.delegate = self;
    _bigScrollView.bounces = YES;
    _bigScrollView.showsHorizontalScrollIndicator = NO;
    _bigScrollView.showsVerticalScrollIndicator = NO;
    
    _bigScrollView.pagingEnabled = YES;
    [self.view addSubview:_bigScrollView];
    _bigScrollView.tag =9999;

    UIWebView *jobWebView =[[UIWebView alloc]initWithFrame:CGRectMake(0, 10, kWidth, kHeight-140)];
    [_bigScrollView addSubview:jobWebView];
    
    jobWebView.scrollView.bounces = NO;
    jobWebView.scrollView.showsHorizontalScrollIndicator = NO;
    jobWebView.scrollView.showsVerticalScrollIndicator =NO;
    [jobWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:jobModel.job_url]] ];
    
    
    UIWebView *companyWebView =[[UIWebView alloc]initWithFrame:CGRectMake(kWidth, 10, kWidth, kHeight-140)];
    [_bigScrollView addSubview:companyWebView];
    companyWebView.scrollView.bounces = NO;
    companyWebView.scrollView.showsHorizontalScrollIndicator = NO;
    companyWebView.scrollView.showsVerticalScrollIndicator =NO;
    [companyWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:jobModel.company_url]] ];

}

-(void)addWriteBtn{
    YYSearchButton *wirteBtn = [YYSearchButton buttonWithType:UIButtonTypeCustom];
    wirteBtn.frame = CGRectMake(YYBODER, kHeight-40,kWidth-YYBODER*2,30);
    [wirteBtn addTarget:self action:@selector(wirteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [wirteBtn setTitle:@"     写评论" forState:UIControlStateNormal];
    wirteBtn.backgroundColor =[UIColor whiteColor];
    [wirteBtn setImage:[UIImage imageNamed:@"write.png"] forState:UIControlStateNormal];
    wirteBtn.titleLabel.font = [UIFont systemFontOfSize:PxFont(20)];
    [wirteBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [self.view addSubview:wirteBtn];
    

    
}


-(void)addChooseBtn{
    for (int i=0; i<2; i++) {
       
        UIButton *chooseBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:chooseBtn];
        
        [chooseBtn setTitleColor:HexRGB(0x808080) forState:UIControlStateNormal];
        [chooseBtn setTitleColor:HexRGB(0x069dd4) forState:UIControlStateSelected];
        chooseBtn.frame =CGRectMake(20+i%3*((kWidth-35)/2), 70, (kWidth-40)/2, 40);
        [chooseBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"company_img%d.png",i]] forState:UIControlStateNormal];
        [chooseBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"company_img_selected%d.png",i]] forState:UIControlStateSelected];

        [chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        chooseBtn.tag = 200+i;
        if (chooseBtn.tag == 200) {
            chooseBtn.selected = YES;
            _selectedBtn=chooseBtn;
        }
    }
}
-(void)wirteBtnClick:(UIButton *)write{
    YYalertView *aleartView =[[YYalertView alloc]init];
    aleartView.delegate = self;
    [aleartView showView ];
    
}
-(void)chooseBtnClick:(UIButton *)choose{
    _selectedBtn.selected = NO;
    choose.selected =YES;
    _selectedBtn = choose;
    
    if (choose.tag == 200)
    {
        [_bigScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else
    {
        
        [_bigScrollView setContentOffset:CGPointMake(kWidth, 0) animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag ==9999) {
        if (scrollView.contentOffset.x <=0) {
            scrollView.contentOffset = CGPointMake(0, 0);
        }
        
        if (scrollView.contentOffset.x >= kWidth) {
            scrollView.contentOffset = CGPointMake(kWidth, 0);
        }
       if(scrollView.contentOffset.x==0){
            for (UIView *subView in self.view.subviews) {
                if ([subView isKindOfClass:[UIButton class]]) {
                    UIButton *btn =(UIButton *)subView;
                    if (btn.tag ==200) {
                        _selectedBtn=btn;
                        _selectedBtn.selected=YES;
                    }else{
                        btn.selected = NO;
                    }
                    
                }
            }
       }else if(scrollView.contentOffset.x==kWidth){
           for (UIView *subView in self.view.subviews) {
               if ([subView isKindOfClass:[UIButton class]]) {
                   UIButton *btn =(UIButton *)subView;
                   if (btn.tag ==201) {
                       _selectedBtn=btn;
                       _selectedBtn.selected=YES;
                   }else{
                       btn.selected = NO;
                   }
                   
               }
           }
       }


    }
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
