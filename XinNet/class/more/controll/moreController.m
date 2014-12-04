//
//  moreController.m
//  NewView
//
//  Created by YY on 14-11-18.
//  Copyright (c) 2014年 ___普而摩___. All rights reserved.
//

#import "moreController.h"
#import "MoreListView.h"
#import "SettingController.h"
#import "AdviceController.h"
#import "MoreContentCell.h"
#import "ShareView.h"

#define Set_Type 1000
#define Advice_Type 1001
#define Share_Type 1002

@interface moreController ()<MoreListViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    MoreListView *_setView;
    MoreListView *_adviceView;
    MoreListView *_shareView;
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}
@end

@implementation moreController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HexRGB(0xededed);
    self.title = @"更多内容";
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    _dataArray = [[NSMutableArray alloc] initWithObjects:@"设置",@"意见反馈",@"分享软件", nil];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth,kHeight-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = HexRGB(0xededed);
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    MoreContentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MoreContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.descLabel.text = [_dataArray objectAtIndex:indexPath.row];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,49,kWidth, 1)];
    line.backgroundColor = HexRGB(0xd5d5d5);
    [cell.contentView addSubview:line];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            SettingController *set = [[SettingController alloc] init];
            [self.navigationController pushViewController:set animated:YES];
        }
            break;
        case 1:
        {
            AdviceController *adc = [[AdviceController alloc] init];
            [self.navigationController pushViewController:adc animated:YES];
        }
            break;
        case 2:
        {
            [ShareView showViewWithTitle:@"新网" content:@"这是一段分享内容" description:@"这是一段描述信息" url:@"www.ebingoo.com" delegate:self];
        }
            break;
        default:
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
