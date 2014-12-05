//
//  CommentController.m
//  XinNet
//  评论页面
//  Created by promo on 14-11-25.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "CommentController.h"
#import "commentDataTool.h"
#import "commentModel.h"
#import "myCommentCell.h"
#import "RemindView.h"
#import "YYSearchButton.h"
#import "YYalertView.h"
#import "MBProgressHUD.h"
#import "commentPublished.h"
#import "morecell.h"
#import "AdaptationSize.h"
#import "SystemConfig.h"
#import "LoginController.h"
#import "UserItem.h"

#define RowH 80.0 // cell高度
#define commentBtnBackH 44 //下面评论按钮背景高度

@interface CommentController ()<UITableViewDataSource,UITableViewDelegate,YYalertViewDelegate,UITextFieldDelegate>
{
    BOOL isLoadMore;//是否需要加载更多
    BOOL isLoading; //是否正在加载
}

@property (nonatomic, strong) UITableView *table;// 评论table
@property (nonatomic, strong) NSMutableArray *dataList; //评论数据
@property (nonatomic, strong) NSString *lastId;  //列表页数
@end

@implementation CommentController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IsIos7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.title = @"评论详情";
    isLoading = NO;
    //背景颜色
    self.view.backgroundColor = HexRGB(0xe6e3e4);
    _dataList = [NSMutableArray array];
    isLoadMore = NO;
    //创建表
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, KAppH - commentBtnBackH -44) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:table];
    _table = table;
    //拉取数据
    [self loadCommentData];
    [self loadCommentBtn];
}

#pragma mark 添加评论按钮
- (void) loadCommentBtn
{
    UIView *commentBtnBackView = [[UIView alloc] initWithFrame:CGRectMake(0, KAppH - commentBtnBackH - 44, kWidth, commentBtnBackH)];
    [self.view addSubview:commentBtnBackView];
    commentBtnBackView.backgroundColor = HexRGB(0xe9f1f6);
    YYSearchButton *commentBtn =[YYSearchButton buttonWithType:UIButtonTypeCustom];
    [commentBtnBackView addSubview:commentBtn];
    commentBtn.frame = CGRectMake(40, 7, kWidth-80, commentBtnBackH - 14);
    commentBtn.contentHorizontalAlignment =UIControlContentVerticalAlignmentCenter;
    [commentBtn setTitle:@"  写评论" forState:UIControlStateNormal];
    [commentBtn setImage:[UIImage imageNamed:@"write.png"] forState:UIControlStateNormal];
    
    commentBtn.backgroundColor =[UIColor whiteColor];
    [commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    commentBtn.titleLabel.font =[UIFont systemFontOfSize:20];
    
    [commentBtn addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark 拉取数据
- (void) loadCommentData
{
    self.lastId = [NSString stringWithFormat:@"%d",0];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在获取评论数据...";
    isLoading = YES;
    [commentDataTool GetCommentDataWithSuccess:^(NSArray *data,int code, NSString* message) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        isLoading = NO;
        if (code == 100) {
            int count = data.count;
            if (count < 10) {
                isLoadMore = NO;
            }else
            {
                isLoadMore = YES;
            }
            if (count > 0) {
                [_dataList addObjectsFromArray:data];
                [_table reloadData];
            }else
            {
                [RemindView showViewWithTitle:@"暂无评论数据" location:MIDDLE];
            }
        }else
        {
            [RemindView showViewWithTitle:message location:MIDDLE];
        }
    } entityId:_entityID entityType:@"1" page:self.lastId withFailure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"commentCell";
    if (indexPath.row < _dataList.count) {
        myCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[myCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        //设置cell数据并刷新
        CGFloat cellH = [self getCellHeight:indexPath.row];
        cell.cellLine.frame  = CGRectMake(0, cellH, kWidth, 1);
        commentModel *comment = [_dataList objectAtIndex:indexPath.row];
        cell.data = comment;
        
        return cell;
    }else
    {
        //加载更多
        static NSString * moreId = @"morecell";
        morecell *cell = [tableView dequeueReusableCellWithIdentifier:moreId];
        if (cell == nil) {
            cell = [[morecell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:moreId];
        }
        [cell.indicator startAnimating];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _dataList.count) {
        
        return [self getCellHeight:indexPath.row];
    }else
    {
        if (isLoadMore) {
            return 40;
        }else
        {
            return 0;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return isLoadMore ? _dataList.count + 1: _dataList.count;
}

#pragma mark 计算cell的高度
- (CGFloat)getCellHeight:(NSInteger)index
{
    commentModel *comment = [_dataList objectAtIndex:index];
    CGSize size = [AdaptationSize getSizeFromString:comment.content Font:[UIFont systemFontOfSize:detailFontSize] withHight:CGFLOAT_MAX withWidth:KdetailW];
    CGFloat h = userNameY + useNameH + size.height + bottomSpace;
    return h;
}

#pragma mark 点击评论
- (void)commentBtnClick
{
    YYalertView *aleartView =[[YYalertView alloc]init];
    aleartView.delegate = self;
    [aleartView showView ];
}

#pragma mark 点击评论view的遮罩
- (void) tapDown
{
    NSLog(@"点击评论view的遮罩");
}

#pragma mark 点击评论的确定/取消按钮
- (void)btnDown:(UIButton *)btn conent:(NSString *)content
{
    if (btn.tag == comformType) {// 发布评论
        if ([SystemConfig sharedInstance].isUserLogin) {//已经登录
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"正在发表评论...";
            
            [commentPublished publishCommentWithSuccess:^(NSArray *data, int code, NSString *msg) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [RemindView showViewWithTitle:msg location:MIDDLE];
                //刷新评论数据
                // 拿到用户名，头像，发表评论时间，内容
                if ([SystemConfig sharedInstance].userItem) {
                    UserItem *item = [SystemConfig sharedInstance].userItem;
                    commentModel *publishData = [[commentModel alloc] init];
                    publishData.uid = item.uid;
                    publishData.userAvata = item.avatar;
                    publishData.userName = item.user_name;
                    publishData.content = content;
                    //实例化一个NSDateFormatter对象
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
                    publishData.createTime = currentDateStr;
                // 插入到数组最前面
                    [_dataList insertObject:publishData atIndex:0];
                    [_table reloadData];
               //滚动到第一行
                    NSIndexPath * index = [NSIndexPath indexPathForRow:0 inSection:0];
                    [_table scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
                
            } entityID:_entityID entityType:@"1" content:content failure:^(NSError *error) {
                [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
            }];
        }else
        {
            [RemindView showViewWithTitle:@"您还没有注册或登陆哦" location:MIDDLE];
            LoginController *login = [[LoginController alloc] init];
            [self.navigationController pushViewController:login animated:YES];
        }
    }
}

#pragma mark 加载更多评论数据
- (void) loadMoreCommentData
{
    self.lastId = [NSString stringWithFormat:@"%d",[self.lastId intValue] + 1];
    isLoading = YES;
    [commentDataTool GetCommentDataWithSuccess:^(NSArray *data, int code, NSString *msg) {
        isLoading = NO;
        if (code == 100) {
            if (data.count > 0) {
                [_dataList addObjectsFromArray:data];
                if (data.count < 10) {
                    isLoadMore = NO;
                }else
                {
                    isLoadMore = YES;
                }
            }else
            {
                isLoadMore = NO;
                [RemindView showViewWithTitle:@"数据加载完毕" location:MIDDLE];
            }
        }else
        {
            isLoadMore = NO;
        }
        [_table reloadData];
    } entityId:_entityID entityType:@"1" page:self.lastId withFailure:^(NSError *error) {
        [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
    }];
}

#pragma mark  准备加载更多
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //判断加载更多条件
    if ([scrollView isKindOfClass:[UITableView class]]) {
        //当滚动到morecell时，加载更多
        NSInteger moreIndex = [_table numberOfRowsInSection:0] - 1;
        NSIndexPath * indexpath = [NSIndexPath indexPathForRow:moreIndex inSection:0];
        if ([[_table cellForRowAtIndexPath:indexpath] isKindOfClass:[morecell class]]) {
            if (scrollView.contentSize.height-scrollView.contentOffset.y<=scrollView.frame.size.height) {
                if (!isLoading) {
                    [self loadMoreCommentData];
                }
            }
        }
    }
}

@end
