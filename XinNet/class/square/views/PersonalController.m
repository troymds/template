//
//  PersonalController.m
//  XinNet
//
//  Created by tianj on 14-11-19.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "PersonalController.h"
#import "ListView.h"
#import "TJImageView.h"
#import "TextListView.h"
#import "httpTool.h"
#import "RemindView.h"
#import "GTMBase64.h"
#import "AuthencateTool.h"
#import "LoginController.h"


#define leftDinstance 11
#define topDistance 11

@interface PersonalController ()<TJImageViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
{
    ListView *_iconView;
    TextListView *_nickNameView;
    ListView *_emailView;
    TextListView *_phoneView;
    TJImageView *_iconImageView;
    UIImage *_iconImg;
}
@end

@implementation PersonalController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HexRGB(0xe9f1f6);
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.title = @"个人资料";
    [self addRightNavButton];
    [self addView];
}

//添加右导航按钮
- (void)addRightNavButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 54, 25);
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBarButtonDown) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)addView
{
    CGFloat height = 47;
    CGFloat firstHeight = 81;   //第一列的高度
    CGFloat width = kWidth-leftDinstance*2;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(leftDinstance,topDistance,width,firstHeight+height*3)];
    bgView.backgroundColor = HexRGB(0xffffff);
    bgView.layer.borderColor = HexRGB(0xc3c3c3).CGColor;
    bgView.layer.borderWidth = 1.0f;
    bgView.layer.cornerRadius = 4.0f;
    bgView.layer.masksToBounds = YES;
    [self.view addSubview:bgView];
    
    for (int i = 0 ; i < 4; i++) {
        
        UIView *line = [[UIView alloc] init];
        if (i == 0) {
            line.frame = CGRectMake(0,firstHeight-1,width,1);
        }else{
            line.frame = CGRectMake(0,firstHeight+height*i-1,width,1);
        }
        line.backgroundColor = HexRGB(0xd5d5d5);
        [bgView addSubview:line];
    }
    
    _iconView = [[ListView alloc] initWithFrame:CGRectMake(10,0,width-10,firstHeight)];
    [_iconView setTitle:@"头像"];
    [bgView addSubview:_iconView];
    
    _iconImageView = [[TJImageView alloc] initWithFrame:CGRectMake(_iconView.frame.size.width-20-(firstHeight-20),10,(firstHeight-20), (firstHeight-20))];
    _iconImageView.image = [UIImage imageNamed:@"l"];
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.cornerRadius = 4.0f;
    _iconImageView.delegate = self;
    [_iconView addSubview:_iconImageView];
    
    
    _nickNameView = [[TextListView alloc] initWithFrame:CGRectMake(10,firstHeight,width-10,height)];
    [_nickNameView setTitle:@"昵称"];
    _nickNameView.textField.delegate = self;
    [bgView addSubview:_nickNameView];
    
    _emailView = [[ListView alloc] initWithFrame:CGRectMake(10,firstHeight+height,width-10,height)];
    [_emailView setTitle:@"邮箱"];
    if (_email&&_email.length!=0) {
        _emailView.detailLabel.text = _email;
    }
    [bgView addSubview:_emailView];
    
    _phoneView = [[TextListView alloc] initWithFrame:CGRectMake(10,firstHeight+height*2,width-10,height)];
    [_phoneView setTitle:@"手机号码"];
    _phoneView.textField.delegate = self;
    _phoneView.textField.keyboardType = UIKeyboardTypePhonePad;
    [bgView addSubview:_phoneView];
}


//右导航按钮点击
- (void)rightBarButtonDown
{
    if ([self checkData]) {
        if (_iconImg) {
            [self uploadImage:_iconImg];
        }
    }
}
//检查上传信息是否完整
- (BOOL)checkData
{
    if (_nickNameView.textField.text.length==0) {
        [RemindView showViewWithTitle:@"请输入昵称" location:MIDDLE];
        return NO;
    }
    if (_phoneView.textField.text.length!=0) {
        if (![AuthencateTool isValidPhone:_phoneView.textField.text]) {
            [RemindView showViewWithTitle:@"号码格式不正确" location:MIDDLE];
            return NO;
        }
        
    }
    return YES;
}


//上传头像
- (void)uploadImage:(UIImage *)img
{
    NSData *data;
    NSString *str;
    if (UIImagePNGRepresentation(img)) {
        data = UIImagePNGRepresentation(img);
        str= @"png";
    }else{
        data = UIImageJPEGRepresentation(img, 1.0);
        str = @"jpg";
    }
    NSString *s = [GTMBase64 stringByEncodingData:data];
    NSString *string = [NSString stringWithFormat:@"data:image/%@;base64,%@",str,s];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:string,@"image", nil];
    [httpTool postWithPath:@"uploadImage" params:param success:^(id JSON) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic = [result objectForKey:@"response"];
        int code = [[dic objectForKey:@"code"]intValue];
        if (code == 100) {
            NSString *data = [dic objectForKey:@"data"];
            [self uploadUserInfo:data];
        }else{
            [RemindView showViewWithTitle:@"发布失败" location:MIDDLE];
        }
    } failure:^(NSError *error) {
        
        [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
    }];

}

//上传个人资料
- (void)uploadUserInfo:(NSString *)data
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:_nickNameView.textField.text,@"username", nil];
    if (data.length!=0) {
        [param setObject:data forKey:@"avatar"];
    }
    if (_phoneView.textField.text.length!=0) {
        [param setObject:_phoneView.textField.text forKey:@"mobile"];
    }
    [httpTool postWithPath:@"updateAccountInfo" params:param success:^(id JSON) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic = [result objectForKey:@"response"];
        int code = [[dic objectForKey:@"code"]intValue];
        //更新成功
        if (code == 100) {
            NSArray *array = self.navigationController.viewControllers;
            for (UIViewController *viewController in array) {
                if ([viewController isKindOfClass:[LoginController class]]) {
                    [RemindView showViewWithTitle:@"信息填写完毕,请登录" location:MIDDLE];
                    [self.navigationController popToViewController:viewController animated:YES];
                    return ;
                }
            }
            [RemindView showViewWithTitle:@"更新成功" location:MIDDLE];
            
        }else{
            NSString *msg = [dic objectForKey:@"msg"];
            [RemindView showViewWithTitle:msg location:MIDDLE];
        }
    } failure:^(NSError *error) {
        [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
    }];
}

- (void)imageViewClick:(TJImageView *)view
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"选取图片" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"相机",@"相簿", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.allowsEditing = YES;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }else if(buttonIndex ==2){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    _iconImageView.image = portraitImg;
    _iconImg = portraitImg;
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark textField_delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_phoneView.textField resignFirstResponder];
    [_nickNameView.textField resignFirstResponder];
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_nickNameView.textField resignFirstResponder];
    [_phoneView.textField resignFirstResponder];
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
