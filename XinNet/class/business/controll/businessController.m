//
//  businessController.m
//  NewView
//
//  Created by YY on 14-11-18.
//  Copyright (c) 2014年 ___普而摩___. All rights reserved.
//

#import "businessController.h"
#import "AppMacro.h"
#import "businessDetailsView.h"
#import "businessTool.h"
#import "businessModel.h"
#define YYBODERH 44
@interface businessController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    UIButton *_selectedBtn;
    UIView *companyBackView;
    UIView *_orangLin;
    UILabel *dataLabel;
    
    UITableView *_allTableView;
    UITableView *_supplyTablView;
    UITableView *_demandTablView;
    
    NSMutableArray *_allBusinessArray;
    NSMutableArray *_supplyBusinessArray;
    NSMutableArray *_demandBusinessArray;

    MJRefreshFooterView *_footer;
    BOOL isLoadMore;//判断是否加载更多
    
}
@property(nonatomic ,strong)UIScrollView *BigCompanyScrollView;
@property (nonatomic,assign) NSInteger pageNum;//页数
@property (nonatomic,strong) NSString *page;//页数
@end

@implementation businessController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    self.title = @"供求商机";
    
    _allBusinessArray =[NSMutableArray array];
    _demandBusinessArray =[NSMutableArray array];
    _supplyBusinessArray =[NSMutableArray array];

    _pageNum = 0;
    self.page = [NSString stringWithFormat:@"%d",_pageNum];
    
    _orangLin =[[UIView alloc]init];
    [self.view addSubview:_orangLin];
    _orangLin.frame =CGRectMake(0, 63+YYBODERH, kWidth/3, 2);
    _orangLin.backgroundColor =HexRGB(0x38c166);

    [self addBigCompanyScrollView];
    [self addMBprogressView];
    [self addRefreshViews];
    [self addbusinessBtn];
    [self addLoadStatus];
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

#pragma mark ____加载数据
-(void)addLoadStatus{
    _pageNum = 0;
    if (!isLoadMore) {
        isLoadMore = YES;
        _footer.hidden = NO;
    }

    self.page = [NSString stringWithFormat:@"%d",_pageNum];
    if (_selectedBtn.tag ==20) {

        [businessTool statusesWithSuccess:^(NSArray *statues) {
            if (statues.count ==0) {
                _supplyTablView .hidden = YES;
                dataLabel.hidden = NO;
                dataLabel.frame =CGRectMake(0, 0, kWidth, kHeight-64);
            }else{
                _supplyTablView .hidden = NO;
                dataLabel.hidden = YES;
            }

            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [_allBusinessArray removeAllObjects];
            [_allBusinessArray addObjectsFromArray:statues];
            _pageNum = _allBusinessArray.count % 10 + 1;
            [self addLoadTableView];
        } type_ID:@"" page:self.page failure:^(NSError *error) {
        }];
        
    }else if (_selectedBtn.tag==21){
        [businessTool statusesWithSuccess:^(NSArray *statues) {
            if (statues.count ==0) {
                _supplyTablView .hidden = YES;
                dataLabel.hidden = NO;
                dataLabel.frame =CGRectMake(kWidth, 0, kWidth, kHeight-64);
            }else{
                _supplyTablView .hidden = NO;
                dataLabel.hidden = YES;
            }
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [_supplyBusinessArray removeAllObjects];
            [_supplyBusinessArray addObjectsFromArray:statues];
            _pageNum = _supplyBusinessArray.count % 10 + 1;
            [self addLoadTableView];
        } type_ID:@"2" page:self.page  failure:^(NSError *error) {
        }];
    }
    else{
        [businessTool statusesWithSuccess:^(NSArray *statues) {
            if (statues.count ==0) {
                _supplyTablView .hidden = YES;
                dataLabel.hidden = NO;
                dataLabel.frame =CGRectMake(kWidth*2, 0, kWidth, kHeight-64);
            }else{
                _supplyTablView .hidden = NO;
                dataLabel.hidden = YES;
            }

            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [_demandBusinessArray removeAllObjects];
            [_demandBusinessArray addObjectsFromArray:statues];
            _pageNum = _demandBusinessArray.count % 10 + 1;
            [self addLoadTableView];
        } type_ID:@"1" page:self.page  failure:^(NSError *error) {
        }];
    }
}

#pragma mark 加载更多
-(void)addLoadStatus:(MJRefreshBaseView *)refreshView{
    //更新page
    _pageNum++;
    self.page = [NSString stringWithFormat:@"%d",_pageNum];
    
        if (_selectedBtn.tag ==20) {
            [businessTool statusesWithSuccess:^(NSArray *statues) {
                if (statues.count < 10) {
                    isLoadMore = NO;
                    _footer.hidden = YES;
                    [RemindView showViewWithTitle:@"数据加载完毕" location:MIDDLE];
                }else
                {
                    isLoadMore = YES;
                    _footer.hidden = NO;
                }
                [_allBusinessArray addObjectsFromArray:statues];
                [self addLoadTableView];
                [refreshView endRefreshing];
            } type_ID:@"" page:self.page  failure:^(NSError *error) {
            }];
        }else if (_selectedBtn.tag==21){
        [businessTool statusesWithSuccess:^(NSArray *statues) {
            if (statues.count < 10) {
                isLoadMore = NO;
                _footer.hidden = YES;
                [RemindView showViewWithTitle:@"数据加载完毕" location:MIDDLE];

            }else
            {
                isLoadMore = YES;
                _footer.hidden = NO;
            }
            [_supplyBusinessArray addObjectsFromArray:statues];
            [refreshView endRefreshing];
            [self addLoadTableView];
        } type_ID:@"2" page:self.page failure:^(NSError *error) {
        }];
    }
    else{
        [businessTool statusesWithSuccess:^(NSArray *statues) {
            if (statues.count < 10) {
                isLoadMore = NO;
                _footer.hidden = YES;
                [RemindView showViewWithTitle:@"数据加载完毕" location:MIDDLE];

            }else
            {
                isLoadMore = YES;
                _footer.hidden = NO;
            }
            [_demandBusinessArray addObjectsFromArray:statues];
            [refreshView endRefreshing];
            [self addLoadTableView];
        } type_ID:@"1" page:self.page  failure:^(NSError *error) {
        }];
    }
}

#pragma mark背景scrollview
-(void)addBigCompanyScrollView
{
    _BigCompanyScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, YYBODERH+66, kWidth, kHeight-YYBODERH-64)];
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
    
}

#pragma mark 全部
-(void)addBusinessAllTableview
{
    _allTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-YYBODERH-66) style:UITableViewStylePlain];
    _allTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_BigCompanyScrollView addSubview:_allTableView];
    _allTableView.backgroundColor =[UIColor whiteColor];
    _allTableView.delegate =self;
    _allTableView.dataSource = self;
}
#pragma mark 供应
-(void)addBusinessSuplyTableview
{
    _supplyTablView =[[UITableView alloc]initWithFrame:CGRectMake(kWidth, 0, kWidth, kHeight-YYBODERH-66) style:UITableViewStylePlain];
    _supplyTablView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_BigCompanyScrollView addSubview:_supplyTablView];
    _supplyTablView.backgroundColor =[UIColor whiteColor];
    _supplyTablView.hidden = YES;
    _supplyTablView.delegate =self;
    _supplyTablView.dataSource = self;
}

#pragma mark ---刷新表
-(void)addLoadTableView{
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

#pragma mark 求购
-(void)addBusinessDemandTableview
{
    _demandTablView =[[UITableView alloc]initWithFrame:CGRectMake(kWidth*2, 0, kWidth, kHeight-32-64) style:UITableViewStylePlain];
    _demandTablView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_BigCompanyScrollView addSubview:_demandTablView];
    _demandTablView.backgroundColor =[UIColor whiteColor];
    _demandTablView.delegate =self;
    _demandTablView.dataSource = self;
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
            _orangLin.frame = CGRectMake(scrollView.contentOffset.x/3,YYBODERH+63, kWidth/3, 2);
        }];
        

        if (scrollView.contentOffset.x==0) {
            
            _footer.scrollView = _allTableView;
            for (UIView *subView in companyBackView.subviews) {
                if ([subView isKindOfClass:[UIButton class]]) {
                UIButton *btn =(UIButton *)subView;
                if (btn.tag ==20) {
                    _selectedBtn=btn;
                    _selectedBtn.selected = YES;
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
    return 70;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_selectedBtn.tag ==20) {
        return _allBusinessArray.count  ;

    }else if(_selectedBtn.tag ==21){
        return _supplyBusinessArray.count;
    }else{
        return _demandBusinessArray.count;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    businessModel *buModel =[_allBusinessArray objectAtIndex:indexPath.row];
    businessDetailsView *productVC =[[businessDetailsView alloc]init];
    productVC.businessDetailIndex = buModel.indexID;
    [self.navigationController pushViewController:productVC animated:YES];
    
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (_selectedBtn.tag==20) {
        static NSString *cellIndexfider =@"cell";
        UITableViewCell *cell =[tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIndexfider];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
            cell.AccessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        UIView *cellLine =[[UIView alloc]initWithFrame:CGRectMake(0, 69, kWidth, 1)];
        [cell.contentView addSubview:cellLine];
        cellLine.backgroundColor =HexRGB(0xe6e3e4);
        businessModel *busineModel =[_allBusinessArray objectAtIndex:indexPath.row];
        cell.textLabel.text =busineModel.title;
        if ([busineModel.typeId isEqualToString:@"2"]) {
            cell.imageView.image = [UIImage imageNamed:@"business_imge.png"];

        }else{
            cell.imageView.image = [UIImage imageNamed:@"business_img.png"];

        }
       
        return cell;
    }else if (_selectedBtn.tag ==21){
        static NSString *cellIndexfider =@"cell1";
        UITableViewCell *cell =[tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIndexfider];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
            cell.AccessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        UIView *cellLine =[[UIView alloc]initWithFrame:CGRectMake(0, 69, kWidth, 1)];
        [cell.contentView addSubview:cellLine];
        cellLine.backgroundColor =HexRGB(0xe6e3e4);
        businessModel *busineModel =[_supplyBusinessArray objectAtIndex:indexPath.row];
        cell.textLabel.text =busineModel.title;
        cell.imageView.image = [UIImage imageNamed:@"business_imge.png"];
        return cell;

    }else{
        static NSString *cellIndexfider =@"cell2";
        UITableViewCell *cell =[tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIndexfider];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
            cell.AccessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        UIView *cellLine =[[UIView alloc]initWithFrame:CGRectMake(0, 69, kWidth, 1)];
        [cell.contentView addSubview:cellLine];
        cellLine.backgroundColor =HexRGB(0xe6e3e4);
        businessModel *busineModel =[_demandBusinessArray objectAtIndex:indexPath.row];
        cell.textLabel.text =busineModel.title;
        cell.imageView.image = [UIImage imageNamed:@"business_img.png"];
        return cell;

    }
    return nil;
}

-(void)addbusinessBtn{
    
    
    companyBackView =[[UIView alloc]initWithFrame:CGRectMake(0, 64, kWidth, YYBODERH)];
    [self.view addSubview:companyBackView];
    companyBackView.backgroundColor =HexRGB(0xf8f8f8);
    
    UIView *companyBackLine =[[UIView alloc]initWithFrame:CGRectMake(0, YYBODERH-1, kWidth, 1)];
    companyBackLine.backgroundColor =[UIColor lightGrayColor];

    [companyBackView addSubview:companyBackLine];
    
    for (int p=0; p<3; p++)
    {
        NSArray *companyArr =@[@"全部",@"供应",@"求购"];
        UIButton *companyBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [companyBackView addSubview:companyBtn];
        
        [companyBtn setTitleColor:HexRGB(0x808080) forState:UIControlStateNormal];
        [companyBtn setTitleColor:HexRGB(0x38c66) forState:UIControlStateSelected];
        
        [companyBtn setBackgroundImage:[UIImage imageNamed:@"deleteBtn _selected.png"] forState:UIControlStateHighlighted];
        companyBtn.frame =CGRectMake(0+p%3*kWidth/3, 0, kWidth/3, YYBODERH);
        companyBtn.titleLabel.font =[UIFont systemFontOfSize:PxFont(20)];
        [companyBtn setTitle:companyArr[p] forState:UIControlStateNormal];
        
        companyBtn.tag =20+p;
                        if (companyBtn.tag ==20)
        {
            companyBtn.selected = YES;
            _selectedBtn = companyBtn;
            
        }
        [companyBtn addTarget:self action:@selector(companyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)companyBtnClick:(UIButton *)company
{
    [self addMBprogressView];

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
