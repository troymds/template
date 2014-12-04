
#import "WBNavigationController.h"
#import "AppMacro.h"
#import "UIBarButtonItem+MJ.h"
@interface WBNavigationController ()

@end

@implementation WBNavigationController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.appearance方法返回一个导航栏的外观对象
    // 修改了这个外观对象，相当于修改了整个项目中的外观
    UINavigationBar *bar = [UINavigationBar appearance];
    
    // 2.设置导航栏的背景图片
    if (IsIos7) {
        [bar setBackgroundImage:[UIImage imageNamed:@"nav_bgimg.png"] forBarMetrics:UIBarMetricsDefault];

    }else{
        
        [bar setBackgroundImage:[UIImage imageNamed:@"nav_bgimg.png"] forBarMetrics:UIBarMetricsDefault];

    }
    // 3.设置导航栏文字的主题
    [bar setTitleTextAttributes:@{
      UITextAttributeTextColor : [UIColor blackColor],
      UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetZero] ,UITextAttributeFont:[UIFont systemFontOfSize:18]
     }];
    
    // 4.修改所有UIBarButtonItem的外观
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
    // 修改item的背景图片
    [barItem setBackgroundImage:[UIImage imageNamed:@"home_display_btn.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [barItem setBackgroundImage:[UIImage imageNamed:@"home_display_btn.png"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault] ;
    // 修改item上面的文字样式
    NSDictionary *dict = @{
                           UITextAttributeTextColor : [UIColor blackColor],
                           UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetZero]
                           };
    
    [barItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    [barItem setTitleTextAttributes:dict forState:UIControlStateHighlighted];
    
    // 5.设置状态栏样式
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
}
-(UIBarButtonItem *)createBackButton{
    return [UIBarButtonItem itemWithIcon:@"reture_right.png" highlightedIcon:@"reture_right@2x" target:self action:@selector(backItem)];

    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
     [super pushViewController:viewController animated:animated];
    
     if (viewController.navigationItem.leftBarButtonItem== nil && [self.viewControllers count] > 1) {
        
         viewController.navigationItem.leftBarButtonItem =[self createBackButton];
         
        }
    
    }

- (void)backItem
{
   
    [super popViewControllerAnimated:YES];
}
@end
