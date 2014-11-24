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
@interface companyYellowController ()<UITableViewDelegate,UITableViewDataSource>
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
    [self addLoadStatus];
}
#pragma mark ----加载数据
-(void)addLoadStatus{
    [companyListTool CompanyStatusesWithSuccesscategory:^(NSArray *statues) {
        [_companyArray addObjectsFromArray:statues];
        [self addTableView];

    } Page:(0)? 0:[NSString stringWithFormat:@"%lu",[_companyArray count]-0] CompanyFailure:^(NSError *error) {
        
    } ];
}
-(void)addTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64) style:UITableViewStylePlain];
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
