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
#import "CommentController.h"
#import "ShareView.h"
#import "LoginController.h"
#define YYBODER 16
@interface jobDetailsView ()<UIScrollViewDelegate,YYalertViewDelegate,ReloadViewDelegate>
{
    UIScrollView *_bigScrollView;
   
    UIButton *_selectedBtn;
    jobDetailModel *jobModel;
    
    UIButton *_collectBtn;
    
}
@property (nonatomic, strong)NSString *collectionId;

@end

@implementation jobDetailsView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =HexRGB(0xe9f1f6);
    [self addWriteBtn];

//    self.title = @"招聘详情";
    
    _selectedBtn =[[UIButton alloc]init];
    [self addChooseBtn];
    
    [self addLoadStatus];
    [self addCollectionAndShareSDK];
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
    backCollectView.alpha=0;
    self.navigationItem.titleView = backCollectView;
    UILabel *titiLabel =[[UILabel alloc]initWithFrame:CGRectMake(60, 0, 100, 44)];
    titiLabel.text =@"招聘详情";
   
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
            
        } entityId:_jobDetailsIndex entityType:@"6" withFailure:^(NSError *error) {
            
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

#pragma mark ---加载数据
-(void)addLoadStatus{
    [jobDetailTool CompanyStatusesWithSuccesscategory:^(NSArray *statues) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        NSDictionary *dict =[statues objectAtIndex:0];
        jobModel =[[jobDetailModel alloc]init];
        jobModel.company_url=[dict objectForKey:@"company_url"];
        jobModel.job_url=[dict objectForKey:@"job_url"];
        jobModel.indexId=[dict objectForKey:@"id"];
        self.collectionId = [dict objectForKey:@"collection_id"];
        if ([self.collectionId intValue] != 0) {
            [ _collectBtn setImage:[UIImage imageNamed:@"collect_selected.png"] forState:UIControlStateNormal];
        }else
        {
            [ _collectBtn setImage:[UIImage imageNamed:@"collect0.png"] forState:UIControlStateNormal];
        }

        [self addScrollview];
    } company_id:_jobDetailsIndex CompanyFailure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
  
    }];
}
#pragma mark ---添加UI
-(void)addScrollview{
    
    _bigScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, kWidth, kHeight-170)];
    _bigScrollView.contentSize = CGSizeMake(kWidth*2, kHeight-64);
    _bigScrollView.backgroundColor =[UIColor whiteColor];
    _bigScrollView.delegate = self;
//    _bigScrollView.bounces = YES;
    _bigScrollView.showsHorizontalScrollIndicator = NO;
    _bigScrollView.showsVerticalScrollIndicator = NO;
    
    
    _bigScrollView.pagingEnabled = YES;
    [self.view addSubview:_bigScrollView];
    _bigScrollView.tag =9999;


    UIWebView *jobWebView =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-166)];
    [_bigScrollView addSubview:jobWebView];
    
    jobWebView.scrollView.bounces = NO;
    jobWebView.scrollView.showsHorizontalScrollIndicator = NO;
    jobWebView.scrollView.showsVerticalScrollIndicator =NO;
    [jobWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:jobModel.job_url]] ];
    
    
    UIWebView *companyWebView =[[UIWebView alloc]initWithFrame:CGRectMake(kWidth, 0, kWidth, kHeight-166)];
    [_bigScrollView addSubview:companyWebView];
    companyWebView.scrollView.bounces = NO;
    companyWebView.scrollView.showsHorizontalScrollIndicator = NO;
    companyWebView.scrollView.showsVerticalScrollIndicator =NO;
    [companyWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:jobModel.company_url]] ];

}

-(void)addWriteBtn{
   
    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, kHeight-120, kWidth, 1)];
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
    ctl.entityID = _jobDetailsIndex;
    [self.navigationController pushViewController:ctl animated:YES];
}

-(void)addChooseBtn{
    for (int i=0; i<2; i++) {
       
        UIButton *chooseBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:chooseBtn];
        
        [chooseBtn setTitleColor:HexRGB(0x808080) forState:UIControlStateNormal];
        [chooseBtn setTitleColor:HexRGB(0x069dd4) forState:UIControlStateSelected];
        chooseBtn.frame =CGRectMake(20+i%3*((kWidth-40)/2), 6, (kWidth-40)/2, 40);
        [chooseBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"company_img%d.png",i]] forState:UIControlStateNormal];
        [chooseBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"company_img%d.png",i]] forState:UIControlStateHighlighted];

        [chooseBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"company_img_selected%d.png",i]] forState:UIControlStateSelected];
        [chooseBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"company_img_selected%d.png",i]] forState:UIControlStateHighlighted];

        [chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        chooseBtn.tag = 200+i;
        if (chooseBtn.tag == 200) {
            chooseBtn.selected = YES;
            _selectedBtn=chooseBtn;
        }
    }
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
