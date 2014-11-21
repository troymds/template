//
//  MyMsgController.m
//  XinNet
//
//  Created by tianj on 14-11-20.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "MyMsgController.h"
#import "SystemMsgCell.h"
#import "SubscripMsgCell.h"
#import "SubscripMsgItem.h"
#import "SystemMsgItem.h"
#import "companyDetailsView.h"

#define systemType 2000
#define subscripType 2001
#define scrollvType  1999

@interface MyMsgController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIView *btnBgView;
    UIScrollView *_scrollView;
    UITableView *_systemTableView;
    UITableView *_subscribTableView;
    NSMutableArray *_systemArray;
    NSMutableArray *_subscripArray;
    
    BOOL firstLoad;  //订阅消息已经加载
    
    BOOL isSystem;  //判断是不是系统消息界面
}
@end

@implementation MyMsgController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HexRGB(0xffffff);
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout  = UIRectEdgeNone;
    }
    self.title = @"我的消息";
    _systemArray = [[NSMutableArray alloc] initWithCapacity:0];
    _subscripArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self addTopButton];
    [self addScrollView];
    //加载系统消息
    isSystem = YES;
    [self loadSystemData];
}

- (void)addTopButton
{
    CGFloat height = 35;
    btnBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,kWidth,height)];
    [self.view addSubview:btnBgView];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 34,kWidth,1)];
    line.backgroundColor = HexRGB(0xd5d5d5);
    [btnBgView addSubview:line];
    NSArray *array = [NSArray arrayWithObjects:@"系统消息",@"订阅消息", nil];
    for (int i = 0 ; i < array.count;i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((kWidth/2)*i, 0,kWidth/2,height);
        [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:HexRGB(0x808080) forState:UIControlStateNormal];
        [btn setTitleColor:HexRGB(0x18b0e7) forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(topBtnDown:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 2000+i;
        [btnBgView addSubview:btn];
        if ( i == 0) {
            btn.selected = YES;
        }
    }
}

- (void)addScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,35, kWidth,kHeight-35-64)];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.tag = scrollvType;
    [_scrollView setContentSize:CGSizeMake(kWidth*2,_scrollView.frame.size.height)];
    [self.view addSubview:_scrollView];
    
    _systemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,kWidth, _scrollView.frame.size.height)];
    _systemTableView.tag = systemType;
    _systemTableView.delegate = self;
    _systemTableView.dataSource = self;
    _systemTableView.separatorColor = [UIColor clearColor];
    _systemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:_systemTableView];
    
    _subscribTableView = [[UITableView alloc] initWithFrame:CGRectMake(kWidth, 0, kWidth,_scrollView.frame.size.height)];
    _subscribTableView.tag = subscripType;
    _subscribTableView.delegate = self;
    _subscribTableView.dataSource = self;
    _subscribTableView.separatorColor = [UIColor clearColor];
    _subscribTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:_subscribTableView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == scrollvType) {
        if (scrollView.contentOffset.x == 0) {
            
            isSystem = YES;
            
            for (UIView *subView in btnBgView.subviews) {
                if ([subView isKindOfClass:[UIButton class]]) {
                    UIButton *button = (UIButton *)subView;
                    if (button.tag == 2000) {
                        button.selected = YES;
                    }else{
                        button.selected = NO;
                    }
                }
            }
        }

        if (scrollView.contentOffset.x == kWidth) {
            
            isSystem = NO;
            
            for (UIView *subView in btnBgView.subviews) {
                if ([subView isKindOfClass:[UIButton class]]) {
                    UIButton *button = (UIButton *)subView;
                    if (button.tag == 2001) {
                        button.selected = YES;
                    }else{
                        button.selected = NO;
                    }
                }
            }
            if (!firstLoad) {
                firstLoad = YES;
                [self loadSubscripData];
            }
        }
    }
}


- (void)topBtnDown:(UIButton *)btn
{
    btn.selected = YES;
    for (UIView *subView in btnBgView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subView;
            if (button.tag!=btn.tag) {
                button.selected = NO;
            }
        }
    }
    [_scrollView setContentOffset:CGPointMake(kWidth*(btn.tag-2000),0) animated:YES];
    if (btn.tag == 2001) {
        isSystem = NO;
        if (!firstLoad) {
            firstLoad = YES;
            //如果不是第一次加载 则加载订阅数据
            [self loadSubscripData];
        }
    }else{
        isSystem = YES;
    }
}

- (void)loadSystemData
{
    for (int i =0 ; i < 10; i++) {
        SystemMsgItem *item = [[SystemMsgItem alloc] init];
        item.content = @"主要是关于app的消息通知，如版本更新，app打不开的说明道歉等 主要是关于app的消息通知，如版本更新，app打不开的说明道歉等";
        item.date = @"2014-11-20";
        [_systemArray addObject:item];
    }
    [_systemTableView reloadData];
}

- (void)loadSubscripData
{
    for (int i =0 ;i < 5; i++) {
        SubscripMsgItem *item = [[SubscripMsgItem alloc] init];
        item.imgStr = @"l";
        item.conpanyName = @"公司名称";
        [_subscripArray addObject:item];
    }
    [_subscribTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == systemType) {
        return _systemArray.count;
    }
    return _subscripArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == systemType) {
        static NSString *identify = @"identify";
        SystemMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[SystemMsgCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
        }
        SystemMsgItem *item = [_systemArray objectAtIndex:indexPath.row];
        [cell setObject:item];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString *cellName = @"cellName";
        SubscripMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (cell == nil) {
            cell = [[SubscripMsgCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
        }
        SubscripMsgItem *item = [_subscripArray objectAtIndex:indexPath.row];
        cell.nameLabel.text = item.conpanyName;
        cell.imageView.image = [UIImage imageNamed:item.imgStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == systemType) {
        return [self getCellHeight:indexPath];
    }
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == subscripType) {
        companyDetailsView *detail = [[companyDetailsView alloc] init];
        [self.navigationController pushViewController:detail animated:YES];
    }
}


- (CGFloat)getCellHeight:(NSIndexPath *)indexPath
{
    CGFloat height = 0 ;
    SystemMsgItem *item = [_systemArray objectAtIndex:indexPath.row];
    CGSize size = [AdaptationSize getSizeFromString:item.content Font:[UIFont systemFontOfSize:ContenFont] withHight:CGFLOAT_MAX withWidth:ContenWidht];
    height+=TopDistance+size.height+MiddleDistance+DateHeight+5;
    return height;
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
