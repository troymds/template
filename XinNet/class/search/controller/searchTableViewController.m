//
//  searchTableViewController.m
//  XinNet
//
//  Created by YY on 14-11-26.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "searchTableViewController.h"
#import "marketCell.h"
#import "companyYellowCell.h"
#import "productCell.h"
#import "companyJobCell.h"
#import "interfaceCell.h"

#import "businessTool.h"
#import "companyJobTool.h"
#import "productTool.h"

#import "businessModel.h"
#import "companyJobModel.h"
#import "productModel.h"

#import "businessDetailsView.h"
#import "productDetailsView.h"
#import "jobDetailsView.h"
@interface searchTableViewController ()
{
    NSMutableArray *_businessArray;
    NSMutableArray *_companyJobArray;
    NSMutableArray *_productArray;
    UILabel *dataLabel;
}
@end

@implementation searchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _titleStr;
    self.view.backgroundColor =[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithSearch:@"nav_home_img.png" highlightedSearch:@"nav_home_img.png" target:(self) action:@selector(returnClick)];
    
    _businessArray =[NSMutableArray array];
    _companyJobArray =[NSMutableArray array];
    _productArray =[NSMutableArray array];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addLoadStatus];
   
}
- (void)addShowNoDataView
{
    dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    dataLabel.textAlignment = NSTextAlignmentCenter;
    dataLabel.backgroundColor = [UIColor clearColor];
    dataLabel.text = @"没有数据！";
    dataLabel.hidden = YES;
    dataLabel.enabled = NO;
    [self.view addSubview:dataLabel];
    
    
}
#pragma mark---加载数据
-(void)addLoadStatus{
    if (_searchSelectedIndex==200) {
        [productTool statusesWithSuccess:^(NSArray *statues) {
            [_productArray addObjectsFromArray: statues];
            [self.tableView reloadData];
            [self addShowNoDataView];
            
            if (_productArray.count ==0) {
                dataLabel.hidden = NO;
                [self.tableView removeFromSuperview];
            }else{
                dataLabel.hidden = YES;
                self.tableView.hidden = NO;
            }
            
        }company_Id:nil keywords_Id:_keyWordesIndex category_Id:nil failure:^(NSError *error) {
            
        }];
            }else if (_searchSelectedIndex ==201){
                [businessTool statusesWithSuccess:^(NSArray *statues) {
                    [_businessArray addObjectsFromArray: statues];
                    [self.tableView reloadData];
                    [self addShowNoDataView];
                    
                    if (_businessArray.count ==0) {
                        dataLabel.hidden = NO;
                        [self.tableView removeFromSuperview];
                    }else{
                        dataLabel.hidden = YES;
                        self.tableView.hidden = NO;
                    }
                    
                } keywords_Id:_keyWordesIndex type_ID:nil company_Id:nil failure:^(NSError *error) {
                    
                }];
   
        
    }else{
        [companyJobTool statusesWithSuccess:^(NSArray *statues) {
            [_companyJobArray addObjectsFromArray: statues];
            [self.tableView reloadData];
            [self addShowNoDataView];
            
            if (_companyJobArray.count ==0) {
                dataLabel.hidden = NO;
                [self.tableView removeFromSuperview];
            }else{
                dataLabel.hidden = YES;
                self.tableView.hidden = NO;
            }
            
        } company_Id:nil keywords_Str:_keyWordesIndex failure:^(NSError *error) {
            
        }];
    }
}
-(void)returnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{        [tableView deselectRowAtIndexPath:indexPath animated:YES ];

       if (_searchSelectedIndex ==200) {

           productModel *prModel =[_productArray objectAtIndex:indexPath.row];
           productDetailsView *productVC =[[productDetailsView alloc]init];
           productVC.productIndex =prModel.indexID;
           [self.navigationController pushViewController:productVC animated:YES];
 
        
    }else if (_searchSelectedIndex ==201) {
        businessModel *buModel =[_businessArray objectAtIndex:indexPath.row];
        businessDetailsView *productVC =[[businessDetailsView alloc]init];
        productVC.businessDetailIndex = buModel.indexID;
        [self.navigationController pushViewController:productVC animated:YES];

    }else{
        companyJobModel *jobModel =[_companyJobArray objectAtIndex:indexPath.row];
        jobDetailsView *jobVc =[[jobDetailsView alloc]init];
        jobVc.job_urlWeb = jobModel.job_url;
        jobVc.company_urlWeb = jobModel.company_url;
        [self.navigationController pushViewController:jobVc animated:YES];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (_searchSelectedIndex ==200) {
        return _productArray.count;

    }if (_searchSelectedIndex ==201) {
        return _businessArray.count;
        
    
    }else{
        return _companyJobArray.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_searchSelectedIndex==202) {
        return 70;
    }else{
        return 80;
    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    if (_searchSelectedIndex ==200) {
        static NSString *proIndexfierCell =@"cell4";
        productCell *proCell =[tableView dequeueReusableCellWithIdentifier:proIndexfierCell] ;
        if (!proCell) {
            proCell =[[productCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:proIndexfierCell];
        }
        proCell.selectionStyle =UITableViewCellSelectionStyleNone;
        
        productModel *proModel =[_productArray objectAtIndex:indexPath.row];
        [proCell.hearderImage setImageWithURL:[NSURL URLWithString:proModel.cover] placeholderImage:placeHoderImage];
        proCell.nameLabel.text= proModel.name;
        proCell.old_priceLabel.text =[NSString stringWithFormat:@"产品价格:                %@",proModel.old_price];
        proCell.priceLabel.text =[NSString stringWithFormat:@"%@元",proModel.price ];
        UIView *cellLine =[[UIView alloc]initWithFrame:CGRectMake(0, 79, kWidth, 1)];
        [proCell.contentView addSubview:cellLine];
        cellLine.backgroundColor =HexRGB(0xe6e3e4);
        return proCell;
           }
    if (_searchSelectedIndex ==201) {
        static NSString *cellIndexfierCell =@"cell3";
        UITableViewCell *Cell =[tableView dequeueReusableCellWithIdentifier:cellIndexfierCell] ;
        if (!Cell) {
            Cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfierCell];
        }
        Cell.selectionStyle =UITableViewCellSelectionStyleNone;
        businessModel *busineModel =[_businessArray objectAtIndex:indexPath.row];
        Cell.textLabel.text =busineModel.title;
        Cell.imageView.image = [UIImage imageNamed:@"business_img.png"];
        UIView *cellLine =[[UIView alloc]initWithFrame:CGRectMake(0, 69, kWidth, 1)];
        [Cell.contentView addSubview:cellLine];
        cellLine.backgroundColor =HexRGB(0xe6e3e4);
        return Cell;

        
    }else{
        static NSString *jobIndexfierCell =@"cell5";
        companyJobCell *jobCell =[tableView dequeueReusableCellWithIdentifier:jobIndexfierCell] ;
        if (!jobCell) {
            jobCell =[[companyJobCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:jobIndexfierCell];
        }
        jobCell.selectionStyle =UITableViewCellSelectionStyleNone;
        companyJobModel *jobModel =[_companyJobArray objectAtIndex:indexPath.row];
        jobCell.nameLabel.text =jobModel.title;
        jobCell.companyLabel.text =jobModel.company_name;
        jobCell.timeLael.text =jobModel.create_time;
        UIView *cellLine =[[UIView alloc]initWithFrame:CGRectMake(0, 79, kWidth, 1)];
        [jobCell.contentView addSubview:cellLine];
        cellLine.backgroundColor =HexRGB(0xe6e3e4);
        return jobCell;
    }
    return nil;
    
}



@end
