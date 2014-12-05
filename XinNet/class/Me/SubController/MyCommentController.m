//
//  MyCommentController.m
//  XinNet
//
//  Created by tianj on 14-11-20.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "MyCommentController.h"
#import "CommentCell.h"
#import "CommentItem.h"
#import "httpTool.h"
#import "RemindView.h"
#import "MJRefresh.h"
#import "markertDetailsView.h"
#import "companyDetailsView.h"
#import "businessDetailsView.h"
#import "productDetailsView.h"
#import "jobDetailsView.h"
#import "interfaceDetailsView.h"


@interface MyCommentController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    int _page;
    BOOL isRefresh;  //刷新
    BOOL isLoad;  //加载
    MJRefreshFooterView *footView;
    UIView *noDataView;
}
@end


@implementation MyCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HexRGB(0xededed);
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout  = UIRectEdgeNone;
    }
    // Do any additional setup after loading the view.
    
    self.title = @"我的评论";

    
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64) style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.backgroundColor =HexRGB(0xededed);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    
    //没有数据时显示
    noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth,kHeight-64)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,kWidth,20)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"您当前还没有发表过评论!";
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.center = noDataView.center;
    [noDataView addSubview:label];
    [self.view addSubview:noDataView];
    noDataView.hidden = YES;

    
    _page = 0;
    [self loadData];
    
    [self addRefreshView];
}

//添加加载
- (void)addRefreshView
{
    footView = [[MJRefreshFooterView alloc] init];
    footView.scrollView = _tableView;
    footView.delegate = self;
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) {
        isLoad = YES;
        [self loadData];
    }
}

- (void)loadData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1",@"account_center",@"10",@"pagesize", nil];
    if (isRefresh) {
        _page = 0;
    }
    if (isLoad) {
        _page++;
    }
    NSString *page = [NSString stringWithFormat:@"%d",_page];
    [param setObject:page forKey:@"page"];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    [httpTool postWithPath:@"getCommentList" params:param success:^(id JSON) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic = [result objectForKey:@"response"];
        int code = [[dic objectForKey:@"code"] intValue];
        if (code == 100) {
            NSArray *data = [dic objectForKey:@"data"];
            if (![data isKindOfClass:[NSNull class]]) {
                noDataView.hidden = YES;
                for (NSDictionary *subDic in data) {
                    CommentItem *item = [[CommentItem alloc] initWithDic:subDic];
                    [_dataArray addObject:item];
                }
            }else{
                if (isLoad) {
                    [RemindView showViewWithTitle:@"数据已全部加载完毕" location:MIDDLE];
                }else{
                    noDataView.hidden = NO;
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
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cellName";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    CommentItem *item = [_dataArray objectAtIndex:indexPath.row];
    [cell setObject:item];
    cell.line.frame = CGRectMake(0, [self getCellHeight:indexPath]-1,kWidth,1);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentItem *item = [_dataArray objectAtIndex:indexPath.row];
    int type = [item.type intValue];
    switch (type) {
        case 1:
        {
            markertDetailsView *detail = [[markertDetailsView alloc] init];
            detail.markIndex = item.entity_id;
            [self.navigationController pushViewController:detail animated:YES];
        }
            break;
        case 2:
        {
            companyDetailsView *detail = [[companyDetailsView alloc] init];
            detail.companyDetailIndex = item.entity_id;
            [self.navigationController pushViewController:detail animated:YES];
        }
            break;
        case 3:
        {
            businessDetailsView *detail = [[businessDetailsView alloc] init];
            detail.businessDetailIndex = item.entity_id;
            [self.navigationController pushViewController:detail animated:YES];
        }
            break;
        case 4:
        {
            productDetailsView *detail = [[productDetailsView alloc] init];
            detail.productIndex = item.entity_id;
            [self.navigationController pushViewController:detail animated:YES];
        }
            break;
        case 5:
        {
            
        }
            break;
        case 6:
        {
            jobDetailsView *detail = [[jobDetailsView alloc] init];
            detail.jobDetailsIndex = item.entity_id;
            [self.navigationController pushViewController:detail animated:YES];
        }
            break;
        case 7:
        {
            interfaceDetailsView *detail = [[interfaceDetailsView alloc] init];
            detail.interfaceIndex = item.entity_id;
            [self.navigationController pushViewController:detail animated:YES];
        }
            break;

    
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getCellHeight:indexPath];
}

- (CGFloat)getCellHeight:(NSIndexPath *)indexPath
{
    CGFloat height;
    CommentItem *item = [_dataArray objectAtIndex:indexPath.row];
    CGSize size = [AdaptationSize getSizeFromString:item.content Font:[UIFont systemFontOfSize:contentFont] withHight:CGFLOAT_MAX withWidth:commentWidth];
    
    height = topDistance+25+5+space*2+size.height+10;
    NSLog(@"%f",size.height);
    return height;
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
