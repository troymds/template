//
//  LoginController.m
//  XinNet
//
//  Created by Tianj on 14/11/20.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "LoginController.h"
#import "RegisterController.h"
#import "RemindView.h"
#import "GlobalInstance.h"
#import "LoginController.h"
#import "SystemConfig.h"

#define topDistance  20
#define leftDistance 10

#define autoBtn 1000
#define loseBtn 1001
#define loginBtn 2000
#define registerBtn 2001
#define playBtn 2002

@interface LoginController ()
{
    UITextField *_userNameField;
    UITextField *_secretField;
    
    UIButton *autoLonginBtn;
    UIButton *losePassword;
    UIButton *registerButton;
    UIButton *loginButton;
    
    UIButton *playButton;//密码显示按钮
    
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
    CGFloat width = kWidth - leftDistance*2;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(leftDistance,y,width,height*2)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 5.0f;
    bgView.layer.borderColor = HexRGB(0xc3c3c3).CGColor;
    bgView.layer.borderWidth = 1.0f;
    [self.view addSubview:bgView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,height,width,1)];
    line.backgroundColor = HexRGB(0xc3c3c3);
    [bgView addSubview:line];
    
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0,55, height)];
    userNameLabel.backgroundColor = [UIColor clearColor];
    userNameLabel.textColor = HexRGB(0x3a3a3a);
    userNameLabel.text = @"账号 :";
    [bgView addSubview:userNameLabel];
    
    _userNameField = [[UITextField alloc] initWithFrame:CGRectMake(60,0,width-60,height)];
    _userNameField.placeholder = @"请输入邮箱地址";
    [bgView addSubview:_userNameField];
    
    
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,height,55, height)];
    passwordLabel.backgroundColor = [UIColor clearColor];
    passwordLabel.textColor = HexRGB(0x3a3a3a);
    passwordLabel.text = @"密码 :";
    [bgView addSubview:passwordLabel];
    
    _secretField = [[UITextField alloc] initWithFrame:CGRectMake(60,height,width-60-40,height)];
    _secretField.secureTextEntry = YES;
    _secretField.placeholder = @"请输入密码";
    [bgView addSubview:_secretField];
    
    
    playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [playButton setImage:[UIImage imageNamed:@"display.png"] forState:UIControlStateNormal];
    [playButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateSelected];
    playButton.frame = CGRectMake(width-5-30,height+(height-30)/2, 30, 30);
    [playButton addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
    playButton.tag = playBtn;
    [bgView addSubview:playButton];
    
    
    y+=bgView.frame.size.height+5;
    autoLonginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    autoLonginBtn.frame = CGRectMake(leftDistance,y,30,30);
    [autoLonginBtn setImage:[UIImage imageNamed:@"box.png"] forState:UIControlStateNormal];
    [autoLonginBtn setImage:[UIImage imageNamed:@"boxSelected.png"] forState:UIControlStateSelected];
    
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
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(leftDistance+30,y+5, 100,15)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12];
    label.text = @"自动登录";
    label.textColor = HexRGB(0x808080);
    [self.view addSubview:label];
    
    losePassword = [UIButton buttonWithType:UIButtonTypeCustom];
    losePassword.frame = CGRectMake(kWidth-leftDistance-80,y+5,80, 15);
    [losePassword setTitle:@"忘记密码" forState:UIControlStateNormal];
    losePassword.titleLabel.font = [UIFont systemFontOfSize:12];
    [losePassword setTitleColor:HexRGB(0x808080) forState:UIControlStateNormal];
    losePassword.tag = loseBtn;
    [losePassword addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:losePassword];
    
    y+=playButton.frame.size.height+20;
    
    CGFloat btnWidth = (kWidth-leftDistance*3)/2;
    CGFloat btnHeight = 40;
    registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.frame = CGRectMake(leftDistance,y, btnWidth,btnHeight);
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerButton setBackgroundImage:[UIImage imageNamed:@"finish.png"] forState:UIControlStateNormal];
    [registerButton setBackgroundImage:[UIImage imageNamed:@"finish_pre.png"] forState:UIControlStateHighlighted];
    
    registerButton.tag = registerBtn;
    [registerButton addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(leftDistance*2+btnWidth,y, btnWidth,btnHeight);
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
        case playBtn:
        {
            btn.selected = !btn.selected;
            if (btn.selected) {
                _secretField.secureTextEntry = NO;
            }else{
                _secretField.secureTextEntry = YES;
            }
        }
            break;
        default:
            break;
    }
}

- (void)login
{
    if (_userNameField.text.length == 0) {
        [RemindView showViewWithTitle:@"请输入邮箱地址" location:MIDDLE];
        return;
    }
    if (_secretField.text.length == 0) {
        [RemindView showViewWithTitle:@"请输入密码" location:MIDDLE];
        return;
    }
    //下面开始登录
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:_userNameField.text,@"email",_secretField.text,@"password", nil];
    [httpTool postWithPath:@"login" params:param success:^(id JSON) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",result);
        NSDictionary *dic = [result objectForKey:@"response"];
        int code = [[dic objectForKey:@"code"] intValue];
        if (code == 100) {
            [SystemConfig sharedInstance].isUserLogin = YES;
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSString *msg = [dic objectForKey:@"msg"];
            [RemindView showViewWithTitle:msg location:MIDDLE];
        }
    } failure:^(NSError *error) {
        [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
    }];
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
