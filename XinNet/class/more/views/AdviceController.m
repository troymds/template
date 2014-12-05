//
//  AdviceController.m
//  XinNet
//
//  Created by tianj on 14-11-19.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "AdviceController.h"
#import "RemindView.h"
#import "ProAlertView.h"
#import "httpTool.h"

#define placeHoldeStr @"请在这里写下您的宝贵意见,来帮助我们提供给您更好的服务!"

@interface AdviceController ()<UITextViewDelegate>
{
    UITextView *_textView;
    BOOL isFirstEdit;   //判断是否是第一次编辑  用于控制提示文字的显示
    NSString *adviceStr;   //提交的反馈信息
}
@end

@implementation AdviceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = HexRGB(0xededed);
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.title = @"意见反馈";
    
    //初始化反馈信息为空
    adviceStr = @"";
    
    [self addView];
    
}

- (void)addView
{
    CGFloat leftDistance = 10;//左边距
    CGFloat topDistance = 10;//顶边距
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(leftDistance,topDistance,kWidth-leftDistance*2,150)];
    _textView.layer.borderColor = HexRGB(0xd5d5d5).CGColor;
    _textView.layer.borderWidth = 1.0f;
    _textView.layer.masksToBounds = YES;
    _textView.layer.cornerRadius = 4.0f;
    _textView.delegate = self;
    _textView.backgroundColor = HexRGB(0xffffff);
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.text = placeHoldeStr;
    _textView.textColor = HexRGB(0xcdcdcd);
    [self.view addSubview:_textView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(11,topDistance+_textView.frame.size.height+11,kWidth-11*2,35);
    [button setTitle:@"提交反馈" forState:UIControlStateNormal];
    [button setBackgroundColor:HexRGB(0x9be4aa)];

//    [button setBackgroundImage:[UIImage imageNamed:@"finish.png"] forState:UIControlStateNormal];
//    [button setBackgroundImage:[UIImage imageNamed:@"finish_pre.png"] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnDown) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

//提交反馈
- (void)btnDown
{
    if (adviceStr.length == 0) {
        [RemindView showViewWithTitle:@"请输入您宝贵的意见!" location:MIDDLE];
    }else{
        //提交反馈
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:adviceStr,@"content", nil];
        [httpTool postWithPath:@"postSuggest" params:param success:^(id JSON) {
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dic = [result objectForKey:@"response"];
            int code = [[dic objectForKey:@"code"] intValue];
            if (code == 100) {
                NSString *data = [dic objectForKey:@"data"];
                //弹出提交成功窗口
                adviceStr = @"";
                _textView.text = @"";
                ProAlertView *alertView = [[ProAlertView alloc] initWithTitle:@"提交反馈成功" withMessage:data delegate:self cancleButton:@"完成" otherButton:nil, nil];
                [alertView show];
            }else{
                NSString *msg = [dic objectForKey:@"msg"];
                [RemindView showViewWithTitle:msg location:MIDDLE];
            }
        } failure:^(NSError *error) {
            [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
        }];
    }
}


#pragma mark textView_delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    //当第一次编辑的时候 去掉里面显示的文字  改为正常编辑状态
    if (!isFirstEdit) {
        isFirstEdit = YES;
        _textView.text = @"";
        _textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    adviceStr = textView.text;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textView resignFirstResponder];
}

#pragma mark -------

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
