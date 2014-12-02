//
//  MyDemandController.m
//  XinNet
//
//  Created by tianj on 14-11-20.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "MyDemandController.h"
#import "DemandItem.h"
#import "DemandCell.h"
#import "DemandDetailController.h"
#import "PublishController.h"
#import "httpTool.h"
#import "RemindView.h"
#import "MJRefresh.h"
#import "ReloadViewDelegate.h"

@interface MyDemandController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate,ReloadViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    int _page;
    BOOL isReflesh;
    BOOL isLoad;
    MJRefreshFooterView *footView;
}
@end

@implementation MyDemandController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HexRGB(0xffffff);
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout  = UIRectEdgeNone;
    }
    self.title = @"我的求购";
    // Do any additional setup after loading the view.
    
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self addRightNavButton];
    
    _page = 0;
    
    [self loadData];
    
    [self addRefreshView];
}

#pragma mark 添加上拉加载
- (void)addRefreshView
{
    footView =[[MJRefreshFooterView alloc] init];
    footView.delegate = self;
    footView.scrollView = _tableView;
}

#pragma mark 加载代理
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) {
        isLoad = YES;
        [self loadData];
    }
}

#pragma mark  导航右侧按钮
- (void)addRightNavButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0,60, 30);
    [button setBackgroundImage:[UIImage imageNamed:@"publish.png"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBarButtonDown) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

#pragma mark 右导航按钮点击
- (void)rightBarButtonDown
{
    PublishController *pc = [[PublishController alloc] init];
    pc.title = @"发布";
    pc.isPublish = YES;
    pc.delegate = self;
    [self.navigationController pushViewController:pc animated:YES];
}

#pragma mark ReloadViewDelegate 发布求购成功后刷新页面
- (void)reloadTableView
{
    isReflesh = YES;
    [self loadData];
}

#pragma mark  请求数据
- (void)loadData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"10",@"pagesize",@"1",@"type", nil];
    if (isLoad) {
        _page++;
    }
    if (isReflesh) {
        _page = 0;
    }
    NSString *page= [NSString stringWithFormat:@"%d",_page];
    [param setObject:page forKey:@"page"];

    [httpTool postWithPath:@"getMyDemandList" params:param success:^(id JSON) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic = [result objectForKey:@"response"];
        int code = [[dic objectForKey:@"code"] intValue];
        if (code == 100) {
            if (isReflesh) {
                isReflesh = NO;
                [_dataArray removeAllObjects];
            }
            NSArray *array  = [dic objectForKey:@"data"];
            if (![array isKindOfClass:[NSNull class]]) {
                for (NSDictionary *subDict in array) {
                    DemandItem *item = [[DemandItem alloc] initWithDic:subDict];
                    [_dataArray addObject:item];
                }
            }else{
                if (isLoad) {
                    [RemindView showViewWithTitle:@"数据已全部加载完毕" location:MIDDLE];
                }
            }
            if (isLoad) {
                isLoad = NO;
                [footView endRefreshing];
            }
            [_tableView reloadData];
        }else{
            if (isLoad) {
                isLoad = NO;
                [footView endRefreshing];
            }
            NSString *msg = [dic objectForKey:@"msg"];
            [RemindView showViewWithTitle:msg location:MIDDLE];
        }
    } failure:^(NSError *error) {
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
    static NSString *cellName = @"cellName";
    DemandCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[DemandCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    DemandItem *item = [_dataArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = item.title;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DemandItem *item = [_dataArray objectAtIndex:indexPath.row];
    DemandDetailController *detail = [[DemandDetailController alloc] init];
    detail.businessDetailIndex = item.uid;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark-------

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
