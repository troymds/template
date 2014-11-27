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
}
@end

@implementation companyYellowController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"企业黄页";
    self.view.backgroundColor =[UIColor whiteColor];
    _companyArray =[[NSMutableArray alloc]init];
    [self addLoadStatus:nil];
    [self addTableView];
    [self addMBprogressView];
    [self addRefreshViews];
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
}

#pragma mark 刷新代理方法
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    // 下拉刷新
    if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) {
        // 上拉加载更多
        [self addLoadStatus:refreshView];
    } else {
        
    }
    
    
}

#pragma mark ----加载数据
-(void)addLoadStatus:(MJRefreshBaseView *)refreshView{

    [companyListTool statusesWithSuccess:^(NSArray *statues) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [_companyArray removeAllObjects];
        [_companyArray addObjectsFromArray:statues];
        [_tableView reloadData];
        [refreshView endRefreshing];
    }  keywords_Id:nil failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        
    }];
}
-(void)addTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.backgroundColor =[UIColor whiteColor];
    
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
    [cell.logoImage setImageWithURL:[NSURL URLWithString:comapnyModel.logo] placeholderImage:placeHoderImage];
    cell.nameLabel.text =comapnyModel.name;
    cell.addressLabel.text =comapnyModel.address;
    return cell;
}

@end
