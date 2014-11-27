//
//  marketController.m
//  NewView
//
//  Created by YY on 14-11-18.
//  Copyright (c) 2014年 ___普而摩___. All rights reserved.
//

#import "marketController.h"
#import "companyJOBController.h"
#import "markertDetailsView.h"
#import "marketCell.h"
#import "marketTOOL.h"
#import "marketModel.h"
#import "UIImageView+WebCache.h"
#import "categoryLestTool.h"
#import "categoryLestModel.h"
@interface marketController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    UITableView *_tableView;
    UIView *_moreView;
    UIButton *_bigButton;
    UIButton *_moreSelectedBtn;
    NSMutableArray *_marketArray;
    NSMutableArray *_cagegoryArray;
    NSString *_category_Index;
}
@end

@implementation marketController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"市场行情";
    self.view.backgroundColor =[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithSearch:@"more.png" highlightedSearch:@"more.png" target:(self) action:@selector(categoryBtnClick:)];
    _moreSelectedBtn =[[UIButton alloc]init];
    _marketArray =[[NSMutableArray alloc]init];
    _cagegoryArray=[[NSMutableArray alloc]init];
    _category_Index = [[NSString alloc]init];
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
    footer.scrollView = _tableView;
    footer.delegate = self;
}

#pragma mark 刷新代理方法
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    // 下拉刷新
    if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) {
        // 上拉加载更多
        [self addloadStatus:refreshView];
    } else {
       
    }
    
    
}
-(void)addLoadStatus{
    [self addMBprogressView];
    [marketTOOL statusesWithSuccess:^(NSArray *statues) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        [_marketArray removeAllObjects];
        
        [_marketArray addObjectsFromArray:statues];
        
        [_tableView reloadData];
    }  keywords_Id:nil category_Id:nil failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        
    }];

}
#pragma mark---加载全部数据
-(void)addloadStatus:(MJRefreshBaseView *)refreshView{
     [self addMBprogressView];
    if (_moreSelectedBtn.tag ==30) {
        [marketTOOL statusesWithSuccess:^(NSArray *statues) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            [_marketArray removeAllObjects];
            [_marketArray addObjectsFromArray:statues];
            
            [_tableView reloadData];
            [refreshView endRefreshing];
        }  keywords_Id:nil category_Id:_category_Index failure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        }];
    }else if (_moreSelectedBtn.tag==31){
        [marketTOOL statusesWithSuccess:^(NSArray *statues) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            [_marketArray removeAllObjects];

            [_marketArray addObjectsFromArray:statues];
            [_tableView reloadData];
            [refreshView endRefreshing];
            
        }  keywords_Id:nil category_Id:@"4" failure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            
        }];
    }else{
    [marketTOOL statusesWithSuccess:^(NSArray *statues) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        [_marketArray removeAllObjects];

        [_marketArray addObjectsFromArray:statues];
        [_tableView reloadData];
        [refreshView endRefreshing];
        
    }  keywords_Id:nil category_Id:nil failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        
    }];
    }
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
#pragma mark---分类
-(void)addMoreView{
    
    _moreView =[[UIView alloc]initWithFrame:CGRectMake(kWidth-100, 64, 100, _cagegoryArray.count*31)];
    _moreView.backgroundColor =[UIColor lightGrayColor];
    [self.view addSubview:_moreView];
    
    for (int i=0; i<_cagegoryArray.count; i++) {
        categoryLestModel *categoryModel =[_cagegoryArray objectAtIndex:i];

        UIButton *moreBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        moreBtn.frame =CGRectMake(1, i%6*31, 99, 30);
        moreBtn .backgroundColor =[UIColor whiteColor];
        moreBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentCenter;
        [moreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [moreBtn setTitle:categoryModel.categoryNmae forState:UIControlStateNormal];
        [_moreView addSubview:moreBtn];
        [moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        moreBtn.selected = _moreSelectedBtn.selected;
       
        moreBtn.tag = 30+i;
       

    }
    
    
    
}

-(void)addBigButton
{
   _bigButton =[UIButton buttonWithType:UIButtonTypeCustom];
    _bigButton.frame =CGRectMake(0, 0, kWidth, kHeight);
    _bigButton .backgroundColor =[UIColor whiteColor];
    [self.view addSubview:_bigButton];
    _bigButton.alpha = 0.1;
    
    [_bigButton addTarget:self action:@selector(bigButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark--分类加载数据
-(void)categoryBtnClick:(UIButton *)more{
    [categoryLestTool statusesWithSuccess:^(NSArray *statues) {
        [_cagegoryArray removeAllObjects];
        [_cagegoryArray addObjectsFromArray:statues];
        
        if (_moreSelectedBtn.selected ==YES) {
            [self addBigButton];
            [self addMoreView];
            
        }else{
            [_moreView removeFromSuperview];
            
            [_bigButton removeFromSuperview];
        }

    } entity_Type:@"1" failure:^(NSError *error) {
        
    }];
    
    _moreSelectedBtn.selected =!_moreSelectedBtn.selected;
    }
-(void)bigButtonClick:(UIButton *)big{
    _moreSelectedBtn.selected =!_moreSelectedBtn.selected;

    [_moreView removeFromSuperview];
    [_bigButton removeFromSuperview];
}
//下拉菜单
-(void)moreBtnClick:(UIButton *)mor{
    categoryLestModel *categoryModel =[_cagegoryArray objectAtIndex:mor.tag-30];
    _category_Index = categoryModel.typeID;
    _moreSelectedBtn.tag = mor.tag;
    _moreSelectedBtn.selected =!_moreSelectedBtn.selected;
    [_bigButton removeFromSuperview];
    [_moreView removeFromSuperview];
    
   
    
    
}
#pragma mark---TableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _marketArray.count   ;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    marketModel *markModel =[_marketArray objectAtIndex:indexPath.row];
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    markertDetailsView *productVC =[[markertDetailsView alloc]init];
    productVC.markIndex =markModel.typeID;
    [self.navigationController pushViewController:productVC animated:YES];
    
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndexfider =@"cell";
    marketCell *cell =[tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIndexfider];
    if (!cell) {
        cell=[[marketCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
        
        UIView *cellLine =[[UIView alloc]initWithFrame:CGRectMake(0, 79, kWidth, 1)];
        [cell.contentView addSubview:cellLine];
        cellLine.backgroundColor =HexRGB(0xe6e3e4);
    }
    marketModel *markModel =[_marketArray objectAtIndex:indexPath.row];
    [cell.marketImage setImageWithURL:[NSURL URLWithString:markModel.coverimage] placeholderImage:placeHoderImage];
    cell.timeLabel.text = markModel.create_time;
    cell.titleName.text=markModel.nametitle;
    cell.fromLabel.text = markModel.from;
    return cell;
}

@end
