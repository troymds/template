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

#define all @"all"
#define market @"market"
#define company @"company"
#define business @"business"
#define display @"display"
#define manager @"manager"
#define job @"job"

@interface MyFavoriteController ()<UITableViewDataSource,UITableViewDelegate,categoryListViewDelegate,UIScrollViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;   //源数组
    NSMutableArray   *deleteArray; //用于记录删除的数组
    NSMutableDictionary *deleteDic;//用于记录删除的字典
    BOOL isEdit;   //是否处于编辑状态
    BOOL isPlay;   //是否展示选项卡
    UIScrollView *categoryView;
    BOOL categoryClick;  //点击了分类页面  刷新页面时用到
    
    //记录下载过的数据
    NSMutableDictionary *downLoadDict;
    
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
    downLoadDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth,kHeight-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    
    [self addRightNavitems];
    
    [self addCategoryView];
    
    [self loadDataWithType:0];
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
    NSMutableArray *imgArray = [NSMutableArray arrayWithObjects:@"",@"catemarket.png",@"catecompany.png",@"catebusiness.png",@"cateplay.png",@"catemanager.png",@"cateadvitise.png", nil];
    NSMutableArray *titileArray = [NSMutableArray arrayWithObjects:@"全部",@"市场行情",@"企业黄页",@"供求商机",@"展会信息",@"产品管理",@"企业招聘",nil];
    categoryView = [[UIScrollView alloc] initWithFrame:CGRectMake(kWidth-150,0,150,kHeight-64)];
    categoryView.backgroundColor = HexRGB(0xededed);
    categoryView.layer.borderColor = HexRGB(0xd5d5d5).CGColor;
    categoryView.delegate = self;
    categoryView.tag = 1999;
    categoryView.layer.borderWidth = 1.0f;
    for (int i = 0 ; i < titileArray.count; i++) {
        UIView *line;
        if (i ==0) {
           line  = [[UIView alloc] initWithFrame:CGRectMake(0,55-1,150,1)];
        }else{
            line = [[UIView alloc] initWithFrame:CGRectMake(0,55+70*i-1,150,1)];
        }
        line.backgroundColor = HexRGB(0xd5d5d5);
        [categoryView addSubview:line];
    }
    for (int i =0 ; i < titileArray.count; i++) {
        CategoryListView *listView;
        if (i == 0) {
            listView = [[CategoryListView alloc] initWithFrame:CGRectMake(0, 0,150,55)];
            listView.imgView.hidden = YES;
        }else{
            listView = [[CategoryListView alloc] initWithFrame:CGRectMake(0,55+70*(i-1), 150, 70)];
            listView.imgView.image = [UIImage imageNamed:[imgArray objectAtIndex:i]];

        }
        listView.titleLabel.text = [titileArray objectAtIndex:i];
        listView.delegate = self;
        listView.tag = 3000+i;
        [categoryView addSubview:listView];
    }
    CGFloat height = kHeight-64;
    if (height<55+70*6) {
        [categoryView setContentSize:CGSizeMake(150,55+70*6)];
    }else{
        [categoryView setContentSize:CGSizeMake(150, height)];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 1999) {
        if (scrollView.contentOffset.y<=0) {
            scrollView.contentOffset = CGPointMake(0, 0);
        }
        if (scrollView.contentOffset.y>=scrollView.contentSize.height) {
            scrollView.contentOffset = CGPointMake(0,scrollView.contentSize.height);
        }
    }
}

//右侧展开分类视图点击
- (void)cateListClick:(CategoryListView *)view
{
    categoryClick = YES;
    [_dataArray removeAllObjects];
    switch (view.tag-3000) {
        case 0:
        {
            if (![downLoadDict objectForKey:all]) {
                [self loadDataWithType:0];
            }else{
                [_dataArray removeAllObjects];
                [_dataArray addObjectsFromArray:[downLoadDict objectForKey:all]];
                [_tableView reloadData];
            }
        }
            break;
        case 1:
        {
            if (![downLoadDict objectForKey:market]) {
                [self loadDataWithType:1];
            }else{
                [_dataArray removeAllObjects];
                [_dataArray addObjectsFromArray:[downLoadDict objectForKey:market]];
                [_tableView reloadData];
            }
        }
            break;
        case 2:
        {
            if (![downLoadDict objectForKey:company]) {
                [self loadDataWithType:2];
            }else{
                [_dataArray removeAllObjects];
                [_dataArray addObjectsFromArray:[downLoadDict objectForKey:company]];
                [_tableView reloadData];
            }
        }
            break;
        case 3:
        {
            if (![downLoadDict objectForKey:business]) {
                [self loadDataWithType:3];
            }else{
                [_dataArray removeAllObjects];
                [_dataArray addObjectsFromArray:[downLoadDict objectForKey:business]];
                [_tableView reloadData];
            }
        }
            break;
        case 4:
        {
            if (![downLoadDict objectForKey:display]) {
                [self loadDataWithType:7];
            }else{
                [_dataArray removeAllObjects];
                [_dataArray addObjectsFromArray:[downLoadDict objectForKey:display]];
                [_tableView reloadData];
            }
        }
            break;
        case 5:
        {
            if (![downLoadDict objectForKey:manager]) {
                [self loadDataWithType:4];
            }else{
                [_dataArray removeAllObjects];
                [_dataArray addObjectsFromArray:[downLoadDict objectForKey:manager]];
                [_tableView reloadData];
            }
        }
            break;
        case 6:
        {
            if (![downLoadDict objectForKey:job]) {
                [self loadDataWithType:6];
            }else{
                [_dataArray removeAllObjects];
                [_dataArray addObjectsFromArray:[downLoadDict objectForKey:job]];
                [_tableView reloadData];
            }
        }
            break;

        default:
            break;
    }
    isPlay = NO;
    [categoryView removeFromSuperview];

}



//加载数据
- (void)loadDataWithType:(int)type
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (type == 0) {
        param = nil;
    }else{
       NSString *typeStr = [NSString stringWithFormat:@"%d",type];
        [param setValue:typeStr forKey:@"type"];
    }
    [httpTool postWithPath:@"getCollectionList" params:param success:^(id JSON) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic = [result objectForKey:@"response"];
        int code = [[dic objectForKey:@"code"] intValue];
        if (code == 100) {
            NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithCapacity:0];
            NSArray *array = [dic objectForKey:@"data"];
            if ([array isKindOfClass:[NSNull class]]) {
                if (categoryClick) {
                    [_dataArray removeAllObjects];
                }
            }else{
                for (NSDictionary *subDic in array) {
                    FavoriteItem  *item = [[FavoriteItem alloc] initWithDic:subDic];
                    [_dataArray addObject:item];
                    [mutableArr addObject:item];
                }
                
            }
            switch (type) {
                case 0:
                {
                    [downLoadDict setObject:mutableArr forKey:all];
                }
                    break;
                case 1:
                {
                    [downLoadDict setObject:mutableArr forKey:market];
                }
                    break;
                case 2:
                {
                    [downLoadDict setObject:mutableArr forKey:company];
                }
                    break;
                case 3:
                {
                    [downLoadDict setObject:mutableArr forKey:business];
                }
                    break;
                case 4:
                {
                    [downLoadDict setObject:mutableArr forKey:display];
                }
                    break;
                case 5:
                {
                    [downLoadDict setObject:mutableArr forKey:manager];
                }
                    break;
                case 6:
                {
                    [downLoadDict setObject:mutableArr forKey:job];
                }
                    break;
                    
                default:
                    break;
            }
            [_tableView reloadData];
        }else{
            NSString *msg = [dic objectForKey:@"msg"];
            [RemindView showViewWithTitle:msg location:MIDDLE];
        }
    } failure:^(NSError *error) {
        [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
    }];
}

//编辑
- (void)edit:(UIButton *)btn
{
    if (!isEdit) {
        isEdit = YES;
        [_tableView setEditing:YES animated:YES];
        btn.selected = !btn.selected;
    }else{
        //需要删除的数据数组
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
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:collection_ids,@"collection_ids", nil];
            [httpTool postWithPath:@"batchCancelCollection" params:param success:^(id JSON) {
                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
                NSDictionary *dic = [result objectForKey:@"response"];
                int code = [[dic objectForKey:@"code"] intValue];
                if (code == 100) {
                    //删除成功
                    
                    isEdit = NO;
                    btn.selected = !btn.selected;
                    
                    [_dataArray removeObjectsInArray:arr];
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
            [_tableView setEditing:NO animated:YES];
        }
    }
    
}
//分类列表展开按钮点击
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
