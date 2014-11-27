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
@interface interfaceController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    UIButton *_selectedBtn;
    UIView *companyBackView;
    UIView *_orangLin;
    
    UITableView *_allTableView;
    UITableView *_supplyTablView;
    UITableView *_demandTablView;
    NSMutableArray *_interfaceArray;
    
    NSMutableArray *_categoryArray;
    NSString *_categoryIndex;
    
}
@property(nonatomic ,strong)UIScrollView *BigCompanyScrollView;



@end

@implementation interfaceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    self.title =@"展会信息";
   
    _interfaceArray =[NSMutableArray array];
    _categoryArray =[NSMutableArray array];
    _categoryIndex=[[NSString alloc]init];

    _orangLin =[[UIView alloc]init];
    [self.view addSubview:_orangLin];
    _orangLin.frame =CGRectMake(0, 93, 107, 2);
    _orangLin.backgroundColor =HexRGB(0x38c166);

    [self addLoadStatus];
    [self addLoadcategoryStatus];
}

#pragma mark---加载数据
-(void)addLoadStatus{
    if (_selectedBtn.tag ==21) {
        [interfaceTool statusesWithSuccess:^(NSArray *statues) {
            [_interfaceArray removeAllObjects];
            [_interfaceArray addObjectsFromArray:statues];
            [self addBigCompanyScrollView];
            
            [self addloadTableView];
        } company_Id:nil keywords_Str:nil category_Id:_categoryIndex failure:^(NSError *error) {
            
        }];
    }else if (_selectedBtn.tag==22){
        [interfaceTool statusesWithSuccess:^(NSArray *statues) {
            [_interfaceArray removeAllObjects];

            [_interfaceArray addObjectsFromArray:statues];
            [self addBigCompanyScrollView];
            [self addloadTableView];

        } company_Id:nil keywords_Str:nil category_Id:_categoryIndex failure:^(NSError *error) {
            
        }];
    }else{
    [interfaceTool statusesWithSuccess:^(NSArray *statues) {
        [_interfaceArray removeAllObjects];

        [_interfaceArray addObjectsFromArray:statues];
        [self addBigCompanyScrollView];
        [self addloadTableView];

    } company_Id:nil keywords_Str:nil category_Id:_categoryIndex failure:^(NSError *error) {
        
    }];
    }
}
#pragma mark ____加载分类数据
-(void)addLoadcategoryStatus{
    
    [categoryLestTool statusesWithSuccess:^(NSArray *statues) {
        [_categoryArray removeAllObjects];
        [_categoryArray addObjectsFromArray:statues];
        [self addbusinessBtn];
    } entity_Type:@"7" failure:^(NSError *error) {
        
    }];
    
}
#pragma mark背景scrollview
-(void)addBigCompanyScrollView
{
    _BigCompanyScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 96, kWidth, kHeight-32-62)];
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
    _allTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-32-44) style:UITableViewStylePlain];
    _allTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_BigCompanyScrollView addSubview:_allTableView];
    _allTableView.backgroundColor =[UIColor whiteColor];
    _allTableView.delegate =self;
    _allTableView.dataSource = self;
    
    
    
}
#pragma mark 供应
-(void)addBusinessSuplyTableview
{
    _supplyTablView =[[UITableView alloc]initWithFrame:CGRectMake(kWidth, 0, kWidth, kHeight-32-44) style:UITableViewStylePlain];
    _supplyTablView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_BigCompanyScrollView addSubview:_supplyTablView];
    _supplyTablView.backgroundColor =[UIColor whiteColor];
    _supplyTablView.delegate =self;
    _supplyTablView.dataSource = self;
    
    
    
    
}
#pragma mark 求购
-(void)addBusinessDemandTableview
{
    _demandTablView =[[UITableView alloc]initWithFrame:CGRectMake(kWidth*2, 0, kWidth, kHeight-32-44) style:UITableViewStylePlain];
    _demandTablView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_BigCompanyScrollView addSubview:_demandTablView];
    _demandTablView.backgroundColor =[UIColor whiteColor];
    _demandTablView.delegate =self;
    _demandTablView.dataSource = self;
    
}
-(void)addloadTableView{
    [_demandTablView reloadData];
    [_supplyTablView reloadData];
    [_allTableView reloadData];
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
            _orangLin.frame = CGRectMake(scrollView.contentOffset.x/3,93, kWidth/3, 2);
        }];
        
        if (scrollView.contentOffset.x==0) {
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
 
        
    }
    
}
#pragma mark  -----TableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _interfaceArray.count  ;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    interfaceModel *interModel =[_interfaceArray objectAtIndex:indexPath.row];

    interfaceDetailsView *productVC =[[interfaceDetailsView alloc]init];
    productVC.interface_Url=interModel.wapUrl;
    [self.navigationController pushViewController:productVC animated:YES];
    
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    [cell.interfaceImage setImageWithURL:[NSURL URLWithString:interModel.cover] placeholderImage:placeHoderImage];
    cell.nameLabel.text =interModel.title;
    cell.timeLabel.text =interModel.create_time;
    return cell;
}

-(void)addbusinessBtn{
    
    
    companyBackView =[[UIView alloc]initWithFrame:CGRectMake(0, 64, kWidth, 30)];
    [self.view addSubview:companyBackView];
    companyBackView.backgroundColor =HexRGB(0xe1e9e9);
    
    UIView *companyBackLine =[[UIView alloc]initWithFrame:CGRectMake(0, 29, kWidth, 1)];
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
        companyBtn.frame =CGRectMake(0+p%3*kWidth/3, 0, kWidth/3, 30);
        companyBtn.titleLabel.font =[UIFont systemFontOfSize:PxFont(20)];
        [companyBtn setTitle:cateModel.categoryNmae forState:UIControlStateNormal];
        
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
    categoryLestModel *cateModel =[_categoryArray objectAtIndex:company.tag-20];
    _categoryIndex = cateModel.typeID;

    _selectedBtn = company;
    
    if (company.tag == 20)
    {
        [_BigCompanyScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if(company.tag ==21)
    {
        
        [_BigCompanyScrollView setContentOffset:CGPointMake(kWidth, 0) animated:YES];
    }
    else if(company.tag ==22)
    {
        [_BigCompanyScrollView setContentOffset:CGPointMake(kWidth*2, 0) animated:YES];
    }
    [self addLoadStatus];
    
}



@end
