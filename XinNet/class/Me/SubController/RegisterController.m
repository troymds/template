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
#import "ProtocolView.h"
#import "PersonalController.h"

#define topDistance  20
#define leftDistance 10


#define macroFont 10
#define displayType 2000
#define selectType 2001
#define macroType 2002
#define nextType 2003

@interface RegisterController ()
{
    UITextField *_userNameField;
    UITextField *_secretField;
    UIButton *playButton;//密码显示按钮
    UIButton *nextBtn;
    UIButton *selectBtn;//选择条款btn
    UIView *bgView;
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
    CGFloat y = topDistance;
    CGFloat height = 45;  //输入框高度
    CGFloat width = kWidth - leftDistance*2;
    bgView = [[UIView alloc] initWithFrame:CGRectMake(leftDistance,y,width,height*2)];
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
    _userNameField.placeholder = @"请输入您的邮箱";
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
    playButton.tag = displayType;
    [playButton addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:playButton];
    
    [self addMacroView];
}

//添加协议
- (void)addMacroView
{
    UIView *macroBgView = [[UIView alloc] initWithFrame:CGRectMake(0,topDistance+bgView.frame.size.height+10, kWidth,30)];
    [self.view addSubview:macroBgView];
    //条款
    
    selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(leftDistance,0,30, 30);
    selectBtn.tag = selectType;
    [selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"box.png"] forState:UIControlStateNormal];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"boxSelected.png"] forState:UIControlStateSelected];
    [selectBtn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
    [macroBgView addSubview:selectBtn];

    
    CGSize size;
    size = [AdaptationSize getSizeFromString:@"已同意" Font:[UIFont systemFontOfSize:macroFont] withHight:CGFLOAT_MAX withWidth:CGFLOAT_MAX];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(leftDistance+selectBtn.frame.size.width,(macroBgView.frame.size.height-size.height)/2,size.width,size.height)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:macroFont];
    label.text = @"已同意";
    [macroBgView addSubview:label];
    
    NSString  *macro = @"<<新网服务条款>>";     //条款名称
    size = [AdaptationSize getSizeFromString:macro Font:[UIFont systemFontOfSize:macroFont] withHight:CGFLOAT_MAX withWidth:CGFLOAT_MAX];
    UIButton *macBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    macBtn.titleLabel.font = [UIFont systemFontOfSize:macroFont];
    macBtn.frame = CGRectMake(label.frame.origin.x+label.frame.size.width,(macroBgView.frame.size.height-size.height)/2,size.width,size.height);
    [macBtn setTitle:macro forState:UIControlStateNormal];
    [macBtn setTitleColor:HexRGB(0x9be4aa) forState:UIControlStateNormal];
    macBtn.tag = macroType;
    [macBtn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
    [macroBgView addSubview:macBtn];
    
    size = [AdaptationSize getSizeFromString:@",点击下一步" Font:[UIFont systemFontOfSize:macroFont] withHight:15 withWidth:CGFLOAT_MAX];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(macBtn.frame.origin.x+macBtn.frame.size.width,(macroBgView.frame.size.height-size.height)/2,size.width,size.height)];
    label1.backgroundColor = [UIColor clearColor];
    label1.text = @",点击下一步";
    label1.font =[UIFont systemFontOfSize:macroFont];
    [macroBgView addSubview:label1];

    [self addNextButton];
}

//添加下一步按钮
- (void)addNextButton
{    //下一步按钮
    CGFloat y = topDistance+bgView.frame.size.height+10+30+22;
    nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(leftDistance,y,kWidth-leftDistance*2, 35);
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextBtn.enabled = NO;
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn setBackgroundColor:HexRGB(0x9be4aa)];

//    [nextBtn setBackgroundImage:[UIImage imageNamed:@"finish.png"] forState:UIControlStateNormal];
//    [nextBtn setBackgroundImage:[UIImage imageNamed:@"finish_pre.png"] forState:UIControlStateHighlighted];
    
    nextBtn.tag = nextType;
    [nextBtn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];

    
}

- (void)btnDown:(UIButton *)btn
{
    switch (btn.tag) {
        //显示密码
        case displayType:
        {
            btn.selected = !btn.selected;
            if (btn.selected) {
                _secretField.secureTextEntry = NO;
            }else{
                _secretField.secureTextEntry = YES;
            }
        }
            break;
        //同意条款
        case selectType:
        {
            btn.selected = !btn.selected;
            if (btn.selected) {
                nextBtn.enabled = YES;
            }else{
                nextBtn.enabled = NO;
            }
        }
            break;
            //展开条款
        case macroType:
        {
            [httpTool postWithPath:@"getProtocol" params:nil success:^(id JSON) {
                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
                NSDictionary *dict = [result objectForKey:@"response"];
                int code = [[dict objectForKey:@"code"] intValue];
                if (code == 100) {
                    NSString *urlStr = [[dict objectForKey:@"data"] objectForKey:@"wapUrl"];
                    ProtocolView *protocolView = [[ProtocolView alloc] initWithUrl:urlStr];
                    [protocolView showProtocolView];
                }else{
                    [RemindView showViewWithTitle:@"获取服务条款失败" location:MIDDLE];
                }
            } failure:^(NSError *error) {
                [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
            }];
        }
            break;
        //下一步
        case nextType:
        {
            if ([self checkData]) {
                NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:_userNameField.text,@"email",_secretField.text,@"password", nil];
                [httpTool postWithPath:@"register" params:param success:^(id JSON) {
                    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
                    NSDictionary *dic = [result objectForKey:@"response"];
                    int code = [[dic objectForKey:@"code"] intValue];
                    if (code == 100) {
                        NSString *data = [NSString stringWithFormat:@"%d",[dic[@"data"] intValue]];
                        [SystemConfig sharedInstance].uid = data;
                        PersonalController *PC = [[PersonalController alloc] init];
                        PC.email = _userNameField.text;
                        [self.navigationController pushViewController:PC animated:YES];
                    }else{
                        NSString *msg= [dic objectForKey:@"msg"];
                        [RemindView showViewWithTitle:msg location:MIDDLE];
                    }
                } failure:^(NSError *error) {
                    [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
                }];
            }
        }
            break;

        default:
            break;
    }
}

- (BOOL)checkData
{
    if (_userNameField.text.length==0) {
        [RemindView showViewWithTitle:@"请输入邮箱" location:MIDDLE];
        return NO;
    }
    if (_secretField.text.length==0) {
        [RemindView showViewWithTitle:@"请输入密码" location:MIDDLE];
        return NO;
    }
    return YES;
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
