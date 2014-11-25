//
//  MyFavoriteController.m
//  XinNet
//
//  Created by tianj on 14-11-20.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "MyFavoriteController.h"
#import "FavoriteCell.h"
#import "FavoriteItem.h"
#import "MoreListView.h"

@interface MyFavoriteController ()<UITableViewDataSource,UITableViewDelegate,MoreListViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSMutableArray   *deleteArray; //用于记录删除的数组
    NSMutableDictionary *deleteDic;//用于记录删除的字典
    BOOL isEdit;   //是否处于编辑状态
    BOOL isPlay;   //是否展示选项卡
    UIView *categoryView;
}
@end

@implementation MyFavoriteController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HexRGB(0xffffff);
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout  = UIRectEdgeNone;
    }
    self.title = @"我的收藏";
    // Do any additional setup after loading the view.
    
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    deleteArray = [[NSMutableArray alloc] initWithCapacity:0];
    deleteDic = [NSMutableDictionary dictionary];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth,kHeight-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    
    [self addRightNavitems];
    
    [self addCategoryView];
    
    [self loadData];
}

//添加右导航按钮
- (void)addRightNavitems
{
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.frame = CGRectMake(0, 0, 40, 25);
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setTitle:@"删除" forState:UIControlStateSelected];
    [editBtn setTitleColor:HexRGB(0x3a3a3a) forState:UIControlStateNormal];
    [editBtn setTitleColor:HexRGB(0x3a3a3a) forState:UIControlStateSelected];
    [editBtn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:editBtn];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 25);
    [button setTitle:@"分类" forState:UIControlStateNormal];
    [button setTitleColor:HexRGB(0x3a3a3a) forState:UIControlStateNormal];
    [button setTitleColor:HexRGB(0x3a3a3a) forState:UIControlStateSelected];
    [button addTarget:self action:@selector(playMore) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:button];

    NSArray *array = [NSArray arrayWithObjects:item1,item2, nil];
    self.navigationItem.rightBarButtonItems = array;
}

//初始化右侧展开的分类视图
- (void)addCategoryView
{
    NSMutableArray *imgArray = [NSMutableArray arrayWithObjects:@"l",@"l",@"l",@"l",@"l",@"l", nil];
    NSMutableArray *titileArray = [NSMutableArray arrayWithObjects:@"全部",@"市场行情",@"企业黄页",@"供求商机",@"企业招聘",@"展会信息",nil];
    categoryView = [[UIView alloc] initWithFrame:CGRectMake(kWidth-150,0,150,35*titileArray.count)];
    categoryView.backgroundColor = [UIColor whiteColor];
    categoryView.layer.borderColor = HexRGB(0xd5d5d5).CGColor;
    categoryView.layer.borderWidth = 1.0f;
    for (int i = 0 ; i < titileArray.count; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,35*i-1,150,1)];
        line.backgroundColor = HexRGB(0xd5d5d5);
        [categoryView addSubview:line];
    }
    for (int i =0 ; i < titileArray.count; i++) {
        MoreListView *listView = [[MoreListView alloc] initWithFrame:CGRectMake(0, 35*i, 150, 35)];
        listView.titleLabel.text = [titileArray objectAtIndex:i];
        listView.imgView.image = [UIImage imageNamed:[imgArray objectAtIndex:i]];
        listView.delegate = self;
        listView.tag = 3000+i;
        [categoryView addSubview:listView];
    }
}

//右侧展开分类视图点击
- (void)moreListViewClick:(MoreListView *)view
{
    [_dataArray removeAllObjects];
    switch (view.tag-3000) {
        case 0:
        {
            for (int i =0; i < 10; i++) {
                FavoriteItem *item = [[FavoriteItem alloc] init];
                item.title = @"全部";
                [_dataArray addObject:item];
            }
            [_tableView reloadData];
            
        }
            break;
        case 1:
        {
            for (int i =0; i < 10; i++) {
                FavoriteItem *item = [[FavoriteItem alloc] init];
                item.title = @"市场行情";
                [_dataArray addObject:item];
            }
            [_tableView reloadData];
            
        }
            break;
        case 2:
        {
            for (int i =0; i < 10; i++) {
                FavoriteItem *item = [[FavoriteItem alloc] init];
                item.title = @"企业黄页";
                [_dataArray addObject:item];
            }
            [_tableView reloadData];
            
        }
            break;
        case 3:
        {
            for (int i =0; i < 10; i++) {
                FavoriteItem *item = [[FavoriteItem alloc] init];
                item.title = @"供求商机";
                [_dataArray addObject:item];
            }
            [_tableView reloadData];
            
        }
            break;
        case 4:
        {
            for (int i =0; i < 10; i++) {
                FavoriteItem *item = [[FavoriteItem alloc] init];
                item.title = @"企业招聘";
                [_dataArray addObject:item];
            }
            [_tableView reloadData];
            
        }
            break;
        case 5:
        {
            for (int i =0; i < 10; i++) {
                FavoriteItem *item = [[FavoriteItem alloc] init];
                item.title = @"展会信息";
                [_dataArray addObject:item];
            }
            [_tableView reloadData];
            
        }
            break;
            
        default:
            break;
    }
    isPlay = NO;
    [categoryView removeFromSuperview];
}

- (void)loadData
{
    for (int i =0; i < 10; i++) {
        FavoriteItem *item = [[FavoriteItem alloc] init];
        item.title = @"标题文字";
        [_dataArray addObject:item];
    }
    [_tableView reloadData];
}

//编辑
- (void)edit:(UIButton *)btn
{
    isEdit = !isEdit;
    btn.selected = !btn.selected;
    if (isEdit) {
        [_tableView setEditing:YES animated:YES];
    }else{
        //需要删除的数据数组
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i < [deleteArray count]; i++) {
            NSIndexPath *indexPath = [deleteArray objectAtIndex:i];
            FavoriteItem *item = [_dataArray objectAtIndex:indexPath.row];
            [arr addObject:item];
        }
        [_dataArray removeObjectsInArray:arr];
        [_tableView deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationFade];
        [deleteArray removeAllObjects];
        [_tableView setEditing:NO];
    }
}

- (void)playMore
{
    isPlay = !isPlay;
    if (isPlay) {
        [self.view addSubview:categoryView];
    }else{
        [categoryView removeFromSuperview];
    }
}

- (UITableViewCellEditingStyle )tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cellName";
    FavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[FavoriteCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    FavoriteItem *item =  [_dataArray objectAtIndex:indexPath.row];
    cell.titleLabel.text =item.title;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isEdit) {
        [deleteArray addObject:indexPath];
    }
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isEdit) {
        [deleteArray removeObject:indexPath];
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
