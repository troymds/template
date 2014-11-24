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
@interface businessController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    UIButton *_selectedBtn;
    UIView *companyBackView;
    UIView *_orangLin;
    
    UITableView *_allTableView;
    UITableView *_supplyTablView;
    UITableView *_demandTablView;
    
    NSMutableArray *_allBusinessArray;
    NSMutableArray *_supplyBusinessArray;
    NSMutableArray *_demandBusinessArray;


}
@property(nonatomic ,strong)UIScrollView *BigCompanyScrollView;

@end

@implementation businessController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    self.title = @"供求商机";
    
    _allBusinessArray =[NSMutableArray array];
    _demandBusinessArray =[NSMutableArray array];
    _supplyBusinessArray =[NSMutableArray array];

    
    
    _orangLin =[[UIView alloc]init];
    [self.view addSubview:_orangLin];
    _orangLin.frame =CGRectMake(0, 93, 107, 2);
    _orangLin.backgroundColor =HexRGB(0x38c166);
    [self addBigCompanyScrollView];

    [self addbusinessBtn];
    [self addLoadStatus];
}
#pragma mark ____加载数据
-(void)addLoadStatus{
    [businessTool statusesWithSuccess:^(NSArray *statues) {
        [_allBusinessArray addObjectsFromArray:statues];
        NSLog(@"%@",_allBusinessArray);
        [self addBusinessAllTableview];
    } page_Num:0 type_ID:0 failure:^(NSError *error) {
        
    }];
   }
#pragma mark背景scrollview
-(void)addBigCompanyScrollView
{
    _BigCompanyScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 96, kWidth, kHeight-32-62)];
    _BigCompanyScrollView.contentSize = CGSizeMake(kWidth*3, _BigCompanyScrollView.frame.size.height);
    _BigCompanyScrollView.showsHorizontalScrollIndicator = YES;
    _BigCompanyScrollView.showsVerticalScrollIndicator = YES;
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
    return 70;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _allBusinessArray.count  ;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    businessDetailsView *productVC =[[businessDetailsView alloc]init];
    [self.navigationController pushViewController:productVC animated:YES];
    
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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

    //    cell.textLabel.text = @"标题";
    cell.imageView.image = [UIImage imageNamed:@"business_img.png"];
    return cell;
}

-(void)addbusinessBtn{
    
    
    companyBackView =[[UIView alloc]initWithFrame:CGRectMake(0, 64, kWidth, 30)];
    [self.view addSubview:companyBackView];
    companyBackView.backgroundColor =HexRGB(0xf8f8f8);
    
    UIView *companyBackLine =[[UIView alloc]initWithFrame:CGRectMake(0, 29, kWidth, 1)];
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
        companyBtn.frame =CGRectMake(0+p%3*kWidth/3, 0, kWidth/3, 30);
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
   
    _selectedBtn.selected = NO;
    _selectedBtn = company;
    _selectedBtn.selected = YES;
    
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

    
}


@end
