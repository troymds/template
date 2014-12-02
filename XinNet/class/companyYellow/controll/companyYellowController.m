//
//  companyYellowController.m
//  NewView
//
//  Created by YY on 14-11-18.
//  Copyright (c) 2014年 ___普而摩___. All rights reserved.
//

#import "companyYellowController.h"
#import "AppMacro.h"
#import "companyYellowCell.h"
#import "companyDetailsView.h"
#import "categoryLestModel.h"
#import "companyListModel.h"
#import "companyListTool.h"
@interface companyYellowController ()<UITableViewDelegate,UITableViewDataSource,MJRefreshBaseViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_companyArray;
    UILabel *dataLabel;
    MJRefreshFooterView *_footer;
    BOOL isLoadMore;//判断是否加载更多
}

@property (nonatomic,assign) NSInteger pageNum;//页数
@property (nonatomic,strong) NSString *page;//页数
@end

@implementation companyYellowController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"企业黄页";
    self.view.backgroundColor =[UIColor whiteColor];
    _companyArray =[[NSMutableArray alloc]init];
    
    _pageNum = 0;
    self.page = [NSString stringWithFormat:@"%ld",(long)_pageNum];
    
    [self addLoadStatus];
    [self addTableView];
    [self addMBprogressView];
    [self addRefreshViews];
    [self addShowNoDataView];
}

- (void)addShowNoDataView
{
    dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    dataLabel.textAlignment = NSTextAlignmentCenter;
    dataLabel.backgroundColor = [UIColor clearColor];
    dataLabel.text = @"没有数据！";
    dataLabel.hidden = YES;
    dataLabel.enabled = NO;
    [self.view addSubview:dataLabel];
    
    
}
#pragma  mark ------显示指示器
-(void)addMBprogressView{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

}

#pragma mark 集成刷新控件
- (void)addRefreshViews
{
    
    // 2.上拉加载更多
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = _tableView;
    footer.delegate = self;
    _footer = footer;
    isLoadMore = NO;
}

#pragma mark 刷新代理方法
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    // 下拉刷新
    if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) {
        // 上拉加载更多
        [self addLoadStatus:refreshView];
    }
}

#pragma mark 加载数据
-(void)addLoadStatus
{
    _pageNum = 0;
    self.page = [NSString stringWithFormat:@"%d",_pageNum];

    if (!isLoadMore) {
        isLoadMore = YES;
        _footer.hidden = NO;
    }
    [companyListTool statusesWithSuccess:^(NSArray *statues) {
        if (statues.count ==0) {
            dataLabel.hidden =NO;
            _tableView.hidden = YES;
        }else{
            dataLabel.hidden = YES;
            _tableView.hidden =NO;
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        [_companyArray addObjectsFromArray:statues];
        _pageNum = _companyArray.count % 10 + 1;
        [_tableView reloadData];

    }  keywords_Id:nil page:self.page failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }];
}
#pragma mark ----加载更多数据
-(void)addLoadStatus:(MJRefreshBaseView *)refreshView{
    //更新page
    _pageNum++;
    self.page = [NSString stringWithFormat:@"%d",_pageNum];
    
    [companyListTool statusesWithSuccess:^(NSArray *statues) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (statues.count < 10) {
            isLoadMore = NO;
            _footer.hidden = YES;
             [RemindView showViewWithTitle:@"数据加载完毕" location:MIDDLE];
        }else
        {
            isLoadMore = YES;
            _footer.hidden = NO;
        }
        [_companyArray addObjectsFromArray:statues];

        [_tableView reloadData];
        [refreshView endRefreshing];
    }  keywords_Id:nil page:self.page failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }];
}
-(void)addTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.backgroundColor =[UIColor whiteColor];
    _tableView.hidden = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _companyArray.count   ;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    companyDetailsView *productVC =[[companyDetailsView alloc]init];
    companyListModel *companyModel =[_companyArray objectAtIndex:indexPath.row];
    productVC.headerImage=companyModel.logo;
    productVC.companyDetailIndex =companyModel.type_id;
    [self.navigationController pushViewController:productVC animated:YES];
    
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndexfider =@"cell";
    companyYellowCell *cell =[tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIndexfider];
    if (!cell) {
        cell=[[companyYellowCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
        cell.AccessoryType=UITableViewCellAccessoryDisclosureIndicator;

        UIView *cellLine =[[UIView alloc]initWithFrame:CGRectMake(0, 79, kWidth, 1)];
        [cell.contentView addSubview:cellLine];
        cellLine.backgroundColor =HexRGB(0xe6e3e4);
    }
    companyListModel *comapnyModel =[_companyArray objectAtIndex:indexPath.row];
    [cell.logoImage setImageWithURL:[NSURL URLWithString:comapnyModel.logo] placeholderImage:placeHoderImage2];
    cell.nameLabel.text =comapnyModel.name;
    cell.addressLabel.text =comapnyModel.address;
    return cell;
}

@end
