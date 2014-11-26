//
//  PublishController.m
//  XinNet
//
//  Created by Tianj on 14/11/22.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "PublishController.h"
#import "AdaptationSize.h"
#import "httpTool.h"
#import "RemindView.h"

#define topDistance 11
#define leftDistance 10
#define labelFont 17

@interface PublishController ()<UITextViewDelegate,UITextFieldDelegate>
{
    UIView *bgView;
    UITextField *titleField;  //标题输入框
    UITextField *numField;      //数量输入框
    UITextView *contentView;   //内容
    BOOL isFisrtEdit;    //内容输入框是否已经被点击过  用于控制显示的文字
    UIButton *pubBtn;
    
    UIScrollView *_scrollView; //键盘弹出时控制整个试图的上移
    
    UIView *bottomView;    //底部试图，用于控制整个试图的上移
    
    id activeText;   //当前活动的输入框 titleField、numField、contentView
}
@end

@implementation PublishController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HexRGB(0xe9f0f5);
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    // Do any additional setup after loading the view.
    
    NSLog(@"%f,%f,%f,%f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
    
    [self addView];

    //键盘隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHiden) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    
    //如果是编辑页面  则加载数据显示
    if (!self.isPublish) {
        [self loadData];
    }
}

//编辑页面加载数据
- (void)loadData
{
    
}

- (void)keyboardWillHiden
{
    [_scrollView setContentSize:CGSizeMake(kWidth, kHeight-64)];
}

- (void)keyboardWillShow
{
    
}


- (void)addView
{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bottomView.backgroundColor = HexRGB(0xe9f0f5);
    [self.view addSubview:_scrollView];
    
    CGFloat y = topDistance;
    CGFloat height = 45;  //输入框高度
    CGFloat width = kWidth - leftDistance*2;
    bgView = [[UIView alloc] initWithFrame:CGRectMake(leftDistance,y,width,height*2+155)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 5.0f;
    bgView.layer.borderColor = HexRGB(0xc3c3c3).CGColor;
    bgView.layer.borderWidth = 1.0f;
    [_scrollView addSubview:bgView];
    for (int i = 1; i < 3; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,height*i-1,width,1)];
        line.backgroundColor = HexRGB(0xc3c3c3);
        [bgView addSubview:line];
    }
    
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0,55, height)];
    userNameLabel.backgroundColor = [UIColor clearColor];
    userNameLabel.textColor = HexRGB(0x3a3a3a);
    userNameLabel.font = [UIFont systemFontOfSize:labelFont];
    userNameLabel.text = @"标题 :";
    [bgView addSubview:userNameLabel];
    
    titleField = [[UITextField alloc] initWithFrame:CGRectMake(60,0,width-60,height)];
    titleField.delegate= self;
    titleField.placeholder = @"请填写标题,30字以内";
    [bgView addSubview:titleField];
    
    
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,height,55, height)];
    passwordLabel.backgroundColor = [UIColor clearColor];
    passwordLabel.textColor = HexRGB(0x3a3a3a);
    passwordLabel.font = [UIFont systemFontOfSize:labelFont];
    passwordLabel.text = @"数量 :";
    [bgView addSubview:passwordLabel];
    
    numField = [[UITextField alloc] initWithFrame:CGRectMake(60,height,width-60,height)];
    numField.delegate = self;
    [bgView addSubview:numField];
    
    
    CGSize size = [AdaptationSize getSizeFromString:@"内容 :" Font:[UIFont systemFontOfSize:labelFont] withHight:CGFLOAT_MAX withWidth:60];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5,height*2+(height-size.height)/2,60, size.height)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = HexRGB((0x3a3a3a));
    userNameLabel.font = [UIFont systemFontOfSize:labelFont];
    label.text = @"内容 :";
    [bgView addSubview:label];
    
    contentView = [[UITextView alloc] initWithFrame:CGRectMake(0,label.frame.origin.y+label.frame.size.height,width,bgView.frame.size.height-(label.frame.origin.y+label.frame.size.height))];
    contentView.text = @"请填写内容,500字以内";
    contentView.textColor = HexRGB(0xc3c3c3);
    contentView.font = [UIFont systemFontOfSize:labelFont];
    contentView.font = [UIFont systemFontOfSize:labelFont];
    contentView.delegate = self;
    [bgView addSubview:contentView];
    
    
    pubBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pubBtn.frame = CGRectMake(leftDistance,topDistance+bgView.frame.size.height+22,kWidth-leftDistance*2,35);
    [pubBtn setBackgroundImage:[UIImage imageNamed:@"finish.png"] forState:UIControlStateNormal];
    [pubBtn setBackgroundImage:[UIImage imageNamed:@"finish_pre.png"] forState:UIControlStateHighlighted];
    [pubBtn setTitle:@"确认发布" forState:UIControlStateNormal];
    [pubBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pubBtn addTarget:self action:@selector(btnDown) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:pubBtn];
    
}

//发布按钮点击事件
- (void)btnDown
{
    if ([self checkData]) {
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:titleField.text,@"title",numField.text,@"num",contentView.text,@"content", nil];
        [httpTool postWithPath:@"addDemand" params:param success:^(id JSON) {
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dic = [result objectForKey:@"response"];
            int code = [[dic objectForKey:@"code"]intValue];
            if (code == 100) {
                [RemindView showViewWithTitle:@"发布成功" location:MIDDLE];
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
    if (titleField.text.length == 0) {
        [RemindView showViewWithTitle:@"请填写标题" location:MIDDLE];
        return NO;
    }
    if (numField.text.length == 0) {
        [RemindView showViewWithTitle:@"请填写求购数量" location:MIDDLE];
        return NO;
    }
    if (contentView.text.length == 0) {
        [RemindView showViewWithTitle:@"请输入求购详情" location:MIDDLE];
        return NO;
    }
    return YES;
}


- (void)clearData
{
    titleField.text = @"";
    numField.text = @"";
    contentView.text = @"";
}

#pragma mark textView_delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    activeText = textView;
    if (!isFisrtEdit) {
        isFisrtEdit = YES;
        textView.text = @"";
        textView.textColor = HexRGB(0x3a3a3a);
    }
    if (bottomView.frame.origin.y>=0) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect = bottomView.frame;
            rect.origin.y -= 80;
            bottomView.frame = rect;
        }];
    }
}


#pragma mark textField_delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeText =textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [titleField resignFirstResponder];
    [numField resignFirstResponder];
    return YES;
}

#pragma mark -----
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [titleField resignFirstResponder];
    [numField resignFirstResponder];
    [contentView resignFirstResponder];
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
