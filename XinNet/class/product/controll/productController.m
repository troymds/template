//
//  productController.m
//  NewView
//
//  Created by YY on 14-11-18.
//  Copyright (c) 2014年 ___普而摩___. All rights reserved.
//

#import "productController.h"
#import "productDetailsView.h"
#import "productCell.h"
#import "productModel.h"
#import "productTool.h"
#import "categoryLestModel.h"
#import "categoryLestTool.h"
#define YYBORDERH 44
#define KNoMoreData @"没有更多数据"
@interface productController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    
    UIButton *_selectedBtn;
    UIView *companyBackView;
    UIView *_orangLin;
    
    UITableView *_allTableView;
    UITableView *_supplyTablView;
    UITableView *_demandTablView;
    
    NSMutableArray *_productArray;
    NSMutableArray *_productArray2;
    NSMutableArray *_productArray3;
    NSMutableArray *_categoryArray;
    NSString *_productNstrIndex;
    MJRefreshFooterView *_footer;
    BOOL isLoadMore;//判断是否加载更多
    UILabel *dataLabel;
}
@property(nonatomic ,strong)UIScrollView *BigCompanyScrollView;
@property (nonatomic,assign) NSInteger pageNum;//页数
@property (nonatomic,strong) NSString *page;//页数

@end

@implementation productController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"产品管理";
    self.view.backgroundColor =[UIColor whiteColor];
    
    
    _productArray =[[NSMutableArray alloc]init];
    _categoryArray =[NSMutableArray array];
    _productArray2 =[[NSMutableArray alloc]init];
    _productArray3 =[[NSMutableArray alloc]init];
    _productNstrIndex=[[NSString alloc]init];
    
    _pageNum = 0;
    self.page = [NSString stringWithFormat:@"%d",_pageNum];
    [self addMBprogressView];
    [self addBigCompanyScrollView];
//先拉取分类数据
    [self addLoadcategoryStatus];
   
}


- (void)addShowNoDataView
{
    dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    dataLabel.textAlignment = NSTextAlignmentCenter;
    dataLabel.backgroundColor = [UIColor clearColor];
    dataLabel.text = @"没有数据！";
    dataLabel.hidden = YES;
    dataLabel.enabled = NO;
    [_BigCompanyScrollView addSubview:dataLabel];
    
    
}
#pragma  mark ------显示指示器
-(void)addMBprogressView{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    
    
}

#pragma mark 集成刷新控件
- (void)addRefreshViews
{
    // 1.上拉加载更多
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = _allTableView;
    footer.delegate = self;
    _footer = footer;
    isLoadMore = YES;
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
        [productTool statusesWithSuccess:^(NSArray *statues,int code, NSString* message) {
            
            if (statues.count >0) {
                if (statues.count < 10) {
                    isLoadMore = NO;
                    _footer.hidden = YES;
                    [RemindView showViewWithTitle:KNoMoreData location:MIDDLE];
                }else
                {
                    isLoadMore = YES;
                    _footer.hidden = NO;
                }

                [_productArray2 addObjectsFromArray:statues];
            }else
            {
                [RemindView showViewWithTitle:message location:MIDDLE];
                isLoadMore = NO;
                _footer.hidden = YES;
            }

            [refreshView endRefreshing];
            [self addLodadTableView];
        } category_Id:_productNstrIndex page:self.page failure:^(NSError *error) {
            
        }];
    }else if (_selectedBtn.tag==22){
        [productTool statusesWithSuccess:^(NSArray *statues,int code, NSString* message) {
            if (statues.count >0) {
                if (statues.count < 10) {
                    isLoadMore = NO;
                    _footer.hidden = YES;
                    [RemindView showViewWithTitle:KNoMoreData location:MIDDLE];
                }else
                {
                    isLoadMore = YES;
                    _footer.hidden = NO;
                }

                [_productArray3 addObjectsFromArray:statues];
            }else
            {
                [RemindView showViewWithTitle:message location:MIDDLE];
                isLoadMore = NO;
                _footer.hidden = YES;
            }
            
            [refreshView endRefreshing];
            [self addLodadTableView];
            
        } category_Id:_productNstrIndex page:self.page failure:^(NSError *error) {
            
        }];
    }else{
        [productTool statusesWithSuccess:^(NSArray *statues,int code, NSString* message) {
            if (statues.count >0) {
                if (statues.count < 10) {
                    isLoadMore = NO;
                    _footer.hidden = YES;
                    [RemindView showViewWithTitle:KNoMoreData location:MIDDLE];
                }else
                {
                    isLoadMore = YES;
                    _footer.hidden = NO;
                }

                [_productArray addObjectsFromArray:statues];
            }else
            {
                [RemindView showViewWithTitle:message location:MIDDLE];
                isLoadMore = NO;
                _footer.hidden = YES;
            }
            
            [refreshView endRefreshing];
            [self addLodadTableView];
            
        } category_Id:_productNstrIndex page:self.page failure:^(NSError *error) {
            
        }];
    }
}

-(void)addremoveThreeArray;
{
    [_productArray removeAllObjects];
    [_productArray2 removeAllObjects];
    [_productArray3 removeAllObjects];

    
}
#pragma mark ----加载数据
-(void)addLoadStatus
{
    _pageNum = 0;

    self.page = [NSString stringWithFormat:@"%d",_pageNum];
        if (_selectedBtn.tag==21){
        [productTool statusesWithSuccess:^(NSArray *statues,int code, NSString* message) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            if (statues.count > 0) {//有数据
                isLoadMore = YES;
                _footer.hidden = NO;
                [_productArray2 removeAllObjects];
                [_productArray2 addObjectsFromArray:statues];
                _supplyTablView.hidden = NO;
                dataLabel.hidden =YES;
            }else
            {
                [RemindView showViewWithTitle:message location:MIDDLE];
                isLoadMore = NO;
                _footer.hidden = YES;
                _supplyTablView.hidden =YES;
                dataLabel.hidden =NO;
                
            }

            // 刷新表格数据
            [self addLodadTableView];

        } category_Id:_productNstrIndex page:self.page failure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            
        }];
    }else if(_selectedBtn.tag==22){
        [productTool statusesWithSuccess:^(NSArray *statues,int code, NSString* message) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            if (statues.count > 0) {//有数据
                isLoadMore = YES;
                _footer.hidden = NO;
                [_productArray3 removeAllObjects];
                [_productArray3 addObjectsFromArray:statues];
                _demandTablView.hidden = NO;
                dataLabel.hidden = YES;
            }else
            {
                [RemindView showViewWithTitle:message location:MIDDLE];
                isLoadMore = NO;
                _footer.hidden = YES;
                _demandTablView.hidden = YES;
                dataLabel.hidden = NO;
            }
            [self addLodadTableView];

        }category_Id:_productNstrIndex page:self.page failure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            
        }];
    }else if(_selectedBtn.tag==20){

    [productTool statusesWithSuccess:^(NSArray *statues,int code, NSString* message) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        if (statues.count > 0) {//有数据
            isLoadMore = YES;
            _footer.hidden = NO;
            [_productArray removeAllObjects];
            [_productArray addObjectsFromArray:statues];
            _allTableView.hidden = NO;
            dataLabel.hidden = YES;
        }else
        {
            [RemindView showViewWithTitle:message location:MIDDLE];
            isLoadMore = NO;
            _footer.hidden = YES;
            _allTableView.hidden = YES;
            dataLabel.hidden = NO;
        }
        [self addLodadTableView];

    }category_Id:_productNstrIndex page:self.page failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    }];
    }
}

#pragma mark背景scrollview
-(void)addBigCompanyScrollView
{
    _BigCompanyScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, YYBORDERH, kWidth, kHeight-YYBORDERH-64)];
    _BigCompanyScrollView.contentSize = CGSizeMake(kWidth*_categoryArray.count, _BigCompanyScrollView.frame.size.height);
    _BigCompanyScrollView.showsHorizontalScrollIndicator = NO;
    _BigCompanyScrollView.showsVerticalScrollIndicator = NO;
    _BigCompanyScrollView.pagingEnabled = YES;
    _BigCompanyScrollView.bounces = NO;
    _BigCompanyScrollView.tag = 9999;
    _BigCompanyScrollView.userInteractionEnabled = YES;
    _BigCompanyScrollView.backgroundColor =[UIColor whiteColor];
    
    _BigCompanyScrollView.delegate = self;
    [self.view addSubview:_BigCompanyScrollView];
    [self addShowNoDataView];
    [self addBusinessAllTableview];

    [self addBusinessDemandTableview];
    [self addBusinessSuplyTableview];
    
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
    _allTableView.hidden =NO;
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

#pragma mark--刷新表
-(void)addLodadTableView{
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
            _orangLin.frame = CGRectMake(scrollView.contentOffset.x/_categoryArray.count,YYBORDERH-1, kWidth/_categoryArray.count, 2);
        }];
        if (scrollView.contentOffset.x==0) {
            
            for (UIView *subView in companyBackView.subviews) {
                if ([subView isKindOfClass:[UIButton class]]) {
                    UIButton *btn =(UIButton *)subView;
                    if (btn.tag ==20) {
                        _selectedBtn=btn;
                        _selectedBtn.selected = YES;
                        _footer.scrollView = _allTableView;
                     //拿到当前选中按钮，重新请求数据
                        categoryLestModel *cateModel =[_categoryArray objectAtIndex:0];
                        _productNstrIndex =cateModel.typeID;
                        [self addLoadStatus];
                    }else{
                        btn.selected = NO;
                    }
                }

            }
        }else if(scrollView.contentOffset.x==kWidth){

            for (UIView *subView in companyBackView.subviews) {
                if ([subView isKindOfClass:[UIButton class]]) {
                    UIButton *btn =(UIButton *)subView;
                    if (btn.tag ==21) {
                        _selectedBtn=btn;
                        _selectedBtn.selected=YES;
                        _footer.scrollView = _supplyTablView;
                        categoryLestModel *cateModel =[_categoryArray objectAtIndex:1];
                        _productNstrIndex =cateModel.typeID;
                        [self addLoadStatus];
                    }else{
                        btn.selected = NO;
                    }
                }
            }
        }
        else if(scrollView.contentOffset.x==kWidth*2){

            for (UIView *subView in companyBackView.subviews) {
                if ([subView isKindOfClass:[UIButton class]]) {
                    UIButton *btn =(UIButton *)subView;
                    if (btn.tag ==22) {
                        _selectedBtn=btn;
                        _selectedBtn.selected=YES;
                        _footer.scrollView = _demandTablView;
                        categoryLestModel *cateModel =[_categoryArray objectAtIndex:2];
                        _productNstrIndex =cateModel.typeID;
                        [self addLoadStatus];
                    }else{
                        btn.selected = NO;
                    }
                }
            }
        }
    }
}

#pragma mark  -----TableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_selectedBtn.tag ==20) {

        return _productArray.count;
        
    }else if(_selectedBtn.tag ==21){

        return _productArray2.count;
    }else{

        return _productArray3.count;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    productModel *prModel = nil;
    if (_selectedBtn.tag ==20) {
        prModel = [_productArray objectAtIndex:indexPath.row];
        
    }else if(_selectedBtn.tag ==21){
        prModel = [_productArray2 objectAtIndex:indexPath.row];
    }else{
        prModel = [_productArray3 objectAtIndex:indexPath.row];
    }
    productDetailsView *productVC =[[productDetailsView alloc]init];
    productVC.productIndex =prModel.indexID;
    [self.navigationController pushViewController:productVC animated:YES];
    
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_selectedBtn.tag == 20) {
        static NSString *cellIndexfider =@"cell";
        productCell *cell =[tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIndexfider];
        if (!cell) {
            cell=[[productCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
           

        }
         cell.selectionStyle=UITableViewCellSelectionStyleNone;
        UIView *cellLine =[[UIView alloc]initWithFrame:CGRectMake(0, 79, kWidth, 1)];
        [cell.contentView addSubview:cellLine];
        cellLine.backgroundColor =HexRGB(0xe6e3e4);
        
        productModel *proModel =[_productArray objectAtIndex:indexPath.row];
        [cell.hearderImage setImageWithURL:[NSURL URLWithString:proModel.cover] placeholderImage:placeHoderImage2];
        cell.nameLabel.text= proModel.name;
        cell.companyLabel.text =[NSString stringWithFormat:@"所属公司:%@元",proModel.company_name];
        cell.old_priceLabel.text =[NSString stringWithFormat:@"%@元",proModel.old_price];
        cell.priceLabel.text =[NSString stringWithFormat:@"%@元",proModel.price ];
        CGFloat  OldWidth =[proModel.old_price sizeWithFont:[UIFont systemFontOfSize:PxFont(18)] constrainedToSize:CGSizeMake(80, 20)].width;
        cell.lineView.frame =CGRectMake(0, 10, OldWidth+15, 1);
        
        return cell;
    }else if (_selectedBtn.tag == 21){
        static NSString *cellIndexfider =@"cell2";
        productCell *cell =[tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIndexfider];
        if (!cell) {
            cell=[[productCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
        }
         cell.selectionStyle=UITableViewCellSelectionStyleNone;
        UIView *cellLine =[[UIView alloc]initWithFrame:CGRectMake(0, 79, kWidth, 1)];
        [cell.contentView addSubview:cellLine];
        cellLine.backgroundColor =HexRGB(0xe6e3e4);
        
        productModel *proModel =[_productArray2 objectAtIndex:indexPath.row];
        [cell.hearderImage setImageWithURL:[NSURL URLWithString:proModel.cover] placeholderImage:placeHoderImage2];
        cell.nameLabel.text= proModel.name;
        cell.companyLabel.text =proModel.name;
        cell.old_priceLabel.text =[NSString stringWithFormat:@"%@元",proModel.old_price];
        cell.priceLabel.text =[NSString stringWithFormat:@"%@元",proModel.price ];
        CGFloat  OldWidth =[proModel.old_price sizeWithFont:[UIFont systemFontOfSize:PxFont(18)] constrainedToSize:CGSizeMake(80, 20)].width;
        cell.lineView.frame =CGRectMake(0, 10, OldWidth+15, 1);
        
        return cell;
    }else if(_selectedBtn.tag == 22){
        static NSString *cellIndexfider =@"cell3";
        productCell *cell =[tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIndexfider];
        if (!cell) {
            cell=[[productCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
        }
         cell.selectionStyle=UITableViewCellSelectionStyleNone;
        UIView *cellLine =[[UIView alloc]initWithFrame:CGRectMake(0, 79, kWidth, 1)];            [_productArray removeAllObjects];

        [cell.contentView addSubview:cellLine];
        cellLine.backgroundColor =HexRGB(0xe6e3e4);
        
        productModel *proModel =[_productArray3 objectAtIndex:indexPath.row];
        [cell.hearderImage setImageWithURL:[NSURL URLWithString:proModel.cover] placeholderImage:placeHoderImage2];
        cell.nameLabel.text= proModel.name;
        CGFloat  OldWidth =[proModel.old_price sizeWithFont:[UIFont systemFontOfSize:PxFont(18)] constrainedToSize:CGSizeMake(80, 20)].width;
        cell.lineView.frame =CGRectMake(0, 10, OldWidth+15, 1);
        cell.companyLabel.text =proModel.name;
        cell.old_priceLabel.text =[NSString stringWithFormat:@"%@元",proModel.old_price];
        cell.priceLabel.text =[NSString stringWithFormat:@"%@元",proModel.price ];
        return cell;
    }
    return  nil;
}

-(void)addbusinessBtn{
    
    companyBackView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, YYBORDERH)];
    [self.view addSubview:companyBackView];
    companyBackView.backgroundColor =HexRGB(0xe1e9e9);
    
    UIView *companyBackLine =[[UIView alloc]initWithFrame:CGRectMake(0, YYBORDERH-1, kWidth, 1)];
    companyBackLine.backgroundColor =[UIColor lightGrayColor];
    
    [companyBackView addSubview:companyBackLine];
    
    _orangLin =[[UIView alloc]init];
    [companyBackView addSubview:_orangLin];
    
    _orangLin.frame =CGRectMake(0, YYBORDERH-1, kWidth/_categoryArray.count, 2);
    _orangLin.backgroundColor =HexRGB(0x38c166);

    
    for (int p=0; p<_categoryArray.count; p++)
    {
        categoryLestModel *cateModel =[_categoryArray objectAtIndex:p];
        UIButton *companyBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [companyBackView addSubview:companyBtn];
        
        [companyBtn setTitleColor:HexRGB(0x808080) forState:UIControlStateNormal];
        [companyBtn setTitleColor:HexRGB(0x38c166) forState:UIControlStateSelected];
        
        
        [companyBtn setBackgroundImage:[UIImage imageNamed:@"deleteBtn _selected.png"] forState:UIControlStateHighlighted];
        companyBtn.frame =CGRectMake(0+p%_categoryArray.count*kWidth/_categoryArray.count, 0, kWidth/_categoryArray.count, YYBORDERH);
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
        
        UIView *yyLine =[[UIView alloc]initWithFrame:CGRectMake(kWidth/_categoryArray.count+p%2*(kWidth/_categoryArray.count), 10, 1, 24)];
        [companyBackView addSubview:yyLine];
        yyLine.backgroundColor =[UIColor lightGrayColor];
        yyLine.alpha = 0.5;
    }
    
}
#pragma mark ____加载分类数据
-(void)addLoadcategoryStatus{
    [categoryLestTool statusesWithSuccess:^(NSArray *statues) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        if (statues.count>0) {
            [_categoryArray removeAllObjects];
            [_categoryArray addObjectsFromArray:statues];
            [self addBigCompanyScrollView];
            [self addRefreshViews];
            [self addbusinessBtn];
            _allTableView.hidden = NO;
            dataLabel.hidden =YES;
        }else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            _allTableView.hidden = YES;
            dataLabel.hidden =NO;
        }
        

    } entity_Type:@"4" failure:^(NSError *error) {
  
    }];
}
-(void)companyBtnClick:(UIButton *)company
{
    categoryLestModel *cateModel =[_categoryArray objectAtIndex:company.tag-20];
    _productNstrIndex =cateModel.typeID;

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
