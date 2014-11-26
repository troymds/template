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

#import "marketTOOL.h"
#import "businessTool.h"
#import "companyJobTool.h"
#import "companyListTool.h"
#import "productTool.h"
#import "interfaceTool.h"

#import "marketModel.h"
#import "businessModel.h"
#import "companyJobModel.h"
#import "companyListModel.h"
#import "productModel.h"
#import "interfaceModel.h"

#import "markertDetailsView.h"
#import "businessDetailsView.h"
#import "companyDetailsView.h"
#import "productDetailsView.h"
#import "interfaceDetailsView.h"
#import "jobDetailsView.h"
@interface searchTableViewController ()
{
    NSMutableArray *_marketArray;
    NSMutableArray *_businessArray;
    NSMutableArray *_companyJobArray;
    NSMutableArray *_companyListArray;
    NSMutableArray *_productArray;
    NSMutableArray *_interfaceArray;
    UILabel *dataLabel;
}
@end

@implementation searchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _titleStr;
    self.view.backgroundColor =[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithSearch:@"nav_home_img.png" highlightedSearch:@"nav_home_img.png" target:(self) action:@selector(returnClick)];
    
    _marketArray =[NSMutableArray array];
    _businessArray =[NSMutableArray array];
    _companyJobArray =[NSMutableArray array];
    _companyListArray =[NSMutableArray array];
    _productArray =[NSMutableArray array];
    _interfaceArray =[NSMutableArray array];
    
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
        [marketTOOL statusesWithSuccess:^(NSArray *statues) {
            [_marketArray addObjectsFromArray: statues];
            [self.tableView reloadData];
            [self addShowNoDataView];

            if (_marketArray.count ==0) {
                dataLabel.hidden = NO;
                [self.tableView removeFromSuperview];
            }else{
                dataLabel.hidden = YES;
                self.tableView.hidden = NO;
            }
            
        } keywords_Id:_keyWordesIndex category_Id:nil failure:^(NSError *error) {
            
        }];
    }else if (_searchSelectedIndex ==201){
        [companyListTool statusesWithSuccess:^(NSArray *statues) {
            [_companyListArray addObjectsFromArray: statues];
            [self.tableView reloadData];
            [self addShowNoDataView];
            
            if (_companyListArray.count ==0) {
                dataLabel.hidden = NO;
                [self.tableView removeFromSuperview];
            }else{
                dataLabel.hidden = YES;
                self.tableView.hidden = NO;
            }

        } keywords_Id:_keyWordesIndex failure:^(NSError *error) {
        }];
    }
    else if (_searchSelectedIndex ==202){
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

        } keywords_Id:_keyWordesIndex type_ID:nil category_Id:nil failure:^(NSError *error) {
            
        }];
    }
    else if (_searchSelectedIndex ==203){
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

        } keywords_Id:_keyWordesIndex category_Id:nil failure:^(NSError *error) {
            
        }];
    }else if (_searchSelectedIndex ==204){
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
        
    }else{
        [interfaceTool statusesWithSuccess:^(NSArray *statues) {
            [_interfaceArray addObjectsFromArray: statues];
            [self.tableView reloadData];
            [self addShowNoDataView];
            
            if (_interfaceArray.count ==0) {
                dataLabel.hidden = NO;
                [self.tableView removeFromSuperview];
            }else{
                dataLabel.hidden = YES;
                self.tableView.hidden = NO;
            }

        } company_Id:nil keywords_Str:_keyWordesIndex category_Id:nil failure:^(NSError *error) {
            
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

        marketModel *markModel =[_marketArray objectAtIndex:indexPath.row];
        markertDetailsView *productVC =[[markertDetailsView alloc]init];
        productVC.markIndex =markModel.typeID;
        [self.navigationController pushViewController:productVC animated:YES];
 
        
    }else if (_searchSelectedIndex ==201) {
        companyDetailsView *productVC =[[companyDetailsView alloc]init];
        companyListModel *companyModel =[_companyListArray objectAtIndex:indexPath.row];
        productVC.companyDetailIndex =companyModel.type_id;
        [self.navigationController pushViewController:productVC animated:YES];

    }else if (_searchSelectedIndex ==202) {
        businessModel *buModel =[_businessArray objectAtIndex:indexPath.row];
        businessDetailsView *productVC =[[businessDetailsView alloc]init];
        productVC.businessDetailIndex = buModel.indexID;
        [self.navigationController pushViewController:productVC animated:YES];
    }else if (_searchSelectedIndex ==203) {
        productModel *prModel =[_productArray objectAtIndex:indexPath.row];
        productDetailsView *productVC =[[productDetailsView alloc]init];
        productVC.productIndex =prModel.indexID;
        [self.navigationController pushViewController:productVC animated:YES];

    }else if (_searchSelectedIndex ==204) {
        companyJobModel *jobModel =[_companyJobArray objectAtIndex:indexPath.row];
        jobDetailsView *jobVc =[[jobDetailsView alloc]init];
        jobVc.job_urlWeb = jobModel.job_url;
        jobVc.company_urlWeb = jobModel.company_url;
        [self.navigationController pushViewController:jobVc animated:YES];
    }else{
        interfaceModel *interModel =[_interfaceArray objectAtIndex:indexPath.row];
        interfaceDetailsView *productVC =[[interfaceDetailsView alloc]init];
        productVC.interface_Url=interModel.wapUrl;
        [self.navigationController pushViewController:productVC animated:YES];
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (_searchSelectedIndex ==200) {
        return _marketArray.count;

    }if (_searchSelectedIndex ==201) {
        return _companyListArray.count;
        
    }if (_searchSelectedIndex ==202) {
        return _businessArray.count;
        
    }if (_searchSelectedIndex ==203) {
        return _productArray.count;
        
    }if (_searchSelectedIndex ==204) {
        return _companyJobArray.count;
        
    }else{
        return _interfaceArray.count;
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
        static NSString *marketIndexfierCell =@"cell1";
        marketCell *maCell =[tableView dequeueReusableCellWithIdentifier:marketIndexfierCell] ;
        if (!maCell) {
            maCell =[[marketCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:marketIndexfierCell];
        }
        maCell.selectionStyle =UITableViewCellSelectionStyleNone;
        marketModel *markModel =[_marketArray objectAtIndex:indexPath.row];
        [maCell.marketImage setImageWithURL:[NSURL URLWithString:markModel.coverimage] placeholderImage:placeHoderImage];
        maCell.timeLabel.text = markModel.create_time;
        maCell.titleName.text=markModel.nametitle;
        maCell.fromLabel.text = markModel.from;
        UIView *cellLine =[[UIView alloc]initWithFrame:CGRectMake(0, 79, kWidth, 1)];
        [maCell.contentView addSubview:cellLine];
        cellLine.backgroundColor =HexRGB(0xe6e3e4);
        return maCell;
    }
    if (_searchSelectedIndex ==201) {
        static NSString *comIndexfierCell =@"cell2";
        companyYellowCell *comCell =[tableView dequeueReusableCellWithIdentifier:comIndexfierCell] ;
        if (!comCell) {
            comCell =[[companyYellowCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:comIndexfierCell];
        }
        comCell.selectionStyle =UITableViewCellSelectionStyleNone;
        companyListModel *comapnyModel =[_companyListArray objectAtIndex:indexPath.row];
        [comCell.logoImage setImageWithURL:[NSURL URLWithString:comapnyModel.logo] placeholderImage:placeHoderImage];
        comCell.nameLabel.text =comapnyModel.name;
        comCell.addressLabel.text =comapnyModel.address;
        UIView *cellLine =[[UIView alloc]initWithFrame:CGRectMake(0, 79, kWidth, 1)];
        [comCell.contentView addSubview:cellLine];
        cellLine.backgroundColor =HexRGB(0xe6e3e4);
        return comCell;
    }
    if (_searchSelectedIndex ==202) {
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
    }
    if (_searchSelectedIndex ==203) {
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
    if (_searchSelectedIndex ==204) {
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
    }else{
        static NSString *interIndexfierCell =@"cell6";
        interfaceCell *intCell =[tableView dequeueReusableCellWithIdentifier:interIndexfierCell] ;
        if (!intCell) {
            intCell =[[interfaceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:interIndexfierCell];
        }
        intCell.selectionStyle =UITableViewCellSelectionStyleNone;
        interfaceModel *interModel =[_interfaceArray objectAtIndex:indexPath.row];
        [intCell.interfaceImage setImageWithURL:[NSURL URLWithString:interModel.cover] placeholderImage:placeHoderImage];
        intCell.nameLabel.text =interModel.title;
        intCell.timeLabel.text =interModel.create_time;
        UIView *cellLine =[[UIView alloc]initWithFrame:CGRectMake(0, 79, kWidth, 1)];
        [intCell.contentView addSubview:cellLine];
        cellLine.backgroundColor =HexRGB(0xe6e3e4);
        return intCell;
    }
    return nil;
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
