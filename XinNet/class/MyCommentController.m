//
//  MyCommentController.m
//  XinNet
//
//  Created by tianj on 14-11-20.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "MyCommentController.h"
#import "CommentCell.h"
#import "CommentItem.h"

@interface MyCommentController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}
@end

@implementation MyCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HexRGB(0xffffff);
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout  = UIRectEdgeNone;
    }
    // Do any additional setup after loading the view.
    
    self.title = @"我的评论";
    
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64) style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self loadData];
}

- (void)loadData
{
    for (int i =0 ; i < 5; i ++) {
        CommentItem *item = [[CommentItem alloc] init];
        item.title = @"2014上海食品展会";
        item.comment = @"这是一大段评论内容";
        [_dataArray addObject:item];
    }
    [_tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cellName";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    CommentItem *item = [_dataArray objectAtIndex:indexPath.row];
    [cell.titileBtn setTitle:item.title forState:UIControlStateNormal];
    cell.commentLabel.text = item.comment;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
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
