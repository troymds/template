//
//  squareController.m
//  NewView
//
//  Created by YY on 14-11-18.
//  Copyright (c) 2014年 ___普而摩___. All rights reserved.
//

#import "squareController.h"
#import "SquareCell.h"
#import "SquareUserItem.h"
#import "PublishTopicController.h"
#import "SquareHeadView.h"
#import "PersonalController.h"
#import "httpTool.h"
#import "RemindView.h"
#import "SystemConfig.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "LoginController.h"
#import "MagnifyView.h"

@interface squareController ()<UITableViewDataSource,UITableViewDelegate,TJImageViewDelegate,MJRefreshBaseViewDelegate,ReloadViewDelegate,ManifyViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    int _page;
    BOOL isRefresh;
    BOOL isLoad;
    MJRefreshFooterView *refreshFootView;
    MJRefreshHeaderView *refreshHeadView;
    SquareHeadView *headView;
    
    UIView *panelView;  //图片放大后的背景
}
@end

@implementation squareController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HexRGB(0xffffff);
    self.title = @"话题广场";
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self addRightNavButton];
    _page = 0;
    
    
    [self addHeadView];
    
    [self loadData];
    
    [self addRefreshView];
    [self loadHeadViewData];

    panelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth,kHeight)];
    panelView.backgroundColor = [UIColor clearColor];
    panelView.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:panelView];
}


#pragma mark  添加上拉加载
- (void)addRefreshView
{
    refreshHeadView = [[MJRefreshHeaderView alloc] init];
    refreshHeadView.delegate = self;
    refreshHeadView.scrollView = _tableView;
    
    refreshFootView =[[MJRefreshFooterView alloc] init];
    refreshFootView.delegate = self;
    refreshFootView.scrollView = _tableView;
}


- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) {
        isLoad = YES;
        [self loadData];
    }else{
        isRefresh = YES;
        [self loadData];
    }
}


#pragma mark  添加右导航按钮
- (void)addRightNavButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0,60, 30);
    [button setBackgroundImage:[UIImage imageNamed:@"publish"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBarButtonDown) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

#pragma mark 右导航按钮点击
- (void)rightBarButtonDown
{
    if ([SystemConfig sharedInstance].isUserLogin) {
        PublishTopicController *ptc = [[PublishTopicController alloc] init];
        ptc.delegate = self;
        [self.navigationController pushViewController:ptc animated:YES];
    }else{
        [RemindView showViewWithTitle:@"您还未登录,请先登录" location:MIDDLE];
    }
    
}
#pragma mark   reloadViewDelegate
//发布话题成功后 重新刷新一次tableview
- (void)reloadTableView
{
    isRefresh = YES;
    [self loadData];
}

//更新个人信息成功后  刷新一下headview
- (void)reloadView
{
    [self loadHeadViewData];
}

#pragma mark 添加顶部视图
- (void)addHeadView
{
    headView = [[SquareHeadView alloc] initWithFrame:CGRectMake(0, 0, kWidth,154)];
    headView.iconImg.image = [UIImage imageNamed:@"user_default.png"];
    headView.iconImg.tag = 999;
    headView.iconImg.delegate = self;
    [headView.loginBtn addTarget:self action:@selector(loginBtnDown) forControlEvents:UIControlEventTouchUpInside];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,headView.frame.size.height-1,kWidth,1)];
    line.backgroundColor = HexRGB(0xd5d5d5);
    [headView addSubview:line];
    _tableView.tableHeaderView = headView;

}

#pragma mark 刷新顶部视图数据
- (void)loadHeadViewData
{
    if ([SystemConfig sharedInstance].isUserLogin) {
        headView.loginBtn.hidden = YES;
        headView.nameLabel.hidden = NO;
        if ([SystemConfig sharedInstance].userItem) {
            NSString *iconImg = [SystemConfig sharedInstance].userItem.avatar;
            NSString *userName = [SystemConfig sharedInstance].userItem.user_name;
            if (iconImg.length!=0) {
                [headView.iconImg setImageWithURL:[NSURL URLWithString:iconImg] placeholderImage:[UIImage imageNamed:@"user_default.png"]];
            }
            if (userName.length!=0) {
                headView.nameLabel.text = userName;
                headView.nameLabel.hidden = NO;
                headView.loginBtn.hidden = YES;
            }
        }
    }else{
        headView.loginBtn.hidden = NO;
        headView.nameLabel.hidden = YES;
    }
}

#pragma mark 登陆
- (void)loginBtnDown
{
    LoginController *login = [[LoginController alloc] init];
    login.delegate = self;
    [self.navigationController pushViewController:login animated:YES];
}


#pragma mark 个人头像点击
- (void)imageViewClick:(TJImageView *)view
{
    if (view.tag == 999) {
        if (![SystemConfig sharedInstance].isUserLogin) {
            [RemindView showViewWithTitle:@"您还未登陆,请先登录" location:MIDDLE];
        }else{
            PersonalController *pc = [[PersonalController alloc] init];
            pc.delegate = self;
            [self.navigationController pushViewController:pc animated:YES];
        }
    }else{
        MagnifyView *magnifyView = [[MagnifyView alloc] initWithImageView:view];
        magnifyView.delegate  = self;
        [magnifyView show];
    }
}

#pragma mark 请求数据
- (void)loadData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"10",@"pagesize", nil];
    //刷新
    if (isRefresh) {
        _page = 0;
    }
    //加载
    if (isLoad) {
        _page++;
    }
    NSString *page = [NSString stringWithFormat:@"%d",_page];
    [param setObject:page forKey:@"page"];
    [httpTool postWithPath:@"getTopicList" params:param success:^(id JSON) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic = [result objectForKey:@"response"];
        int code = [[dic objectForKey:@"code"]intValue];
        if (code ==100) {
            if (isRefresh) {
                [_dataArray removeAllObjects];
            }
            NSArray *data = [dic objectForKey:@"data"];
            //数据不为空
            if (![data isKindOfClass:[NSNull class]]) {
                for (NSDictionary *subDic in data) {
                    SquareUserItem *item = [[SquareUserItem alloc] initWithDic:subDic];
                    [_dataArray addObject:item];
                }
            }else{
                if (isLoad) {
                    [RemindView showViewWithTitle:@"数据已全部加载完毕" location:MIDDLE];
                }
            }
            if (isLoad) {
                isLoad = NO;
                [refreshFootView endRefreshing];
            }
            if (isRefresh) {
                isRefresh = NO;
                [refreshHeadView endRefreshing];
            }
            [_tableView reloadData];
            
        }else{
            //请求数据失败
            if (isLoad) {
                isLoad = NO;
                [refreshFootView endRefreshing];
            }
            if (isRefresh) {
                isRefresh = NO;
                [refreshHeadView endRefreshing];
            }
            NSString *msg = [dic objectForKey:@"msg"];
            [RemindView showViewWithTitle:msg location:MIDDLE];
            
        }
    } failure:^(NSError *error) {
        if (isLoad) {
            isLoad = NO;
            [refreshFootView endRefreshing];
        }
        if (isRefresh) {
            isRefresh = NO;
            [refreshHeadView endRefreshing];
        }
        [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
    }];
}


#pragma mark tableview_delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"identify";
    SquareCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[SquareCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
    }
    SquareUserItem *item = [_dataArray objectAtIndex:indexPath.row];
    [cell setObject:item];
    cell.publishImg.delegate = self;
    cell.publishImg.tag = 1000+indexPath.row;
    cell.line.frame = CGRectMake(0, [self getCellHeight:indexPath]-1,kWidth,1);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getCellHeight:indexPath];
}

#pragma mark 获取cell的高度
- (CGFloat)getCellHeight:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = 0;
    SquareUserItem *item = [_dataArray objectAtIndex:indexPath.row];
    cellHeight = TopSapce + UserNameHeight+MiddleSpace;
    CGSize size = [AdaptationSize getSizeFromString:item.content Font:[UIFont systemFontOfSize:ContentFont] withHight:CGFLOAT_MAX withWidth:ContentWidth];
    cellHeight += size.height;
    cellHeight += MiddleSpace;
    if (item.image&&item.image.length!=0) {
        cellHeight += PublishImgHeiht;
    }
    cellHeight += 15;
    return cellHeight;
}

#pragma mark -----
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
