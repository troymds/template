//
//  SettingController.m
//  XinNet
//
//  Created by tianj on 14-11-19.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "SettingController.h"
#import "MoreListView.h"
#import "RemindView.h"

#define UpdateType 2000
#define ClearType 2001

@interface SettingController ()<MoreListViewDelegate>
{
    MoreListView *_updateView;
    MoreListView *_clearView;
}
@end

@implementation SettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.title = @"设置";
    // Do any additional setup after loading the view.
    [self addView];
}

- (void)addView
{
    CGFloat height = 40;      //列表高度
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth,height*2)];
    [self.view addSubview:bgView];
    for (int i = 0 ; i < 2; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,(i+1)*height-1,kWidth, 1)];
        line.backgroundColor = HexRGB(0xd5d5d5);
        [bgView addSubview:line];
    }
    
    _updateView = [[MoreListView alloc] initWithFrame:CGRectMake(0, 0, kWidth,height)];
    _updateView.titleLabel.text = @"检查更新";
    _updateView.delegate = self;
    _updateView.tag = UpdateType;
    [bgView addSubview:_updateView];
    
    _clearView = [[MoreListView alloc] initWithFrame:CGRectMake(0,height, kWidth,height)];
    _clearView.titleLabel.text = @"清除缓存";
    _clearView.delegate  = self;
    _clearView.tag = ClearType;
    [bgView addSubview:_clearView];
}

- (void)moreListViewClick:(MoreListView *)view
{
    switch (view.tag) {
        case UpdateType:
        {
            [self checkVersion];
        }
            break;
        case ClearType:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                               
                NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                NSLog(@"files :%lu",(unsigned long)[files count]);
                for (NSString *p in files) {
                    NSError *error;
                    NSString *path = [cachPath stringByAppendingPathComponent:p];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                    }
                }
                [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
            }
            );
            

        }
            break;
        default:
            break;
    }
}

//检查版本
- (void)checkVersion
{
    
}


//清除成功
- (void)clearCacheSuccess
{
    [RemindView showViewWithTitle:@"缓存已清空" location:MIDDLE];
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
