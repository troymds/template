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
#import "DemandDetailItem.h"
#import "MBProgressHUD.h"

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
    
    id activeText;   //当前活动的输入框 titleField、numField、contentView
    
    int bottomSpace;       //确认按钮距离屏幕底端的距离  用于控制键盘弹出时整个视图的位置的调整
    
    CGFloat keyboardHeight;  //键盘高度
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
    
    [self addView];

    //键盘隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHiden) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //如果是编辑页面  则加载数据显示
    if (!self.isPublish) {
        [self loadData];
    }
}

#pragma mark 获取键盘高度
- (void)keyboardWillChange:(NSNotification *)notify
{
    NSDictionary *info = [notify userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect rect = [value CGRectValue];
    CGFloat height = rect.size.height;
    keyboardHeight = height;
    if ([activeText isKindOfClass:[UITextView class]]) {
        if (bottomSpace<keyboardHeight) {   //216为键盘的高度 此处设置死了
            _scrollView.contentSize = CGSizeMake(kWidth, kHeight-64+(keyboardHeight-bottomSpace));
            bottomSpace = _scrollView.contentSize.height-(pubBtn.frame.origin.y+pubBtn.frame.size.height);
            [_scrollView setContentOffset:CGPointMake(0, _scrollView.contentSize.height-_scrollView.frame.size.height) animated:YES];
        }
    }
}

#pragma mark 请求需要编辑的数据
- (void)loadData
{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:self.uid,@"id", nil];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = NO;
    [httpTool postWithPath:@"getDemandDetail" params:param success:^(id JSON) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic = [result objectForKey:@"response"];
        int code = [[dic objectForKey:@"code"]intValue];
        if (code ==100) {
            NSDictionary *data = [dic objectForKey:@"data"];
            DemandDetailItem *item = [[DemandDetailItem alloc] initWithDic:data];
            [self addDataToInterface:item];
        }else{
            NSString *msg =[dic objectForKey:@"msg"];
            [RemindView showViewWithTitle:msg location:MIDDLE];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
    }];
}

//添加要编辑的数据
- (void)addDataToInterface:(DemandDetailItem *)item
{
    titleField.text = item.title;
    numField.text = item.num;
    contentView.text = item.content;
    contentView.textColor = [UIColor blackColor];
}

#pragma mark 键盘隐藏
- (void)keyboardWillHiden
{
    [_scrollView setContentSize:CGSizeMake(kWidth, kHeight-64)];
    bottomSpace = _scrollView.contentSize.height-(pubBtn.frame.origin.y+pubBtn.frame.size.height);
}

#pragma mark  添加视图
- (void)addView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,kWidth,kHeight-64)];
    _scrollView.backgroundColor = HexRGB(0xe9f0f5);
    [_scrollView setContentSize:CGSizeMake(kWidth, kHeight-64)];
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
    titleField.tag = 1000;
    titleField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
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
    numField.tag = 1001;
    numField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    numField.keyboardType = UIKeyboardTypeNumberPad;
    [bgView addSubview:numField];
    
    
    CGSize size = [AdaptationSize getSizeFromString:@"内容 :" Font:[UIFont systemFontOfSize:labelFont] withHight:CGFLOAT_MAX withWidth:60];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5,height*2+(height-size.height)/2,60, size.height)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = HexRGB((0x3a3a3a));
    userNameLabel.font = [UIFont systemFontOfSize:labelFont];
    label.text = @"内容 :";
    [bgView addSubview:label];
    
    //内容输入框
    contentView = [[UITextView alloc] initWithFrame:CGRectMake(0,label.frame.origin.y+label.frame.size.height,width,bgView.frame.size.height-(label.frame.origin.y+label.frame.size.height))];
    contentView.text = @"请填写内容,500字以内";
    contentView.textColor = HexRGB(0xc3c3c3);
    contentView.font = [UIFont systemFontOfSize:labelFont];
    contentView.font = [UIFont systemFontOfSize:labelFont];
    contentView.delegate = self;
    [bgView addSubview:contentView];
    
    //发布按钮
    pubBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pubBtn.frame = CGRectMake(leftDistance,topDistance+bgView.frame.size.height+22,kWidth-leftDistance*2,35);
    [pubBtn setBackgroundColor:HexRGB(0x9be4aa)];

//    [pubBtn setBackgroundImage:[UIImage imageNamed:@"finish.png"] forState:UIControlStateNormal];
//    [pubBtn setBackgroundImage:[UIImage imageNamed:@"finish_pre.png"] forState:UIControlStateHighlighted];
    [pubBtn setTitle:@"确认发布" forState:UIControlStateNormal];
    [pubBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pubBtn addTarget:self action:@selector(btnDown) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:pubBtn];
    
    bottomSpace = _scrollView.contentSize.height-(pubBtn.frame.origin.y+pubBtn.frame.size.height);
}

#pragma mark  确认按钮点击
- (void)btnDown
{
    [activeText resignFirstResponder];
    if ([self checkData]) {
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:titleField.text,@"title",numField.text,@"num",contentView.text,@"content", nil];
        NSString *path = @"addDemand";
        if (!_isPublish) {
            [param setObject:self.uid forKey:@"id"];
            path = @"updateDemand";
        }
        [httpTool postWithPath:path params:param success:^(id JSON) {
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dic = [result objectForKey:@"response"];
            int code = [[dic objectForKey:@"code"]intValue];
            if (code == 100) {
                NSString *data;
                if (_isPublish) {
                    data = @"发布成功";
                    [self clearData];
                    
                    if ([self.delegate respondsToSelector:@selector(reloadTableView)]) {
                        [self.delegate reloadTableView];
                    }
                    
                }else{
                    data = @"修改成功";
                }
                [RemindView showViewWithTitle:data location:MIDDLE];
            }else{
                NSString *msg = [dic objectForKey:@"msg"];
                [RemindView showViewWithTitle:msg location:MIDDLE];
            }
        } failure:^(NSError *error) {
            [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
        }];
    }
}

#pragma mark 发布成功后清空数据
- (void)clearData
{
    titleField.text = @"";
    numField.text = @"";
    contentView.text = @"";
}

#pragma mark 检查数据
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

#pragma mark textView_delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    activeText = textView;
    if (self.isPublish) {
        if (!isFisrtEdit) {
            isFisrtEdit = YES;
            textView.text = @"";
            textView.textColor = [UIColor blackColor];
        }
    }
    if (bottomSpace<keyboardHeight) {   //216为键盘的高度 此处设置死了
        _scrollView.contentSize = CGSizeMake(kWidth, kHeight-64+(keyboardHeight-bottomSpace));
        bottomSpace = _scrollView.contentSize.height-(pubBtn.frame.origin.y+pubBtn.frame.size.height);
        [_scrollView setContentOffset:CGPointMake(0, _scrollView.contentSize.height-_scrollView.frame.size.height) animated:YES];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 1001) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789\n"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basic = [string isEqualToString:filtered];
        if (!basic) {
            return NO;
        }
    }
    return YES;
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
    [activeText resignFirstResponder];
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
