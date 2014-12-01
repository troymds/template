//
//  interfaceController.m
//  NewView
//
//  Created by YY on 14-11-18.
//  Copyright (c) 2014年 ___普而摩___. All rights reserved.
//

#import "interfaceController.h"
#import "interfaceDetailsView.h"
#import "interfaceCell.h"
#import "interfaceModel.h"
#import "interfaceTool.h"
#import "categoryLestTool.h"
#import "categoryLestModel.h"
#define YYBORDERH 44
@interface interfaceController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    
    UIButton *_selectedBtn;
    UIView *companyBackView;
    UIView *_orangLin;
    
    UITableView *_allTableView;//展会1
    UITableView *_supplyTablView;//展会2
    UITableView *_demandTablView;//展会3
    NSMutableArray *_interfaceArray;
     NSMutableArray *_interfaceArray2;
     NSMutableArray *_interfaceArray3;
    NSMutableArray *_categoryArray;
    NSString *_categoryIndex;
    MJRefreshFooterView *_footer;
    BOOL isLoadMore;//判断是否加载更多
}
@property(nonatomic ,strong)UIScrollView *BigCompanyScrollView;
@property (nonatomic,assign) NSInteger pageNum;//页数
@property (nonatomic,strong) NSString *page;//页数


@end

@implementation interfaceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    self.title =@"展会信息";
   
    _interfaceArray =[NSMutableArray array];
    _interfaceArray2 =[NSMutableArray array];
    _interfaceArray3 =[NSMutableArray array];
    _categoryArray =[NSMutableArray array];
    _categoryIndex=[[NSString alloc]init];
    _pageNum = 0;
    self.page = [NSString stringWithFormat:@"%d",_pageNum];
    
    _orangLin =[[UIView alloc]init];
    [self.view addSubview:_orangLin];
    _orangLin.frame =CGRectMake(0, YYBORDERH+62, kWidth/3, 2);
    _orangLin.backgroundColor =HexRGB(0x38c166);

    [self addMBprogressView];
    [self addLoadcategoryStatus];
}

#pragma  mark ------显示指示器
-(void)addMBprogressView{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    //    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
}

#pragma mark 集成刷新控件
- (void)addRefreshViews
{
    // 1.上拉加载更多
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = _allTableView;
    footer.delegate = self;
    _footer = footer;
    isLoadMore = NO;
}

#pragma mark 刷新代理方法
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) {
        // 上拉加载更多
        [self addLoadStatus:refreshView];
    }
}

#pragma mark 加载更多
-(void)addLoadStatus:(MJRefreshBaseView *)refreshView{
    //更新page
    _pageNum++;
    self.page = [NSString stringWithFormat:@"%d",_pageNum];
    
    if (_selectedBtn.tag ==21) {
        
        [interfaceTool statusesWithSuccess:^(NSArray *statues) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (statues.count < 10) {
                isLoadMore = NO;
                _footer.hidden = YES;
            }else
            {
                isLoadMore = YES;
                _footer.hidden = NO;
            }
            [_interfaceArray2 addObjectsFromArray:statues];
            [self addloadTableView];
            [refreshView endRefreshing];
        } category_Id:_categoryIndex page:self.page failure:^(NSError *error) {
        
        }];
        
    }else if (_selectedBtn.tag==22){
        [interfaceTool statusesWithSuccess:^(NSArray *statues) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (statues.count < 10) {
                isLoadMore = NO;
                _footer.hidden = YES;
            }else
            {
                isLoadMore = YES;
                _footer.hidden = NO;
            }
            [_interfaceArray3 addObjectsFromArray:statues];
            [self addloadTableView];
            [refreshView endRefreshing];
        } category_Id:_categoryIndex page:self.page failure:^(NSError *error) {
            
        }];
    }else{
        [interfaceTool statusesWithSuccess:^(NSArray *statues) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (statues.count < 10) {
                isLoadMore = NO;
                _footer.hidden = YES;
            }else
            {
                isLoadMore = YES;
                _footer.hidden = NO;
            }
            [_interfaceArray addObjectsFromArray:statues];
            [self addloadTableView];
            [refreshView endRefreshing];
        } category_Id:_categoryIndex page:self.page failure:^(NSError *error) {
            
        }];
    }
}


#pragma mark---加载数据
-(void)addLoadStatus{
    _pageNum = 0;
//    if (!isLoadMore) {
//        isLoadMore = YES;
//        _footer.hidden = NO;
//    }
    self.page = [NSString stringWithFormat:@"%d",_pageNum];
    
    if (_selectedBtn.tag ==21) {
        [interfaceTool statusesWithSuccess:^(NSArray *statues) {
            // 判断是否需要显示加载更多
            if (statues.count < 10) {
                isLoadMore = NO;
                _footer.hidden = YES;
            }else
            {
                isLoadMore = YES;
                _footer.hidden = NO;
            }
            [_interfaceArray2 removeAllObjects];
            [_interfaceArray2 addObjectsFromArray:statues];
            _pageNum = _interfaceArray2.count % 10 + 1;
            [self addloadTableView];
        } category_Id:_categoryIndex page:self.page failure:^(NSError *error) {
            
        }];
    }else if (_selectedBtn.tag==22){
        [interfaceTool statusesWithSuccess:^(NSArray *statues) {
            // 判断是否需要显示加载更多
            if (statues.count < 10) {
                isLoadMore = NO;
                _footer.hidden = YES;
            }else
            {
                isLoadMore = YES;
                _footer.hidden = NO;
            }
            [_interfaceArray3 removeAllObjects];
            [_interfaceArray3 addObjectsFromArray:statues];
            _pageNum = _interfaceArray3.count % 10 + 1;
            [self addloadTableView];

        } category_Id:_categoryIndex page:self.page  failure:^(NSError *error) {
            
        }];
    }else{
    [interfaceTool statusesWithSuccess:^(NSArray *statues) {
        // 判断是否需要显示加载更多
        if (statues.count < 10) {
            isLoadMore = NO;
            _footer.hidden = YES;
        }else
        {
            isLoadMore = YES;
            _footer.hidden = NO;
        }
        [_interfaceArray removeAllObjects];

        [_interfaceArray addObjectsFromArray:statues];
        _pageNum = _interfaceArray.count % 10 + 1;
        [self addloadTableView];

    } category_Id:_categoryIndex page:self.page failure:^(NSError *error) {
        
    }];
    }
}
#pragma mark ____加载分类数据
-(void)addLoadcategoryStatus{
    
    [categoryLestTool statusesWithSuccess:^(NSArray *statues) {
        [_categoryArray removeAllObjects];
        [_categoryArray addObjectsFromArray:statues];
        [self addBigCompanyScrollView];
        [self addRefreshViews];
        [self addbusinessBtn];
        
    } entity_Type:@"7" failure:^(NSError *error) {
        
    }];
    
}
#pragma mark背景scrollview
-(void)addBigCompanyScrollView
{
    _BigCompanyScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, YYBORDERH+63, kWidth, kHeight-YYBORDERH-64)];
    _BigCompanyScrollView.contentSize = CGSizeMake(kWidth*3, _BigCompanyScrollView.frame.size.height);
    _BigCompanyScrollView.showsHorizontalScrollIndicator = NO;
    _BigCompanyScrollView.showsVerticalScrollIndicator = NO;
    _BigCompanyScrollView.pagingEnabled = YES;
    _BigCompanyScrollView.bounces = NO;
    _BigCompanyScrollView.tag = 9999;
    _BigCompanyScrollView.userInteractionEnabled = YES;
    _BigCompanyScrollView.backgroundColor =HexRGB(0xe6e3e4);
    
    _BigCompanyScrollView.delegate = self;
    [self.view addSubview:_BigCompanyScrollView];
    [self addBusinessAllTableview];
    [self addBusinessDemandTableview];
    [self addBusinessSuplyTableview];
    [self addRefreshViews];
}
#pragma mark 全部
-(void)addBusinessAllTableview
{
    _allTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-YYBORDERH-64) style:UITableViewStylePlain];
    _allTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_BigCompanyScrollView addSubview:_allTableView];
    _allTableView.backgroundColor =[UIColor whiteColor];
    _allTableView.delegate =self;
    _allTableView.dataSource = self;
    
    
    
}
#pragma mark 供应
-(void)addBusinessSuplyTableview
{
    _supplyTablView =[[UITableView alloc]initWithFrame:CGRectMake(kWidth, 0, kWidth, kHeight-YYBORDERH-64) style:UITableViewStylePlain];
    _supplyTablView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_BigCompanyScrollView addSubview:_supplyTablView];
    _supplyTablView.backgroundColor =[UIColor whiteColor];
    _supplyTablView.delegate =self;
    _supplyTablView.dataSource = self;
   
}
#pragma mark 求购
-(void)addBusinessDemandTableview
{
    _demandTablView =[[UITableView alloc]initWithFrame:CGRectMake(kWidth*2, 0, kWidth, kHeight-YYBORDERH-64) style:UITableViewStylePlain];
    _demandTablView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_BigCompanyScrollView addSubview:_demandTablView];
    _demandTablView.backgroundColor =[UIColor whiteColor];
    _demandTablView.delegate =self;
    _demandTablView.dataSource = self;
    
}
-(void)addloadTableView{
    switch (_selectedBtn.tag) {
        case 20:
            [_allTableView reloadData];
            break;
            
        case 21:
            [_supplyTablView reloadData];
            break;
            
        case 22:
            [_demandTablView reloadData];
            break;
            
        default:
            break;
    }
}
#pragma mark  ------scrollview_delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag ==9999) {
        if (scrollView.contentOffset.x <=0) {
            scrollView.contentOffset = CGPointMake(0, 0);
        }
        
        if (scrollView.contentOffset.x >= kWidth*2) {
            scrollView.contentOffset = CGPointMake(kWidth*2, 0);
        }
        [UIView animateWithDuration:0.01 animations:^{
            _orangLin.frame = CGRectMake(scrollView.contentOffset.x/3,YYBORDERH+62, kWidth/3, 2);
        }];
        
        if (scrollView.contentOffset.x==0) {
            _footer.scrollView = _allTableView;
            for (UIView *subView in companyBackView.subviews) {
                if ([subView isKindOfClass:[UIButton class]]) {
                    UIButton *btn =(UIButton *)subView;
                    if (btn.tag ==20) {
                        _selectedBtn=btn;
                        _selectedBtn.selected = YES;
                        //拿到当前选中按钮，重新请求数据
                        categoryLestModel *cateModel =[_categoryArray objectAtIndex:0];
                        _categoryIndex =cateModel.typeID;
                        [self addLoadStatus];
                        
                    }else{
                        btn.selected = NO;
                    }
                }
            }
            
        }else if(scrollView.contentOffset.x==kWidth){
            _footer.scrollView = _supplyTablView;
            for (UIView *subView in companyBackView.subviews) {
                if ([subView isKindOfClass:[UIButton class]]) {
                    UIButton *btn =(UIButton *)subView;
                    if (btn.tag ==21) {
                        _selectedBtn=btn;
                        _selectedBtn.selected=YES;
                        //拿到当前选中按钮，重新请求数据
                        categoryLestModel *cateModel =[_categoryArray objectAtIndex:1];
                        _categoryIndex =cateModel.typeID;
                        [self addLoadStatus];
                    }else{
                        btn.selected = NO;
                    }
                    
                }
            }
        }
        else if(scrollView.contentOffset.x==kWidth*2){
            _footer.scrollView = _demandTablView;
            for (UIView *subView in companyBackView.subviews) {
                if ([subView isKindOfClass:[UIButton class]]) {
                    UIButton *btn =(UIButton *)subView;
                    if (btn.tag ==22) {
                        _selectedBtn=btn;
                        _selectedBtn.selected=YES;
                        //拿到当前选中按钮，重新请求数据
                        categoryLestModel *cateModel =[_categoryArray objectAtIndex:2];
                        _categoryIndex =cateModel.typeID;
                        [self addLoadStatus];
                    }else{
                        btn.selected = NO;
                    }
                    
                }
            }
        }
        [self addLoadStatus];
        
    }
    
}
#pragma mark  -----TableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_selectedBtn.tag ==20) {
        return _interfaceArray.count  ;
        
    }else if(_selectedBtn.tag ==21){
        return _interfaceArray2.count;
    }else{
        return _interfaceArray3.count;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    interfaceModel *prModel = nil;
    if (_selectedBtn.tag ==20) {
        prModel = [_interfaceArray objectAtIndex:indexPath.row];
        
    }else if(_selectedBtn.tag ==21){
        prModel = [_interfaceArray2 objectAtIndex:indexPath.row];
    }else{
        prModel = [_interfaceArray3 objectAtIndex:indexPath.row];
    }
    
    interfaceDetailsView *productVC =[[interfaceDetailsView alloc]init];
    productVC.interface_Url=prModel.wapUrl;
    productVC.interfaceIndex =prModel.indexId;
    [self.navigationController pushViewController:productVC animated:YES];
    
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    if (_selectedBtn.tag==20) {
        static NSString *cellIndexfider =@"cell";
        interfaceCell *cell =[tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIndexfider];
        if (!cell) {
            cell=[[interfaceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
            cell.AccessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
            UIView *cellLine =[[UIView alloc]initWithFrame:CGRectMake(0, 79, kWidth, 1)];
            [cell.contentView addSubview:cellLine];
            cellLine.backgroundColor =HexRGB(0xe6e3e4);
        }
        interfaceModel *interModel =[_interfaceArray objectAtIndex:indexPath.row];
        [cell.interfaceImage setImageWithURL:[NSURL URLWithString:interModel.cover] placeholderImage:placeHoderImage2];
        cell.nameLabel.text =interModel.title;
        cell.timeLabel.text =interModel.create_time;
        return cell;
    }else if (_selectedBtn.tag==21)
    {
        static NSString *cellIndexfider =@"cell2";
        interfaceCell *cell =[tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIndexfider];
        if (!cell) {
            cell=[[interfaceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
            cell.AccessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
            UIView *cellLine =[[UIView alloc]initWithFrame:CGRectMake(0, 79, kWidth, 1)];
            [cell.contentView addSubview:cellLine];
            cellLine.backgroundColor =HexRGB(0xe6e3e4);
        }
        interfaceModel *interModel =[_interfaceArray2 objectAtIndex:indexPath.row];
        [cell.interfaceImage setImageWithURL:[NSURL URLWithString:interModel.cover] placeholderImage:placeHoderImage2];
        cell.nameLabel.text =interModel.title;
        cell.timeLabel.text =interModel.create_time;
        return cell;
    }else
    {
        static NSString *cellIndexfider =@"cell3";
        interfaceCell *cell =[tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIndexfider];
        if (!cell) {
            cell=[[interfaceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
            cell.AccessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
            UIView *cellLine =[[UIView alloc]initWithFrame:CGRectMake(0, 79, kWidth, 1)];
            [cell.contentView addSubview:cellLine];
            cellLine.backgroundColor =HexRGB(0xe6e3e4);
        }
        interfaceModel *interModel =[_interfaceArray3 objectAtIndex:indexPath.row];
        [cell.interfaceImage setImageWithURL:[NSURL URLWithString:interModel.cover] placeholderImage:placeHoderImage2];
        cell.nameLabel.text =interModel.title;
        cell.timeLabel.text =interModel.create_time;
        return cell;
    }
}

-(void)addbusinessBtn{
    
    
    companyBackView =[[UIView alloc]initWithFrame:CGRectMake(0, 62, kWidth, YYBORDERH)];
    [self.view addSubview:companyBackView];
    companyBackView.backgroundColor =HexRGB(0xe1e9e9);
    
    UIView *companyBackLine =[[UIView alloc]initWithFrame:CGRectMake(0, YYBORDERH-1, kWidth, 1)];
    companyBackLine.backgroundColor =[UIColor lightGrayColor];
    
    [companyBackView addSubview:companyBackLine];
    
    for (int p=0; p<3; p++)
    {
        categoryLestModel *cateModel =[_categoryArray objectAtIndex:p];
        
        UIButton *companyBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [companyBackView addSubview:companyBtn];
        
        [companyBtn setTitleColor:HexRGB(0x808080) forState:UIControlStateNormal];
        [companyBtn setTitleColor:HexRGB(0x38c166) forState:UIControlStateSelected];
        
        [companyBtn setBackgroundImage:[UIImage imageNamed:@"deleteBtn _selected.png"] forState:UIControlStateHighlighted];
        companyBtn.frame =CGRectMake(0+p%3*kWidth/3, 0, kWidth/3, YYBORDERH);
        companyBtn.titleLabel.font =[UIFont systemFontOfSize:PxFont(20)];
        [companyBtn setTitle:cateModel.categoryNmae forState:UIControlStateNormal];
        
        companyBtn.tag =20+p;
        
        if (companyBtn.tag ==20)
        {
            companyBtn.selected = YES;
            _selectedBtn = companyBtn;
            [self companyBtnClick:_selectedBtn];
        }
        [companyBtn addTarget:self action:@selector(companyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

-(void)companyBtnClick:(UIButton *)company
{
    categoryLestModel *cateModel =[_categoryArray objectAtIndex:company.tag-20];
    _categoryIndex = cateModel.typeID;

    _selectedBtn = company;
    
    if (company.tag == 20)
    {
         _footer.scrollView = _allTableView;
        [_BigCompanyScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if(company.tag ==21)
    {
         _footer.scrollView = _supplyTablView;
        [_BigCompanyScrollView setContentOffset:CGPointMake(kWidth, 0) animated:YES];
    }
    else if(company.tag ==22)
    {
         _footer.scrollView = _demandTablView;
        [_BigCompanyScrollView setContentOffset:CGPointMake(kWidth*2, 0) animated:YES];
    }
    [self addLoadStatus];
    
}



@end
