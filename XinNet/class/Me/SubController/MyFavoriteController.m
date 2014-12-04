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
#import "CategoryListView.h"
#import "httpTool.h"
#import "RemindView.h"
#import "markertDetailsView.h"
#import "companyDetailsView.h"
#import "businessDetailsView.h"
#import "productDetailsView.h"
#import "jobDetailsView.h"
#import "interfaceDetailsView.h"
#import "MBProgressHUD.h"
#import "CategoryView.h"
#import "MJRefresh.h"




#define all @"all"
#define market @"market"
#define company @"company"
#define business @"business"
#define display @"display"
#define manager @"manager"
#define job @"job"

#define kPagesize 10

@interface MyFavoriteController ()<UITableViewDataSource,UITableViewDelegate,CategoryViewDelegate,UIScrollViewDelegate,MJRefreshBaseViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;   //源数组
    NSMutableArray   *deleteArray; //用于记录删除的数组
    NSMutableDictionary *deleteDic;//用于记录删除的字典
    BOOL isEdit;   //是否处于编辑状态
    BOOL isPlay;   //是否展示右侧分类
    CategoryView *_categoryView;  //右侧分类视图
    BOOL isFirstLoad;  //第一次请求某分类数据
    //记录下载过的数据
    NSMutableDictionary *downLoadDict;
    UIView *noDataView;
    
    UIButton *editBtn;
    UIButton *moreBtn;
    
    int _page;//分页
    int _type;// 实体类型  新闻1，公司2，商机3，产品4，话题5，招聘6，展会7
    
    BOOL isLoad; //是否在加载
    
    MJRefreshFooterView *footView;
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
    _page = 0;
    _type = 0;
    
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    deleteArray = [[NSMutableArray alloc] initWithCapacity:0];
    deleteDic = [NSMutableDictionary dictionary];
    downLoadDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth,kHeight-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth,kHeight-64)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,kWidth,20)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"没有收藏";
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.center = noDataView.center;
    [noDataView addSubview:label];
    [self.view addSubview:noDataView];
    noDataView.hidden = YES;
    
    
    [self addRightNavitems];
    
    [self addCategoryView];
    
    [self loadDataWithType:_type];
    
    [self addRefreshView];
}

#pragma mark 添加家在试图
- (void)addRefreshView
{
    footView = [[MJRefreshFooterView alloc] init];
    footView.delegate = self;
    footView.scrollView = _tableView;
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) {
        isLoad = YES;
        [self loadDataWithType:_type];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        if (isEdit) {
            if (scrollView.contentOffset.y<0) {
                scrollView.contentOffset = CGPointMake(0, 0);
            }
            if (scrollView.contentSize.height<scrollView.frame.size.height) {
                if (scrollView.contentOffset.y>0) {
                    scrollView.contentOffset = CGPointMake(0,0);
                }
            }else{
                if (scrollView.contentOffset.y>scrollView.contentSize.height-scrollView.frame.size.height) {
                    scrollView.contentOffset = CGPointMake(0, scrollView.contentSize.height-scrollView.frame.size.height);
                }
            }
        }
    }
}

#pragma mark 添加右导航按钮
- (void)addRightNavitems
{
    //编辑
    editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.frame = CGRectMake(0, 0, 30, 30);
    [editBtn setBackgroundImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    [editBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateSelected];
    [editBtn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    
    //更多
    moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(0, 0, 20, 20);
    [moreBtn setBackgroundImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(playMore) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:moreBtn];
    
    NSArray *array = [NSArray arrayWithObjects:item1,item2, nil];
    self.navigationItem.rightBarButtonItems = array;
}

#pragma mark 初始化右侧展开的分类视图
- (void)addCategoryView
{
    _categoryView = [[CategoryView alloc] initWithFrame:CGRectMake(0, 0, kWidth,kHeight-64)];
    _categoryView.delegate = self;
}

#pragma mark categoryView_delegate
- (void)categoryClick:(CategoryListView *)view
{
    switch (view.tag-3000) {
        case 0:
        {
            //查看字典中是否已经下载过该类别的数据 没下载过则下载 下载过则取出对应数据
            if (![downLoadDict objectForKey:all]) {
                //第一次加载该数据  page置为0
                _page = 0;
                isFirstLoad = YES;
                [self loadDataWithType:0];
            }else{
                
                [_dataArray removeAllObjects];
                //从字典中取出加载过的该类数据
                [_dataArray addObjectsFromArray:[downLoadDict objectForKey:all]];
                _page = [_dataArray count]%kPagesize ==0? ((int)[_dataArray count]/kPagesize)-1:(int)_dataArray.count/kPagesize;
                if (_dataArray.count!=0) {
                    noDataView.hidden = YES;
                }else{
                    noDataView.hidden = NO;
                }
                if (isEdit) {
                    isEdit = NO;
                    editBtn.selected = NO;
                    [_tableView setEditing:NO];
                }
                [_tableView reloadData];
            }
        }
            break;
        case 1:
        {
            if (![downLoadDict objectForKey:market]) {
                _page = 0;
                isFirstLoad = YES;
                [self loadDataWithType:1];
            }else{
                [_dataArray removeAllObjects];
                [_dataArray addObjectsFromArray:[downLoadDict objectForKey:market]];
                _page = [_dataArray count]%kPagesize ==0? ((int)[_dataArray count]/kPagesize)-1:(int)_dataArray.count/kPagesize;
                if (_dataArray.count!=0) {
                    noDataView.hidden = YES;
                }else{
                    noDataView.hidden = NO;
                }
                if (isEdit) {
                    isEdit = NO;
                    editBtn.selected = NO;
                    [_tableView setEditing:NO];
                }
                [_tableView reloadData];
            }
        }
            break;
        case 2:
        {
            if (![downLoadDict objectForKey:company]) {
                _page = 0;
                isFirstLoad = YES;
                [self loadDataWithType:2];
            }else{
                [_dataArray removeAllObjects];
                [_dataArray addObjectsFromArray:[downLoadDict objectForKey:company]];
                _page = [_dataArray count]%kPagesize ==0? ((int)[_dataArray count]/kPagesize)-1:(int)_dataArray.count/kPagesize;
                if (_dataArray.count!=0) {
                    noDataView.hidden = YES;
                }else{
                    noDataView.hidden = NO;
                }
                if (isEdit) {
                    isEdit = NO;
                    editBtn.selected = NO;
                    [_tableView setEditing:NO];
                }
                [_tableView reloadData];
            }
        }
            break;
        case 3:
        {
            if (![downLoadDict objectForKey:business]) {
                _page = 0;
                isFirstLoad = YES;
                [self loadDataWithType:3];
            }else{
                [_dataArray removeAllObjects];
                [_dataArray addObjectsFromArray:[downLoadDict objectForKey:business]];
                _page = [_dataArray count]%kPagesize ==0? ((int)[_dataArray count]/kPagesize)-1:(int)_dataArray.count/kPagesize;
                if (_dataArray.count!=0) {
                    noDataView.hidden = YES;
                }else{
                    noDataView.hidden = NO;
                }
                if (isEdit) {
                    isEdit = NO;
                    editBtn.selected = NO;
                    [_tableView setEditing:NO];
                }
                [_tableView reloadData];
            }
        }
            break;
        case 4:
        {
            if (![downLoadDict objectForKey:display]) {
                _page = 0;
                isFirstLoad = YES;
                [self loadDataWithType:7];
            }else{
                [_dataArray removeAllObjects];
                [_dataArray addObjectsFromArray:[downLoadDict objectForKey:display]];
                _page = [_dataArray count]%kPagesize ==0? ((int)[_dataArray count]/kPagesize)-1:(int)_dataArray.count/kPagesize;
                if (_dataArray.count!=0) {
                    noDataView.hidden = YES;
                }else{
                    noDataView.hidden = NO;
                }
                if (isEdit) {
                    isEdit = NO;
                    editBtn.selected = NO;
                    [_tableView setEditing:NO];
                }
                [_tableView reloadData];
            }
        }
            break;
        case 5:
        {
            if (![downLoadDict objectForKey:manager]) {
                _page = 0;
                isFirstLoad = YES;
                [self loadDataWithType:4];
            }else{
                [_dataArray removeAllObjects];
                [_dataArray addObjectsFromArray:[downLoadDict objectForKey:manager]];
                _page = [_dataArray count]%kPagesize ==0? ((int)[_dataArray count]/kPagesize)-1:(int)_dataArray.count/kPagesize;
                if (_dataArray.count!=0) {
                    noDataView.hidden = YES;
                }else{
                    noDataView.hidden = NO;
                }
                if (isEdit) {
                    isEdit = NO;
                    editBtn.selected = NO;
                    [_tableView setEditing:NO];
                }
                [_tableView reloadData];
            }
        }
            break;
        case 6:
        {
            if (![downLoadDict objectForKey:job]) {
                _page = 0;
                isFirstLoad = YES;
                [self loadDataWithType:6];
            }else{
                [_dataArray removeAllObjects];
                [_dataArray addObjectsFromArray:[downLoadDict objectForKey:job]];
                _page = [_dataArray count]%kPagesize ==0? ((int)[_dataArray count]/kPagesize)-1:(int)_dataArray.count/kPagesize;
                if (_dataArray.count!=0) {
                    noDataView.hidden = YES;
                }else{
                    noDataView.hidden = NO;
                }
                if (isEdit) {
                    isEdit = NO;
                    editBtn.selected = NO;
                    [_tableView setEditing:NO];
                }
                [_tableView reloadData];
            }
        }
            break;
            
        default:
            break;
    }
    isPlay = NO;
    [_categoryView removeFromSuperview];
}


- (void)tapClick
{
    isPlay = NO;
    [_categoryView removeFromSuperview];
}

#pragma mark 请求数据
- (void)loadDataWithType:(int)type
{
    NSString *pagesize = [NSString stringWithFormat:@"%d",kPagesize];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:pagesize,@"pagesize", nil];
    if (type != 0) {
        NSString *typeStr = [NSString stringWithFormat:@"%d",type];
        [param setValue:typeStr forKey:@"type"];
    }
    if (isLoad) {
        _page ++;
    }
    NSString *page = [NSString stringWithFormat:@"%d",_page];
    [param setObject:page forKey:@"page"];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = NO;
    [httpTool postWithPath:@"getCollectionList" params:param success:^(id JSON) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",result);
        NSDictionary *dic = [result objectForKey:@"response"];
        int code = [[dic objectForKey:@"code"] intValue];
        if (code == 100) {
            //第一次加载某分类数据时都把数据源数组清空
            if (isFirstLoad) {
                isFirstLoad = NO;
                [_dataArray removeAllObjects];
            }
            NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithCapacity:0];
            NSArray *array = [dic objectForKey:@"data"];
            if ([array isKindOfClass:[NSNull class]]) {
                //上拉加载回来的数据为空
                if (isLoad) {
                    [RemindView showViewWithTitle:@"数据加载完毕" location:MIDDLE];
                }else{
                //第一次加载回来的数据为空
                    noDataView.hidden = NO;
                }
            }else{
                noDataView.hidden = YES;
                for (NSDictionary *subDic in array) {
                    FavoriteItem  *item = [[FavoriteItem alloc] initWithDic:subDic];
                    [_dataArray addObject:item];
                }
            }
            [mutableArr addObjectsFromArray:_dataArray];
            
            //加载成功后 将当前加载的数据分类类型存储起来
            _type = type;
            
            
            //将下载后的数据存入到字典中 这样以后每次点击分类时 如果下载过了 就不用再下载 直接从字典中取
            [self saveDataWithType:type data:mutableArr];

            //如果在编辑  则改为编辑前的状态
            if (isEdit) {
                isEdit = NO;
                editBtn.selected = NO;
                [_tableView setEditing:NO];
            }
            //如果是上拉加载  结束加载动画
            if (isLoad) {
                isLoad = NO;
                [footView endRefreshing];
            }
            [_tableView reloadData];
        }else{
            NSString *msg = [dic objectForKey:@"msg"];
            [RemindView showViewWithTitle:msg location:MIDDLE];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
    }];
}

//将下载后的数据存到字典中
- (void)saveDataWithType:(int)type data:(NSMutableArray *)data
{
    switch (type) {
            //全部
        case 0:
        {
            [downLoadDict setObject:data forKey:all];
        }
            break;
            //市场行情
        case 1:
        {
            [downLoadDict setObject:data forKey:market];
        }
            break;
            //公司
        case 2:
        {
            [downLoadDict setObject:data forKey:company];
        }
            break;
            //商机
        case 3:
        {
            [downLoadDict setObject:data forKey:business];
        }
            break;
            //产品管理
        case 4:
        {
            [downLoadDict setObject:data forKey:manager];
        }
            break;
            //招聘
        case 6:
        {
            [downLoadDict setObject:data forKey:job];
        }
            break;
            //展会
        case 7:
        {
            [downLoadDict setObject:data forKey:display];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark 编辑
- (void)edit:(UIButton *)btn
{
    if (_dataArray.count==0) {
        [RemindView showViewWithTitle:@"没有可编辑的数据" location:MIDDLE];
    }else{
        if (!isEdit) {
            isEdit = YES;
            [_tableView setEditing:YES animated:YES];
            btn.selected = !btn.selected;
        }else{
            //需要删除的数据
            NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
            
            //如果有删除数据 进行删除
            if (deleteArray.count!=0) {
                for (int i = 0; i < [deleteArray count]; i++) {
                    NSIndexPath *indexPath = [deleteArray objectAtIndex:i];
                    FavoriteItem *item = [_dataArray objectAtIndex:indexPath.row];
                    [arr addObject:item];
                }
                NSMutableString *collection_ids = [NSMutableString stringWithString:@""];
                for (int i = 0 ; i < arr.count;i++) {
                    FavoriteItem *item = [arr objectAtIndex:i];
                    if (i<deleteArray.count-1) {
                        [collection_ids appendString:[NSString stringWithFormat:@"%@,",item.vid]];
                    }else{
                        [collection_ids appendString:item.vid];
                    }
                }
                //请求删除
                NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:collection_ids,@"collection_ids", nil];
                [httpTool postWithPath:@"batchCancelCollection" params:param success:^(id JSON) {
                    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
                    NSDictionary *dic = [result objectForKey:@"response"];
                    int code = [[dic objectForKey:@"code"] intValue];
                    if (code == 100) {
                        
                        //删除成功
                        isEdit = NO;
                        btn.selected = !btn.selected;
                        
                        
                        //把字典中存的数据也要清空
                        [self deleteDictData];
                        
                        [_dataArray removeObjectsInArray:arr];
                        //删除数组中的数据后要重新设置page
                        _page = _dataArray.count%10==0?((int)_dataArray.count/10==0?0:((int)_dataArray.count/10)-1):(int)_dataArray.count/10;
                        
                        [_tableView deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationFade];
                        [_tableView setEditing:NO];
                        [deleteArray removeAllObjects];
                    }else{
                        NSString *msg = [dic objectForKey:@"msg"];
                        [RemindView showViewWithTitle:msg location:MIDDLE];
                    }
                } failure:^(NSError *error) {
                    [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
                }];
            }else{
                isEdit = NO;
                btn.selected = NO;
                [_tableView setEditing:NO animated:YES];
            }
        }
    }
}

#pragma mark 清空字典中的对应分类数据
- (void)deleteDictData
{
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
    switch (_type) {
            //如果清空的是"全部"收藏 则清空字典中的所有数组
        case 0:
        {
            NSArray *allKeys = [deleteDic allKeys];
            for (NSString *str in allKeys) {
                [deleteDic setObject:arr forKey:str];
            }
        }
            break;
        case 1:
        {
            [deleteDic setObject:arr forKey:market];
        }
            break;
        case 2:
        {
            [deleteDic setObject:arr forKey:company];
        }
            break;
        case 3:
        {
            [deleteDic setObject:arr forKey:business];
        }
            break;
        case 4:
        {
            [deleteDic setObject:arr forKey:manager];
        }
            break;
        case 6:
        {
            [deleteDic setObject:arr forKey:job];
        }
            break;
        case 7:
        {
            [deleteDic setObject:arr forKey:display];
        }
            break;
            
        default:
            break;
    }

}

#pragma mark  点击更多按钮
- (void)playMore
{
    isPlay = !isPlay;
    if (isPlay) {
        [self.view addSubview:_categoryView];
    }else{
        [_categoryView removeFromSuperview];
    }
}

#pragma mark tableview_delegate
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
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49,kWidth,1)];
    line.backgroundColor = HexRGB(0xd5d5d5);
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    [cell addSubview:line];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isEdit) {
        [deleteArray addObject:indexPath];
    }else{
        FavoriteItem *item = [_dataArray objectAtIndex:indexPath.row];
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
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isEdit) {
        [deleteArray removeObject:indexPath];
    }
}

#pragma mark   -----------

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
