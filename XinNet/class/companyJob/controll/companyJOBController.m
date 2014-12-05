//
//  companyJOBController.m
//  NewView
//
//  Created by YY on 14-11-18.
//  Copyright (c) 2014年 ___普而摩___. All rights reserved.
//

#import "companyJOBController.h"
#import "companyJobCell.h"
#import "jobDetailsView.h"
#import "companyJobModel.h"
#import "companyJobTool.h"

@interface companyJOBController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    
    NSMutableArray *_companyJobArray;
    MJRefreshFooterView *_footer;
    BOOL isLoadMore;//判断是否加载更多
    UILabel *dataLabel;
}

@property (nonatomic,assign) NSInteger pageNum;//页数
@property (nonatomic,strong) NSString *page;//页数
@end

@implementation companyJOBController
@synthesize tableView =_tableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    if (IsIos7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor =[UIColor whiteColor];
    self.title = @ "企业招聘";
    _companyJobArray =[NSMutableArray array];
    [self addShowNoDataView];
    
    _pageNum = 0;
    self.page = [NSString stringWithFormat:@"%d",_pageNum];
    [self addTableView];
    [self addRefreshViews];
    [self addLoadStatus];
    
}

#pragma  mark ------显示指示器
-(void)addMBprogressView{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    
}

#pragma mark 集成刷新控件
- (void)addRefreshViews
{
    
    // 2.上拉加载更多
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
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

#pragma mark ----加载更多数据
-(void)addLoadStatus:(MJRefreshBaseView *)refreshView{
    //更新page
    _pageNum++;
    self.page = [NSString stringWithFormat:@"%d",_pageNum];
    [companyJobTool statusesWithSuccess:^(NSArray *statues) {
        if (statues.count < 10) {
            isLoadMore = NO;
            _footer.hidden = YES;
             [RemindView showViewWithTitle:@"数据加载完毕" location:MIDDLE];
        }else
        {
            isLoadMore = YES;
            _footer.hidden = NO;
        }
               [_companyJobArray addObjectsFromArray:statues];
        [self.tableView reloadData];
        [refreshView endRefreshing];
    } company_Id:nil keywords_Str:nil page:self.page failure:^(NSError *error) {
        
    }];
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

#pragma mark----加载数据
-(void)addLoadStatus{
    [self addMBprogressView];

    _pageNum = 0;
    self.page = [NSString stringWithFormat:@"%d",_pageNum];

    if (!isLoadMore) {
        isLoadMore = YES;
        _footer.hidden = NO;
    }
    
    [companyJobTool statusesWithSuccess:^(NSArray *statues) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        if (statues.count ==0) {
            dataLabel.hidden =NO;
            _tableView.hidden = YES;
        }else{
            dataLabel.hidden = YES;
            _tableView.hidden =NO;
        }
        [_companyJobArray removeAllObjects];
        [_companyJobArray addObjectsFromArray:statues];
      

        [_tableView reloadData];
    } company_Id:nil keywords_Str:nil page:self.page failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    }];
}

-(void)addTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, KAppH) style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.hidden =NO;
    _tableView.backgroundColor =[UIColor whiteColor];
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];

}
#pragma mark---TableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _companyJobArray.count   ;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    companyJobModel *jobModel =[_companyJobArray objectAtIndex:indexPath.row];
    

    jobDetailsView *jobVc =[[jobDetailsView alloc]init];
    jobVc.job_urlWeb = jobModel.job_url;
    jobVc.company_urlWeb = jobModel.company_url;
    jobVc.jobDetailsIndex =jobModel.indexId;
    [self.navigationController pushViewController:jobVc animated:YES];
    
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndexfider =@"cell";
    companyJobCell *cell =[tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIndexfider];
    if (!cell) {
        cell=[[companyJobCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
        UIView *cellLine =[[UIView alloc]initWithFrame:CGRectMake(0, 79, kWidth, 1)];
        cell.AccessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;

        
        [cell.contentView addSubview:cellLine];
        cellLine.backgroundColor =HexRGB(0xe6e3e4);
    }
    companyJobModel *jobModel =[_companyJobArray objectAtIndex:indexPath.row];
    cell.nameLabel.text =jobModel.title;
    cell.companyLabel.text =jobModel.company_name;
    cell.timeLael.text =jobModel.create_time;
    
    return cell;
}



@end
