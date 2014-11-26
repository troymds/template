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
#import "companyJobModel.h"
#import "companyJobTool.h"

@interface companyJOBController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    
    NSMutableArray *_companyJobArray;
}
@end

@implementation companyJOBController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    self.title = @ "企业招聘";
    _companyJobArray =[NSMutableArray array];
    
    
    [self addLoadStatus];
    
}
#pragma mark----加载数据
-(void)addLoadStatus{
    [companyJobTool statusesWithSuccess:^(NSArray *statues) {
        [_companyJobArray addObjectsFromArray:statues];
        [self addTableView];
    } company_Id:nil keywords_Str:nil failure:^(NSError *error) {
        
    }];
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
#pragma mark---TableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _companyJobArray.count   ;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    companyJobModel *jobModel =[_companyJobArray objectAtIndex:indexPath.row];
    

    jobDetailsView *jobVc =[[jobDetailsView alloc]init];
    jobVc.job_urlWeb = jobModel.job_url;
    jobVc.company_urlWeb = jobModel.company_url;
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
    companyJobModel *jobModel =[_companyJobArray objectAtIndex:indexPath.row];
    cell.nameLabel.text =jobModel.title;
    cell.companyLabel.text =jobModel.company_name;
    cell.timeLael.text =jobModel.create_time;
    
    return cell;
}



@end
