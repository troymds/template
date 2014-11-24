//
//  marketController.m
//  NewView
//
//  Created by YY on 14-11-18.
//  Copyright (c) 2014年 ___普而摩___. All rights reserved.
//

#import "marketController.h"
#import "companyJOBController.h"
#import "markertDetailsView.h"
#import "marketCell.h"
#import "marketTOOL.h"
#import "marketModel.h"
#import "UIImageView+WebCache.h"
#import "categoryLestTool.h"
#import "categoryLestModel.h"
@interface marketController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    UIView *_moreView;
    UIButton *_bigButton;
    UIButton *_moreSelectedBtn;
    NSMutableArray *_marketArray;
    NSMutableArray *_cagegoryArray;
}
@end

@implementation marketController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"市场行情";
    self.view.backgroundColor =[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithSearch:@"more.png" highlightedSearch:@"more.png" target:(self) action:@selector(categoryBtnClick:)];
    _moreSelectedBtn =[[UIButton alloc]init];
    _marketArray =[[NSMutableArray alloc]init];
    _cagegoryArray=[[NSMutableArray alloc]init];

    
    [self addloadStatus];
}
-(void)addloadStatus{
    [marketTOOL statusesWithSuccess:^(NSArray *statues) {
        [_marketArray addObjectsFromArray:statues];
        [self addTableView];

    } lastID: (0)? 0:[NSString stringWithFormat:@"%lu",[_marketArray count]-0] failure:^(NSError *error) {
        
    }];}
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

-(void)addMoreView{
    
    _moreView =[[UIView alloc]initWithFrame:CGRectMake(kWidth-100, 64, 100, _cagegoryArray.count*31)];
    _moreView.backgroundColor =[UIColor lightGrayColor];
    [self.view addSubview:_moreView];
    
    for (int i=0; i<_cagegoryArray.count; i++) {
        categoryLestModel *categoryModel =[_cagegoryArray objectAtIndex:i];

        UIButton *moreBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        moreBtn.frame =CGRectMake(1, i%6*31, 99, 30);
        moreBtn .backgroundColor =[UIColor whiteColor];
        moreBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
        [moreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [moreBtn setTitle:categoryModel.categoryNmae forState:UIControlStateNormal];
        [_moreView addSubview:moreBtn];
//        [moreBtn setImage:[UIImage imageNamed:@"nav_code.png"] forState:UIControlStateNormal];
        [moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        moreBtn.selected = _moreSelectedBtn.selected;

    }
    
    
    
}

-(void)addBigButton
{
   _bigButton =[UIButton buttonWithType:UIButtonTypeCustom];
    _bigButton.frame =CGRectMake(0, 0, kWidth, kHeight);
    _bigButton .backgroundColor =[UIColor whiteColor];
    [self.view addSubview:_bigButton];
    _bigButton.alpha = 0.1;
    
    [_bigButton addTarget:self action:@selector(bigButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)categoryBtnClick:(UIButton *)more{
    [categoryLestTool statusesWithSuccess:^(NSArray *statues) {
        [_cagegoryArray removeAllObjects];
        [_cagegoryArray addObjectsFromArray:statues];
        NSLog(@"%lu",(unsigned long)_cagegoryArray.count);
        
        if (_moreSelectedBtn.selected ==YES) {
            [self addBigButton];
            [self addMoreView];
            
        }else{
            [_moreView removeFromSuperview];
            
            [_bigButton removeFromSuperview];
        }

    } entity_Type:@"1" failure:^(NSError *error) {
        
    }];
    
    _moreSelectedBtn.selected =!_moreSelectedBtn.selected;
    }
-(void)bigButtonClick:(UIButton *)big{
    _moreSelectedBtn.selected =!_moreSelectedBtn.selected;

    [_moreView removeFromSuperview];
    [_bigButton removeFromSuperview];
}
//下拉菜单
-(void)moreBtnClick:(UIButton *)mor{
    
    _moreSelectedBtn.selected =!_moreSelectedBtn.selected;
    [_bigButton removeFromSuperview];
    [_moreView removeFromSuperview];
    
}
#pragma mark---TableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _marketArray.count   ;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    marketModel *markModel =[_marketArray objectAtIndex:indexPath.row];
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    markertDetailsView *productVC =[[markertDetailsView alloc]init];
    productVC.markIndex =markModel.typeID;
    [self.navigationController pushViewController:productVC animated:YES];
    
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndexfider =@"cell";
    marketCell *cell =[tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIndexfider];
    if (!cell) {
        cell=[[marketCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndexfider];
        
        UIView *cellLine =[[UIView alloc]initWithFrame:CGRectMake(0, 79, kWidth, 1)];
        [cell.contentView addSubview:cellLine];
        cellLine.backgroundColor =HexRGB(0xe6e3e4);
    }
    marketModel *markModel =[_marketArray objectAtIndex:indexPath.row];
    [cell.marketImage setImageWithURL:[NSURL URLWithString:markModel.coverimage] placeholderImage:placeHoderImage];
    cell.timeLabel.text = markModel.create_time;
    cell.titleName.text=markModel.nametitle;
    cell.fromLabel.text = markModel.from;
    return cell;
}

@end
