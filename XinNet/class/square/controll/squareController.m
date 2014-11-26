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

@interface squareController ()<UITableViewDataSource,UITableViewDelegate,TJImageViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    int _page;
    BOOL isRefresh;
    BOOL isLoad;
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
    [self loadData];
    [self addHeadView];
}

//添加右导航按钮
- (void)addRightNavButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0,75, 25);
    [button setTitle:@"发布话题" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBarButtonDown) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

//右导航按钮点击
- (void)rightBarButtonDown
{
    PublishTopicController *ptc = [[PublishTopicController alloc] init];
    [self.navigationController pushViewController:ptc animated:YES];
}

//顶部图片
- (void)addHeadView
{
    SquareHeadView *headView = [[SquareHeadView alloc] initWithFrame:CGRectMake(0, 0, kWidth,154)];
    headView.iconImg.image = [UIImage imageNamed:@"l"];
    headView.iconImg.delegate = self;
    headView.nameLabel.text = @"我是雷某某";
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,headView.frame.size.height-1,kWidth,1)];
    line.backgroundColor = HexRGB(0xd5d5d5);
    [headView addSubview:line];
    _tableView.tableHeaderView = headView;
}


//个人头像点击
- (void)imageViewClick:(TJImageView *)view
{
    PersonalController *pc = [[PersonalController alloc] init];
    [self.navigationController pushViewController:pc animated:YES];
}


- (void)loadData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"10",@"pagesize", nil];
    if (isRefresh) {
        _page = 0;
    }
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
            NSArray *data = [dic objectForKey:@"data"];
            if (![data isKindOfClass:[NSNull class]]) {
                for (NSDictionary *subDic in data) {
                    SquareUserItem *item = [[SquareUserItem alloc] initWithDic:subDic];
                    [_dataArray addObject:item];
                }
            }
            [_tableView reloadData];
        }
    } failure:^(NSError *error) {
        [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
    }];
}



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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getCellHeight:indexPath];
}

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
