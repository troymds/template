//
//  NextRegisterController.m
//  XinNet
//
//  Created by Tianj on 14/11/20.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "NextRegisterController.h"
#import "RemindView.h"

@interface NextRegisterController ()
{
    UITextField *textField;
}
@end

@implementation NextRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HexRGB(0xffffff);
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.title = @"注册";

    // Do any additional setup after loading the view.
    [self addView];
}

- (void)addView
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,0,60,35)];
    titleLabel.backgroundColor = [UIColor clearColor];
    NSString *str;
    if (self.isEmail) {
        str = @"邮箱";
    }else{
        str = @"手机号";
    }
    titleLabel.text = str;
    [self.view addSubview:titleLabel];
    
    UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(80,0,kWidth-80,35)];
    userName.backgroundColor = [UIColor clearColor];
    userName.text = self.account;
    [self.view addSubview:userName];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,34,kWidth, 1)];
    line.backgroundColor = HexRGB(0xd5d5d5);
    [self.view addSubview:line];
    
    
    UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20,35,60,35)];
    titleLabel1.backgroundColor = [UIColor clearColor];
    titleLabel1.text = @"密码";
    [self.view addSubview:titleLabel1];

    //密码输入框
    textField = [[UITextField alloc] initWithFrame:CGRectMake(80, 35,kWidth-80,35)];
    textField.placeholder = @"请输入密码";
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:textField];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0,69,kWidth, 1)];
    line1.backgroundColor = HexRGB(0xd5d5d5);
    [self.view addSubview:line1];
    
    UILabel *remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,75, kWidth-20,15)];
    remindLabel.text = @"为了您的账户安全,请输入6-18位字母、数字的组合";
    remindLabel.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:remindLabel];
    
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finishBtn.frame = CGRectMake(10,120,kWidth-20,35);
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [finishBtn setBackgroundImage:[UIImage imageNamed:@"finish.png"] forState:UIControlStateNormal];
    [finishBtn setBackgroundImage:[UIImage imageNamed:@"finish_pre.png"] forState:UIControlStateHighlighted];
    [finishBtn addTarget:self action:@selector(btnDown) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishBtn];
}

- (void)btnDown
{
    if (textField.text.length==0) {
        [RemindView showViewWithTitle:@"请输入密码" location:MIDDLE];
    }else{
        NSLog(@"完成注册");
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [textField resignFirstResponder];
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
