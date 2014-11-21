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
@interface companyYellowController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
}
@end

@implementation companyYellowController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"企业黄页";
    self.view.backgroundColor =[UIColor whiteColor];
    [self addTableView];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10   ;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    companyDetailsView *productVC =[[companyDetailsView alloc]init];
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
    return cell;
}

@end
