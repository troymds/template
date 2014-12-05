//
//  ModifySecretController.m
//  XinNet
//
//  Created by tianj on 14-12-3.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "ModifySecretController.h"
#import "TextListView.h"
#import "httpTool.h"
#import "RemindView.h"

@interface ModifySecretController ()<UITextFieldDelegate>
{
    TextListView *_originField;
    TextListView *_newField;
    TextListView *_repeatField;
}
@end

@implementation ModifySecretController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor =HexRGB(0xededed);
    self.title = @"修改密码";
    
    [self addView];
}

- (void)addView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(11, 10, kWidth-11*2,44*3)];
    [self.view addSubview:bgView];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderColor = HexRGB(0xc3c3c3).CGColor;
    bgView.layer.borderWidth = 1.0f;
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 4.0f;
    
    for (int i = 1; i < 3; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 44*i,kWidth-11*2,1)];
        line.backgroundColor = HexRGB(0xc3c3c3);
        [bgView addSubview:line];
    }
    
    
    _originField = [[TextListView alloc] initWithFrame:CGRectMake(0,44*0, kWidth-11*2, 44)];
    [_originField setTitle:@"原密码:"];
    _originField.textField.delegate = self;
    _originField.textField.secureTextEntry = YES;
    _originField.textField.placeholder = @"请输入您的初始密码";
    [bgView addSubview:_originField];
    
    _newField = [[TextListView alloc] initWithFrame:CGRectMake(0,44*1, kWidth-11*2, 44)];
    [_newField setTitle:@"新密码:"];
    _newField.textField.delegate = self;
    _newField.textField.secureTextEntry = YES;
    _newField.textField.placeholder = @"6-20为字母、数字结合";
    [bgView addSubview:_newField];

    _repeatField = [[TextListView alloc] initWithFrame:CGRectMake(0,44*2, kWidth-11*2, 44)];
    [_repeatField setTitle:@"重复密码:"];
    _repeatField.textField.delegate = self;
    _repeatField.textField.secureTextEntry = YES;
    _repeatField.textField.placeholder = @"6-20为字母、数字结合";
    [bgView addSubview:_repeatField];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(11,10+bgView.frame.size.height+30,kWidth-11*2,40);
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnDown) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:HexRGB(0x9be4aa)];
    [self.view addSubview:btn];
}

- (void)btnDown
{
    if ([self checkData]) {
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[SystemConfig sharedInstance].uid,@"uid",_originField.textField.text,@"old_password",_newField.textField.text,@"new_password", nil];
        [httpTool postWithPath:@"modifyPassword" params:param success:^(id JSON) {
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dic = [result objectForKey:@"response"];
            int code = [[dic objectForKey:@"code"] intValue];
            if (code == 100) {
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                if ([user objectForKey:@"password"]) {
                    [user setObject:_newField.textField.text forKey:@"password"];
                }
                [RemindView showViewWithTitle:@"修改密码成功" location:MIDDLE];
            }else{
                NSString *msg = [dic objectForKey:@"msg"];
                [RemindView showViewWithTitle:msg location:MIDDLE];
            }
        } failure:^(NSError *error) {
            [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
        }];
    }
}

- (BOOL)checkData
{
    if (_originField.textField.text.length==0) {
        [RemindView showViewWithTitle:@"请输入原密码" location:MIDDLE];
        return NO;
    }
    if (_newField.textField.text.length == 0) {
        [RemindView showViewWithTitle:@"请输入新密码" location:MIDDLE];
        return NO;
    }
    if (_repeatField.textField.text.length == 0) {
        [RemindView showViewWithTitle:@"请重复输入密码" location:MIDDLE];
        return NO;
    }
    if (![_newField.textField.text isEqualToString:_repeatField.textField.text]) {
        [RemindView showViewWithTitle:@"两次密码输入不一致" location:MIDDLE];
        return NO;
    }
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
