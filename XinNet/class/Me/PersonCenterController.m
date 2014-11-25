//
//  PersonCenterController.m
//  XinNet
//
//  Created by tianj on 14-11-20.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "PersonCenterController.h"
#import "MoreListView.h"
#import "MyMsgController.h"
#import "MyCommentController.h"
#import "MyFavoriteController.h"
#import "MyDemandController.h"
#import "LoginController.h"
#import "GlobalInstance.h"
#import "RemindView.h"

@interface PersonCenterController ()<MoreListViewDelegate>



@end

@implementation PersonCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HexRGB(0xffffff);
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout  = UIRectEdgeNone;
    }
    // Do any additional setup after loading the view.
    self.title = @"个人中心";
    [self addView];
}

- (void)addView
{
    NSArray *imgArray = [NSArray arrayWithObjects:@"myMsg.png",@"myComment.png",@"myFavorite.png",@"myDemand.png", nil];   // 左边的图片
    NSArray *titileArray = [NSArray arrayWithObjects:@"我的消息",@"我的评论",@"我的收藏",@"我的求购", nil];
    CGFloat height = 55;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth,titileArray.count*height)];
    [self.view addSubview:bgView];
    for (int i = 0 ; i < titileArray.count; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,height*(i+1)-1, kWidth, 1)];
        line.backgroundColor = HexRGB(0xd5d5d5);
        [bgView addSubview:line];
    }
    
    for (int i = 0 ; i < titileArray.count; i++) {
        MoreListView *listView = [[MoreListView alloc] initWithFrame:CGRectMake(0,height*i, kWidth, height)];
        listView.titleLabel.text = [titileArray objectAtIndex:i];
        listView.imgView.image = [UIImage imageNamed:[imgArray objectAtIndex:i]];
        listView.tag = 1000+i;
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_sore.png"]];
        img.frame = CGRectMake(0,0, 30, 30);
        img.center = CGPointMake(kWidth-15-5,height/2);
        listView.delegate = self;
        [listView addSubview:img];
        [bgView addSubview:listView];
    }
}

- (void)moreListViewClick:(MoreListView *)view
{
    if ([GlobalInstance sharedInstance].isLogin) {
        switch (view.tag-1000) {
            case 0:
            {
                MyMsgController *msg = [[MyMsgController alloc] init];
                [self.navigationController pushViewController:msg animated:YES];
            }
                break;
            case 1:
            {
                MyCommentController *comment = [[MyCommentController alloc] init];
                [self.navigationController pushViewController:comment animated:YES];
            }
                break;
            case 2:
            {
                MyFavoriteController *favorite = [[MyFavoriteController alloc] init];
                [self.navigationController pushViewController:favorite animated:YES];
            }
                break;
            case 3:
            {
                MyDemandController *demand = [[MyDemandController alloc] init];
                [self.navigationController pushViewController:demand animated:YES];
            }
                break;
            default:
                break;
        }
    }else{
        [RemindView showViewWithTitle:@"您还没有注册或登陆哦" location:MIDDLE];
        LoginController *login = [[LoginController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
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
