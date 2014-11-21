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
@interface companyJOBController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@end

@implementation companyJOBController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    self.title = @ "企业招聘";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithSearch:@"nav_code.png" highlightedSearch:@"vav_code_pre.png" target:(self) action:@selector(collectClick:)];
    [self addTableView];
    
}
-(void)collectClick:(UIButton *)collect{
    
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
#pragma mark---TableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10   ;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    jobDetailsView *jobVc =[[jobDetailsView alloc]init];
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

        
        [cell.contentView addSubview:cellLine];
        cellLine.backgroundColor =HexRGB(0xe6e3e4);
    }
    return cell;
}



@end
