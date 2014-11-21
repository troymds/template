//
//  LoginController.m
//  XinNet
//
//  Created by Tianj on 14/11/20.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "LoginController.h"
#import "ResetView.h"
#import "RegisterController.h"
#import "RemindView.h"
#import "GlobalInstance.h"

#define topDistance  20
#define leftDistance 10

#define autoBtn 1000
#define loseBtn 1001
#define loginBtn 2000
#define registerBtn 2001

@interface LoginController ()
{
    UITextField *_userNameField;
    UITextField *_secretField;
    
    UIButton *autoLonginBtn;
    UIButton *losePassword;
    UIButton *registerButton;
    UIButton *loginButton;
}
@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HexRGB(0xe9f1f6);
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.title = @"登陆";
    // Do any additional setup after loading the view.
    
    
    [self addView];
}


- (void)addView
{
    CGFloat y = topDistance;
    CGFloat height = 45;  //输入框高度
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(leftDistance,y,kWidth-leftDistance*2,height*2)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderColor = HexRGB(0xd5d5d5).CGColor;
    [self.view addSubview:bgView];
    
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,60, height)];
    userNameLabel.backgroundColor = [UIColor clearColor];
    userNameLabel.textColor = HexRGB(0x3a3a3a);
    userNameLabel.text = @"账号:";
    [bgView addSubview:userNameLabel];
    
    _userNameField = [[UITextField alloc] initWithFrame:CGRectMake(60,y,kWidth-leftDistance*2-60,height)];
    _userNameField.placeholder = @"请输入手机号/邮箱";
    _userNameField.layer.borderColor = HexRGB(0xd5d5d5).CGColor;
    _userNameField.layer.borderWidth = 1.0f;
    [bgView addSubview:_userNameField];
    
    y+=_userNameField.frame.size.height+10;
    _secretField = [[UITextField alloc] initWithFrame:CGRectMake(leftDistance,y, kWidth-leftDistance*2,35)];
    _secretField.layer.borderColor = HexRGB(0xd5d5d5).CGColor;
    _secretField.layer.borderWidth = 1.0f;
    _secretField.secureTextEntry = YES;
    _secretField.placeholder = @"请输入密码";
    [self.view addSubview:_secretField];
    
    y+=_secretField.frame.size.height+5;
    autoLonginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    autoLonginBtn.frame = CGRectMake(leftDistance,y,20,20);
    [autoLonginBtn setImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
    [autoLonginBtn setImage:[UIImage imageNamed:@"on"] forState:UIControlStateSelected];
    
    //判断用户是否设置了自动登录
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user objectForKey:@"autoLogin"]) {
        NSString *str = [user objectForKey:@"autoLogin"];
        if ([str isEqualToString:@"1"]) {
            autoLonginBtn.selected = YES;
        }
    }
    [autoLonginBtn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
    autoLonginBtn.tag = autoBtn;
    [self.view addSubview:autoLonginBtn];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(leftDistance+20+5,y, 100,20)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"自动登录";
    label.textColor = HexRGB(0x666666);
    [self.view addSubview:label];
 
    losePassword = [UIButton buttonWithType:UIButtonTypeCustom];
    losePassword.frame = CGRectMake(kWidth-leftDistance-80,y,80, 20);
    [losePassword setTitle:@"忘记密码" forState:UIControlStateNormal];
    [losePassword setTitleColor:HexRGB(0x666666) forState:UIControlStateNormal];
    losePassword.tag = loseBtn;
    [losePassword addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:losePassword];
    
    y+=losePassword.frame.size.height+20;
    
    CGFloat width = (kWidth-leftDistance*3)/2;
    registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.frame = CGRectMake(leftDistance,y, width,35);
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerButton setBackgroundImage:[UIImage imageNamed:@"finish.png"] forState:UIControlStateNormal];
    [registerButton setBackgroundImage:[UIImage imageNamed:@"finish_pre.png"] forState:UIControlStateHighlighted];

    registerButton.tag = registerBtn;
    [registerButton addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(leftDistance*2+width,y, width,35);
    [loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.tag = loginBtn;
    [loginButton setBackgroundImage:[UIImage imageNamed:@"finish.png"] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"finish_pre.png"] forState:UIControlStateHighlighted];
    [loginButton addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:loginButton];

}

- (void)btnDown:(UIButton *)btn
{
    switch (btn.tag) {
        case autoBtn:
        {
            btn.selected = !btn.selected;
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            if (btn.selected) {
                [user setObject:@"1" forKey:@"autoLogin"];  //1表示自动登录
            }else{
                [user setObject:@"0" forKey:@"autoLogin"];
            }

        }
            break;
        case loseBtn:
        {
            ResetView *reset = [[ResetView alloc] initWithTitle:@"重置密码"];
            [reset show];
        }
            break;
        case registerBtn:
        {
            RegisterController *rc = [[RegisterController alloc] init];
            [self.navigationController pushViewController:rc animated:YES];
        }
            break;
        case loginBtn:
        {
            [self login];
        }
            break;

        default:
            break;
    }
}

- (void)login
{
    if (_userNameField.text.length == 0) {
        [RemindView showViewWithTitle:@"请输入用户名" location:MIDDLE];
        return;
    }
    if (_secretField.text.length == 0) {
        [RemindView showViewWithTitle:@"请输入密码" location:MIDDLE];
        return;
    }
    //下面开始登录
    [GlobalInstance sharedInstance].isLogin = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_userNameField resignFirstResponder];
    [_secretField resignFirstResponder];
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
