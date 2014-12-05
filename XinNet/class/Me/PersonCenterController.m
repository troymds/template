//
//  PersonCenterController.m
//  XinNet
//
//  Created by tianj on 14-11-20.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "PersonCenterController.h"
#import "MoreListView.h"
#import "MyMsgController.h"
#import "MyCommentController.h"
#import "MyFavoriteController.h"
#import "MyDemandController.h"
#import "LoginController.h"
#import "SystemConfig.h"
#import "RemindView.h"
#import "SubscribController.h"
#import "personCenterCell.h"
#import "PersonalController.h"
#import "ModifySecretController.h"

@interface PersonCenterController ()<MoreListViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_titileArray;
    NSMutableArray *_imgArray;
}


@end

@implementation PersonCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HexRGB(0xededed);
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout  = UIRectEdgeNone;
    }
    // Do any additional setup after loading the view.
    self.title = @"个人中心";
    _titileArray = [[NSMutableArray alloc] initWithCapacity:0];
    _imgArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray *array1 = [NSArray arrayWithObjects:@"我的消息",@"我的评论",@"我的收藏",@"我的求购",nil];
    NSArray *array2 = [NSArray arrayWithObjects:@"个人资料",@"修改密码", nil];
    [_titileArray addObject:array1];
    [_titileArray addObject:array2];
    
    NSArray *arr1 = [NSArray arrayWithObjects:@"myMsg.png",@"myComment.png",@"myFavorite.png",@"myDemand.png", nil];
    NSArray *arr2 = [NSArray arrayWithObjects:@"personInfo.png",@"secret.png", nil];
    [_imgArray addObject:arr1];
    [_imgArray addObject:arr2];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,kWidth, kHeight-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = HexRGB(0xededed);
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_titileArray objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_titileArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    personCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[personCenterCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.titleLabel.text = [[_titileArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.imgView.image = [UIImage imageNamed:[[_imgArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,54,kWidth,1)];
        if (indexPath.row<_titileArray.count-1) {
            line.backgroundColor = HexRGB(0xd5d5d5);
        }else{
            line.backgroundColor = HexRGB(0xd4d4d4);
        }
        [cell.contentView addSubview:line];
    }else{
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 1)];
        if (indexPath.row == 0) {
            line.backgroundColor = HexRGB(0xd4d4d4);
        }else{
            line.backgroundColor = HexRGB(0xd5d5d5);
            UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 54, kWidth, 1)];
            line1.backgroundColor = HexRGB(0xd4d4d4);
            [cell.contentView addSubview:line1];
        }
        [cell.contentView addSubview:line];
    }
    return cell;
}



- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 10)];
        view.backgroundColor = HexRGB(0xededed);
        return view;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([SystemConfig sharedInstance].isUserLogin) {
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0:
                {
                    MyMsgController *msg = [[MyMsgController alloc] init];
                    [self.navigationController pushViewController:msg animated:YES];
                }
                    break;
                case 1:
                {
                    MyCommentController *comment = [[MyCommentController alloc] init];
                    [self.navigationController pushViewController:comment animated:YES];
                }
                    break;
                case 2:
                {
                    MyFavoriteController *favorite = [[MyFavoriteController alloc] init];
                    [self.navigationController pushViewController:favorite animated:YES];
                }
                    break;
                case 3:
                {
                    MyDemandController *demand = [[MyDemandController alloc] init];
                    [self.navigationController pushViewController:demand animated:YES];
                }
                    break;
                default:
                    break;
            }
        }else{
            if (indexPath.row == 0) {
                PersonalController *pc = [[PersonalController alloc] init];
                [self.navigationController pushViewController:pc animated:YES];
            }else{
                ModifySecretController *msc = [[ModifySecretController alloc] init];
                [self.navigationController pushViewController:msc animated:YES];
            }
        }
    }else{
        [RemindView showViewWithTitle:@"您还没有注册或登陆哦" location:MIDDLE];
        LoginController *login = [[LoginController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    }
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
