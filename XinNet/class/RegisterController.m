//
//  RegisterController.m
//  XinNet
//
//  Created by Tianj on 14/11/20.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "RegisterController.h"
#import "AdaptationSize.h"
#import "NextRegisterController.h"
#import "RemindView.h"

#define macroFont 10
#define phoneType 2000
#define emailType 2001
#define macroType 1999
#define nextType 2999

@interface RegisterController ()
{
    UITextField *_textField;
    BOOL isEmail;
    UIView *bgView;     //顶部两个按钮的底视图
}
@end

@implementation RegisterController

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
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth,35)];
    [self.view addSubview:bgView];
    
    NSArray *array = [NSArray arrayWithObjects:@"手机号注册",@"邮箱注册", nil];
    for (int i = 0 ; i < array.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((kWidth/2)*i,0,kWidth/2, 35);
        [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:HexRGB(0x808080) forState:UIControlStateNormal];
        [btn setTitleColor:HexRGB(0x18b0e7) forState:UIControlStateSelected];
        if (i == 0) {
            btn.selected = YES;
        }
        btn.tag = 2000+i;
        [btn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
    }
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,40,kWidth,1)];
    line.backgroundColor = HexRGB(0xd5d5d5);
    [self.view addSubview:line];

    _textField = [[UITextField alloc] initWithFrame:CGRectMake(20,40,kWidth-40,35)];
    _textField.placeholder = @"请输入手机号";
    [self.view addSubview:_textField];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0,70,kWidth,1)];
    line1.backgroundColor = HexRGB(0xd5d5d5);
    [self.view addSubview:line1];
    
    UIView *macroBgView = [[UIView alloc] initWithFrame:CGRectMake(0,80, kWidth,15)];
    [self.view addSubview:macroBgView];
    //条款
    CGSize size;
    size = [AdaptationSize getSizeFromString:@"已同意" Font:[UIFont systemFontOfSize:macroFont] withHight:15 withWidth:CGFLOAT_MAX];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,0,size.width,15)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:macroFont];
    label.text = @"已同意";
    [macroBgView addSubview:label];

    NSString  *macro = @"<<行者吖吖服务条款>>";     //条款名称
    size = [AdaptationSize getSizeFromString:macro Font:[UIFont systemFontOfSize:macroFont] withHight:15 withWidth:CGFLOAT_MAX];
    UIButton *macBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    macBtn.titleLabel.font = [UIFont systemFontOfSize:macroFont];
    macBtn.frame = CGRectMake(label.frame.origin.x+label.frame.size.width,0,size.width, 15);
    [macBtn setTitle:macro forState:UIControlStateNormal];
    [macBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    macBtn.tag = 1999;
    [macBtn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
    [macroBgView addSubview:macBtn];
    
    size = [AdaptationSize getSizeFromString:@",点击下一步" Font:[UIFont systemFontOfSize:macroFont] withHight:15 withWidth:CGFLOAT_MAX];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(macBtn.frame.origin.x+macBtn.frame.size.width,0,size.width,15)];
    label1.backgroundColor = [UIColor clearColor];
    label1.text = @",点击下一步";
    label1.font =[UIFont systemFontOfSize:macroFont];
    [macroBgView addSubview:label1];
    
    
    //下一步按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20,120,kWidth-40, 35);
    [button setTitle:@"下一步" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"finish.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"finish_pre.png"] forState:UIControlStateHighlighted];

    button.tag = 2999;
    [button addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)btnDown:(UIButton *)btn
{
    switch (btn.tag) {
        //手机号注册
        case phoneType:
        {
            //设置顶部按钮选中状态
            for (UIView *subViw in bgView.subviews) {
                if ([subViw isKindOfClass:[UIButton class]]) {
                    UIButton *button = (UIButton *)subViw;
                    if (button.tag == phoneType) {
                        button.selected = YES;
                    }else{
                        button.selected = NO;
                    }
                }
            }
            isEmail = NO;
            //改变输入框状态
            _textField.text = @"";
            _textField.placeholder = @"请输入手机号";

        }
            break;
        //邮箱注册
        case emailType:
        {
            for (UIView *subViw in bgView.subviews) {
                if ([subViw isKindOfClass:[UIButton class]]) {
                    UIButton *button = (UIButton *)subViw;
                    if (button.tag == emailType) {
                        button.selected = YES;
                    }else{
                        button.selected = NO;
                    }
                }
            }
            isEmail = YES;
            _textField.text = @"";
            _textField.placeholder = @"请输入邮箱地址";
        }
            break;
        case macroType:
        {
            NSLog(@"点击条款");
        }
            break;
        //下一步
        case nextType:
        {
            if (_textField.text.length==0) {
                if(isEmail){
                    [RemindView showViewWithTitle:@"请输入邮箱地址" location:MIDDLE];
                }else{
                    [RemindView showViewWithTitle:@"请输入手机号" location:MIDDLE];
                }
            }else{
                
                NextRegisterController *next = [[NextRegisterController alloc] init];
                if (isEmail) {
                    next.isEmail = YES;
                }else{
                    next.isEmail = NO;
                }
                next.account = _textField.text;
                [self.navigationController pushViewController:next animated:YES];
            }
        }
            break;

        default:
            break;
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textField resignFirstResponder];
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
