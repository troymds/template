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
#import "GlobalInstance.h"

#define leftDinstance 11
#define topDistance 11

@interface PersonalController ()<TJImageViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    ListView *_iconView;
    ListView *_accountView;
    ListView *_nickNameView;
    ListView *_emailView;
    ListView *_phoneView;
    TJImageView *_iconImage;
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
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(leftDinstance,topDistance,width,firstHeight+height*4)];
    bgView.backgroundColor = HexRGB(0xffffff);
    bgView.layer.borderColor = HexRGB(0xc3c3c3).CGColor;
    bgView.layer.borderWidth = 1.0f;
    bgView.layer.cornerRadius = 4.0f;
    bgView.layer.masksToBounds = YES;
    [self.view addSubview:bgView];
    
    for (int i = 0 ; i < 5; i++) {
        
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
    
    _iconImage = [[TJImageView alloc] initWithFrame:CGRectMake(_iconView.frame.size.width-20-(firstHeight-20),10,(firstHeight-20), (firstHeight-20))];
    _iconImage.image = [UIImage imageNamed:@"l"];
    _iconImage.layer.masksToBounds = YES;
    _iconImage.layer.cornerRadius = 4.0f;
    _iconImage.delegate = self;
    [_iconView addSubview:_iconImage];
    
    
    _accountView = [[ListView alloc] initWithFrame:CGRectMake(10,firstHeight,width-10,height)];
    [_accountView setTitle:@"账号"];
    _accountView.detailLabel.text = @"xxxxxxx";
    [bgView addSubview:_accountView];
    
    _nickNameView = [[ListView alloc] initWithFrame:CGRectMake(10,firstHeight+height,width-10,height)];
    [_nickNameView setTitle:@"昵称"];
    _nickNameView.detailLabel.text = @"xxxxxxxxx";
    [bgView addSubview:_nickNameView];
    
    _emailView = [[ListView alloc] initWithFrame:CGRectMake(10,firstHeight+height*2,width-10,height)];
    [_emailView setTitle:@"邮箱"];
    _emailView.detailLabel.text = @"xxxxxxxxx";
    [bgView addSubview:_emailView];
    
    _phoneView = [[ListView alloc] initWithFrame:CGRectMake(10,firstHeight+height*3,width-10,height)];
    [_phoneView setTitle:@"手机号码"];
    _phoneView.detailLabel.text = @"xxxxxxxxx";
    [bgView addSubview:_phoneView];
    
}


//右导航按钮点击
- (void)rightBarButtonDown
{
    
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
    _iconImage.image = portraitImg;
    _iconImg = portraitImg;
    [picker dismissViewControllerAnimated:YES completion:nil];
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
