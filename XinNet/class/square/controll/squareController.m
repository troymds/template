//
//  squareController.m
//  NewView
//
//  Created by YY on 14-11-18.
//  Copyright (c) 2014年 ___普而摩___. All rights reserved.
//

#import "squareController.h"
#import "SquareCell.h"
#import "SquareUserItem.h"
#import "PublishTopicController.h"
#import "SquareHeadView.h"
#import "PersonalController.h"

@interface squareController ()<UITableViewDataSource,UITableViewDelegate,TJImageViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}
@end

@implementation squareController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HexRGB(0xffffff);
    self.title = @"话题广场";
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self addRightNavButton];
    
    [self loadData];
    [self addHeadView];
}

//添加右导航按钮
- (void)addRightNavButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0,75, 25);
    [button setTitle:@"发布话题" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBarButtonDown) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

//右导航按钮点击
- (void)rightBarButtonDown
{
    PublishTopicController *ptc = [[PublishTopicController alloc] init];
    [self.navigationController pushViewController:ptc animated:YES];
}

//顶部图片
- (void)addHeadView
{
    SquareHeadView *headView = [[SquareHeadView alloc] initWithFrame:CGRectMake(0, 0, kWidth,154)];
    headView.iconImg.image = [UIImage imageNamed:@"l"];
    headView.iconImg.delegate = self;
    headView.nameLabel.text = @"我是雷某某";
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,headView.frame.size.height-1,kWidth,1)];
    line.backgroundColor = HexRGB(0xd5d5d5);
    [headView addSubview:line];
    _tableView.tableHeaderView = headView;
}


//个人头像点击
- (void)imageViewClick:(TJImageView *)view
{
    PersonalController *pc = [[PersonalController alloc] init];
    [self.navigationController pushViewController:pc animated:YES];
}


- (void)loadData
{
    SquareUserItem *item1 = [[SquareUserItem alloc] init];
    item1.userName = @"张三";
    item1.content =  @"岁月难得沉默,秋风厌倦漂泊,夕阳赖着不走挂在墙头舍不得我,昔日伊人耳边话已和潮声向东流,再回首往事也随枫叶一片片落,爱已走到尽头恨也放弃承诺,命运自认幽默想法太多由不得我,壮志凌云几分愁知己难逢几人留";
    item1.iconImg = @"xxxxx";
    item1.publishImg = @"";
    item1.date = @"2014-11-19";
    [_dataArray addObject:item1];
    
    SquareUserItem *item2 = [[SquareUserItem alloc] init];
    item2.userName = @"李四";
    item2.content =  @"一片春愁待酒浇,江上舟摇,楼上帘招；秋娘渡与泰娘桥,风又飘飘，雨又萧萧.何日归家洗客袍？银字笙调,心字香烧.流光容易把人抛,红了樱桃,绿了芭蕉.";
    item2.iconImg = @"xxxx";
    item2.publishImg = @"xxxxxx";
    item2.date = @"2014-11-19";
    [_dataArray addObject:item2];
    
    SquareUserItem *item3 = [[SquareUserItem alloc] init];
    item3.userName = @"王二";
    item3.content =  @"岁月难得沉默秋风厌倦漂泊，夕阳赖着不走挂在墙头舍不得我";
    item3.iconImg = @"";
    item3.publishImg = @"";
    item3.date = @"2014-11-19";
    [_dataArray addObject:item3];
    
    SquareUserItem *item4 = [[SquareUserItem alloc] init];
    item4.userName = @"麻子";
    item4.content =  @"岁月难得沉默秋风厌倦漂泊，夕阳赖着不走挂在墙头舍不得我";
    item4.iconImg = @"";
    item4.publishImg = @"xxxxxxx";
    item4.date = @"2014-11-19";
    [_dataArray addObject:item4];
    
    SquareUserItem *item5 = [[SquareUserItem alloc] init];
    item5.userName = @"我是鱼干";
    item5.content =  @"岁月难得沉默秋风厌倦漂泊，夕阳赖着不走挂在墙头舍不得我，昔日伊人耳边话已和潮声向东流，再回首往事也随枫叶一片片落，爱已走到尽头恨也放弃承诺，命运自认幽默想法太多由不得我，壮志凌云几分愁知己难逢几人留";
    item5.iconImg = @"";
    item5.publishImg = @"xxxxxxx";
    item5.date = @"2014-11-19";
    [_dataArray addObject:item5];
    
    [_tableView reloadData];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"identify";
    SquareCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[SquareCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
    }
    SquareUserItem *item = [_dataArray objectAtIndex:indexPath.row];
    [cell setObject:item];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getCellHeight:indexPath];
}

- (CGFloat)getCellHeight:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = 0;
    SquareUserItem *item = [_dataArray objectAtIndex:indexPath.row];
    cellHeight = TopSapce + UserNameHeight+MiddleSpace;
    CGSize size = [AdaptationSize getSizeFromString:item.content Font:[UIFont systemFontOfSize:ContentFont] withHight:CGFLOAT_MAX withWidth:ContentWidth];
    cellHeight += size.height;
    cellHeight += MiddleSpace;
    if (item.publishImg&&item.publishImg.length!=0) {
        cellHeight += PublishImgHeiht;
    }
    cellHeight += 15;
    return cellHeight;
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
