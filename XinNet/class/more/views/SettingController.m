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
    UILabel *versionLabel;
    UILabel *cachesLabel;
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
    CGFloat height = 60;      //列表高度
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth,height*2)];
    [self.view addSubview:bgView];
    for (int i = 0 ; i < 2; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,(i+1)*height-1,kWidth, 1)];
        line.backgroundColor = HexRGB(0xd5d5d5);
        [bgView addSubview:line];
    }
    
    _updateView = [[MoreListView alloc] initWithFrame:CGRectMake(0, 0, kWidth,height)];
    _updateView.titleLabel.text = @"检查更新";
    _updateView.titleLabel.frame = CGRectMake(20,0,120,height);
    _updateView.imgView.hidden = YES;
    _updateView.delegate = self;
    _updateView.tag = UpdateType;
    //加右侧箭头
    UIImageView *img1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_sore.png"]];
    img1.frame = CGRectMake(0,0, 30, 30);
    img1.center = CGPointMake(kWidth-(30/2)-5,height/2);
    [_updateView addSubview:img1];
    
    [bgView addSubview:_updateView];
    versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth-40-100,0,100,_updateView.frame.size.height)];
    NSDictionary *dict = [NSBundle mainBundle].infoDictionary;
    versionLabel.textColor = HexRGB(0x3a3a3a);
    versionLabel.textAlignment = NSTextAlignmentRight;
    versionLabel.font = [UIFont systemFontOfSize:12];
    NSString *version = [dict objectForKey:(NSString *)kCFBundleVersionKey];
    versionLabel.text = [NSString stringWithFormat:@"当前版本:v%@",version];
    [_updateView addSubview:versionLabel];
    
    _clearView = [[MoreListView alloc] initWithFrame:CGRectMake(0,height, kWidth,height)];
    _clearView.titleLabel.text = @"清除缓存";
    _clearView.imgView.hidden = YES;
    _clearView.titleLabel.frame = CGRectMake(20,0,120,height);
    _clearView.delegate  = self;
    _clearView.tag = ClearType;
    [bgView addSubview:_clearView];
    
    //加右侧箭头
    UIImageView *img2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_sore.png"]];
    img2.frame = CGRectMake(0,0, 30, 30);
    img2.center = CGPointMake(kWidth-(30/2)-5,height/2);
    [_clearView addSubview:img2];
    
    
    cachesLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth-40-100,0,100,_updateView.frame.size.height)];
    cachesLabel.textColor = HexRGB(0x3a3a3a);
    cachesLabel.textAlignment = NSTextAlignmentRight;
    cachesLabel.font = [UIFont systemFontOfSize:12];
    [_clearView addSubview:cachesLabel];
    
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    CGFloat chcheSize = [self folderSizeAtPath:filePath];
    cachesLabel.text = [NSString stringWithFormat:@"%.2fM",chcheSize];
}

//遍历文件夹获得文件夹大小，返回多少M
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
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
                        [self performSelectorOnMainThread:@selector(changeUI) withObject:self waitUntilDone:NO];
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


- (void)changeUI
{
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    CGFloat chcheSize = [self folderSizeAtPath:filePath];
    cachesLabel.text = [NSString stringWithFormat:@"%.2fM",chcheSize];
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
