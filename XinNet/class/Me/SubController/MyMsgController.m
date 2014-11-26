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
#import "httpTool.h"
#import "RemindView.h"


#define TopHeight 44   //顶部高度
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
    UIView *slideLine;   //滚动线条
    int _sysPage;   //系统消息页码
    int _subPage;
    BOOL isRefresh;   //刷新
    BOOL isLoad;        //加载
}
@end

@implementation MyMsgController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HexRGB(0xe9f1f6);
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
    _sysPage = 0;
    _subPage = 0;
    [self loadSystemData];
}

- (void)addTopButton
{
    btnBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,kWidth,TopHeight)];
    [self.view addSubview:btnBgView];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,TopHeight-1,kWidth,1)];
    line.backgroundColor = HexRGB(0xd5d5d5);
    [btnBgView addSubview:line];
    NSArray *array = [NSArray arrayWithObjects:@"系统消息",@"订阅消息", nil];
    for (int i = 0 ; i < array.count;i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((kWidth/2)*i, 0,kWidth/2,TopHeight);
        [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:HexRGB(0x3a3a3a) forState:UIControlStateNormal];
        [btn setTitleColor:HexRGB(0x38c166) forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(topBtnDown:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 2000+i;
        [btnBgView addSubview:btn];
        if ( i == 0) {
            btn.selected = YES;
        }
    }
    slideLine = [[UIView alloc] initWithFrame:CGRectMake(0,TopHeight-1,kWidth/2, 2)];
    slideLine.backgroundColor = HexRGB(0x38c166);
    [btnBgView addSubview:slideLine];
}

- (void)addScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,TopHeight, kWidth,kHeight-TopHeight-64)];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.tag = scrollvType;
    [_scrollView setContentSize:CGSizeMake(kWidth*2,_scrollView.frame.size.height)];
    [self.view addSubview:_scrollView];
    
    _systemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,kWidth, _scrollView.frame.size.height)];
    _systemTableView.tag = systemType;
    _systemTableView.backgroundColor = HexRGB(0xe9f1f6);
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
        [UIView animateWithDuration:0.01 animations:^{
            slideLine.frame = CGRectMake(scrollView.contentOffset.x/2,TopHeight-1,kWidth/2, 2);
        }];
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
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"10",@"pagesize", nil];
    if (isRefresh) {
        _sysPage = 0;
    }
    if (isLoad) {
        _sysPage++;
    }
    NSString *page = [NSString stringWithFormat:@"%d",_sysPage];
    [param setObject:page forKey:@"page"];
    [httpTool postWithPath:@"getSystemMessageList" params:param success:^(id JSON) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic = [result objectForKey:@"response"];
        
        int code = [[dic objectForKey:@"code"]intValue];
        if (code ==100) {
            NSArray *array = [dic objectForKey:@"data"];
            if (![array isKindOfClass:[NSNull class]]) {
                for (NSDictionary *subDic in array) {
                    SystemMsgItem *item = [[SystemMsgItem alloc] initWithDic:subDic];
                    [_systemArray addObject:item];
                }
            }
            [_systemTableView reloadData];
        }
    } failure:^(NSError *error) {
        [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
    }];
    
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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == systemType) {
        return [self getCellHeight:indexPath];
    }
    return 60;
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
    CGSize size = [AdaptationSize getSizeFromString:item.content Font:[UIFont systemFontOfSize:ContenFont] withHight:CGFLOAT_MAX withWidth:BgWidth-20];
    height+=TopDistance+size.height+bottomHeight+10+5;
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
