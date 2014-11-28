//
//  PublishTopicController.m
//  XinNet
//
//  Created by Tianj on 14/11/18.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "PublishTopicController.h"
#import "TJImageView.h"
#import "httpTool.h"
#import "RemindView.h"
#import "GTMBase64.h"

#define MaxCount 140     //输入的最多字数

@interface PublishTopicController ()<TJImageViewDelegate,UITextViewDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UITextView *_textView;
    TJImageView *_publishImg;
    UILabel *_markLabel;
    UIButton *addImgBtn;
    NSString *content;   //发布的内容
    BOOL isEditing;  //是否已经开始编辑
    UIImage *image;  //发布的图片
}
@end

@implementation PublishTopicController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HexRGB(0xffffff);
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    // Do any additional setup after loading the view.
    self.title = @"发布话题";
    content = @"";
    [self addView];
}

- (void)addView
{
    //输入框
    CGFloat leftDistance = 20;
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(leftDistance,10,kWidth-leftDistance*2,120)];
    [self.view addSubview:_textView];
    _textView.delegate = self;
    _textView.text = @"说点什么吧";
    _textView.textColor = HexRGB(0xd5d5d5);
    _textView.layer.cornerRadius = 5;
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.layer.masksToBounds = YES;
    _textView.layer.borderColor = HexRGB(0xd5d5d5).CGColor;
    _textView.layer.borderWidth = 0.5;
    
    
    //图片
    _publishImg = [[TJImageView alloc] initWithFrame:CGRectMake(leftDistance,_textView.frame.origin.y+_textView.frame.size.height+15,75,75)];
    _publishImg.backgroundColor = [UIColor redColor];
    [self.view addSubview:_publishImg];
    
    addImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addImgBtn.frame = CGRectMake(leftDistance+_publishImg.frame.size.width+9,_publishImg.frame.origin.y,75, 75);
    addImgBtn.tag = 1000;
    [addImgBtn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
    [addImgBtn setBackgroundImage:[UIImage imageNamed:@"addImg.png"] forState:UIControlStateNormal];
    [self.view addSubview:addImgBtn];
    
    
    
    CGFloat width = 100;        //显示输入字体label的宽度
    _markLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth-width-leftDistance,_textView.frame.origin.y+_textView.frame.size.height+10, width,20)];
    _markLabel.text = [NSString stringWithFormat:@"0/%d",MaxCount];
    _markLabel.backgroundColor = [UIColor clearColor];
    _markLabel.textColor = HexRGB(0xd5d5d5);
    _markLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_markLabel];
    
    //发布按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"确认发布" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.tag = 1001;
    [button setBackgroundImage:[UIImage imageNamed:@"finish.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"finish_pre.png"] forState:UIControlStateHighlighted];
    button.frame = CGRectMake(10,_publishImg.frame.origin.y+_publishImg.frame.size.height+20,kWidth-10*2,36);
    [button addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}


//发布按钮点击
- (void)btnDown:(UIButton *)btn
{
    if (btn.tag == 1000) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"选取图片" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"本地", nil];
        [alertView show];
    }else{
        if (content.length == 0) {
            [RemindView showViewWithTitle:@"说点什么吧" location:MIDDLE];
        }else{
            if (image) {
                [self uploadImage:image];
            }else{
                [self uploadContent:@""];
            }
        }
    }
}

//上传图片
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
            [self uploadContent:data];
        }else{
            [RemindView showViewWithTitle:@"发布失败" location:MIDDLE];
        }
    } failure:^(NSError *error) {

        [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
    }];
}


//发布话题内容
- (void)uploadContent:(NSString *)data
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:content,@"content", nil];
    if (data.length !=0) {
        [param setObject:data forKey:@"image"];
    }
    [httpTool postWithPath:@"addTopic" params:param success:^(id JSON) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic =[result objectForKey:@"response"];
        int code = [[dic objectForKey:@"code"]intValue];
        if (code == 100) {
            [RemindView showViewWithTitle:@"发布成功" location:MIDDLE];
            //刷新话题广场内容
            if ([self.delegate respondsToSelector:@selector(reloadView)]) {
                [self.delegate reloadView];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            NSString *msg = [dic objectForKey:@"msg"];
            [RemindView showViewWithTitle:msg location:MIDDLE];
        }
    } failure:^(NSError *error) {
        [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
    }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (!isEditing) {
        isEditing = YES;
        textView.text = @"";
        _textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > MaxCount) {
        textView.text = [textView.text substringToIndex:MaxCount];
    }
    content = textView.text;
    [self performSelectorOnMainThread:@selector(changeUI) withObject:self waitUntilDone:NO];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([[textView text] length]>MaxCount){
        return NO;
    }
    //判断是否为删除字符，如果为删除则让执行
    
    char c=[text UTF8String][0];
    if (c=='\000') {
        return YES;
    }
    if([[textView text] length]==MaxCount) {
        if(![text isEqualToString:@"\b"]) return NO;
    }
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textView resignFirstResponder];
}

- (void)changeUI
{
    _markLabel.text = [NSString stringWithFormat:@"%d/%d",(int)_textView.text.length,MaxCount];
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
    _publishImg.image = portraitImg;
    image = portraitImg;
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
