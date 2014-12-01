//
//  FindPasswordController.m
//  XinNet
//
//  Created by tianj on 14-11-27.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "FindPasswordController.h"
#import "TextListView.h"
#import "RemindView.h"
#import "AuthencateTool.h"
#import "httpTool.h"
#import "MBProgressHUD.h"

@interface FindPasswordController ()<UITextFieldDelegate>
{
    UITextField *_textField;
    TextListView *_userNameView;

}


@end

@implementation FindPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor =HexRGB(0xffffff);
    self.title = @"寻找密码";

    [self addView];
}

- (void)addView
{
    CGFloat topDistance = 20;
    CGFloat leftDistance =10;
    CGFloat height = 47;
    _userNameView = [[TextListView alloc] initWithFrame:CGRectMake(leftDistance,topDistance,kWidth-leftDistance*2,height)];
    [_userNameView setTitle:@"账号:"];
    _userNameView.textField.delegate = self;
    _userNameView.textField.placeholder = @"请输入您的邮箱";
    _userNameView.layer.masksToBounds = YES;
    _userNameView.layer.cornerRadius = 4.0f;
    [self.view addSubview:_userNameView];
    _userNameView.layer.borderColor = HexRGB(0xd5d5d5).CGColor;
    _userNameView.layer.borderWidth = 1.0f;
    
    UIButton *getBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getBtn.frame = CGRectMake(leftDistance,topDistance+height+20, kWidth-leftDistance*2, 35);
    [getBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [getBtn addTarget:self action:@selector(buttonDown) forControlEvents:UIControlEventTouchUpInside];
    [getBtn setBackgroundColor:HexRGB(0x9be4aa)];
//    [getBtn setBackgroundImage:[UIImage imageNamed:@"finish.png"] forState:UIControlStateNormal];
//    [getBtn setBackgroundImage:[UIImage imageNamed:@"finish_pre.png"] forState:UIControlStateHighlighted];
    [getBtn setTitleColor:HexRGB(0xffffff) forState:UIControlStateNormal];
    
    [self.view addSubview:getBtn];

}

- (void)buttonDown
{
    if (_userNameView.textField.text.length!=0) {
        if ([AuthencateTool isValidateEmail:_userNameView.textField.text]) {
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:_userNameView.textField.text,@"email", nil];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.dimBackground = NO;
            [httpTool postWithPath:@"sendChangePasswordEmail" params:param success:^(id JSON) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
                NSDictionary *dic = [result objectForKey:@"response"];
                if ([[dic objectForKey:@"code"] intValue]==100) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"找回密码" message:@"我们已发送修改密码的链接到您的注册邮箱中,请您注意查收" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                    alertView.delegate = self;
                    [alertView show];
                }
            } failure:^(NSError *error) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
            }];
        }else{
            [RemindView showViewWithTitle:@"邮箱格式不正确" location:MIDDLE];
        }
    }else{
        [RemindView showViewWithTitle:@"请输入您的邮箱" location:MIDDLE];
    }
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
