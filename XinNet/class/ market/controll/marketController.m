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
@interface marketController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    UIView *_moreView;
    UIButton *_bigButton;
    UIButton *_moreSelectedBtn;
    
}
@end

@implementation marketController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"市场行情";
    self.view.backgroundColor =[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithSearch:@"more.png" highlightedSearch:@"more.png" target:(self) action:@selector(moreClick:)];
    [self addTableView];
    
    _moreSelectedBtn =[[UIButton alloc]init];
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

-(void)addMoreView{
    _moreView =[[UIView alloc]initWithFrame:CGRectMake(kWidth-100, 64, 100, 186)];
    _moreView.backgroundColor =[UIColor lightGrayColor];
    [self.view addSubview:_moreView];
    
    for (int i=0; i<6; i++) {
        UIButton *moreBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        moreBtn.frame =CGRectMake(1, i%6*31, 99, 30);
        moreBtn .backgroundColor =[UIColor whiteColor];
        [moreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [moreBtn setTitle:@"  资第一" forState:UIControlStateNormal];
        [_moreView addSubview:moreBtn];
        [moreBtn setImage:[UIImage imageNamed:@"nav_code.png"] forState:UIControlStateNormal];
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
-(void)moreClick:(UIButton *)more{
    
    _moreSelectedBtn.selected =!_moreSelectedBtn.selected;
    if (_moreSelectedBtn.selected ==YES) {
        [self addBigButton];
        [self addMoreView];

    }else{
        [_moreView removeFromSuperview];

        [_bigButton removeFromSuperview];
    }
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
    //    MYNSLog(@"---%d---%d",mor.selected,_moreSelectedBtn.selected);
    
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
    
    markertDetailsView *productVC =[[markertDetailsView alloc]init];
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
    return cell;
}

@end
