//
//  SquareCell.m
//  XinNet
//
//  Created by Tianj on 14/11/18.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "SquareCell.h"


@implementation SquareCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //头像
        _iconImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_iconImg];
        
        //用户名
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _userNameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_userNameLabel];
        
        //文字内容
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:ContentFont];
        [self.contentView addSubview:_contentLabel];
        
        //发布图片
        _publishImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_publishImg];
        
        //日期
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.textColor = HexRGB(0x808080);
        _dateLabel.font = [UIFont systemFontOfSize:DateFont];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_dateLabel];
        
    }
    return self;
}

- (void)setObject:(SquareUserItem *)item
{
    CGFloat x = LeftSpace,y = TopSapce;
    //加载头像
    self.iconImg.frame = CGRectMake(x,y,IconImgWidth,IconImgHeight);
    self.iconImg.layer.masksToBounds = YES;
    self.iconImg.layer.cornerRadius = IconImgWidth/2;
    if (item.iconImg&&item.iconImg.length!=0) {
        self.iconImg.image = [UIImage imageNamed:@"l"];
    }else{
        //没头像  加载默认图片
        self.iconImg.image = [UIImage imageNamed:@"l"];
    }
    x += IconImgWidth +5;
    self.userNameLabel.frame = CGRectMake(x, TopSapce,150,UserNameHeight);
    self.userNameLabel.text = item.userName;
    
    self.dateLabel.frame = CGRectMake(kWidth-10-120,TopSapce+5,120,15);
    self.dateLabel.text = item.date;

    
    y +=  UserNameHeight + MiddleSpace;
    
    
    CGSize size = [AdaptationSize getSizeFromString:item.content Font:[UIFont systemFontOfSize:ContentFont] withHight:CGFLOAT_MAX withWidth:ContentWidth];
    
    self.contentLabel.frame = CGRectMake(x,y, ContentWidth,size.height);
    y += size.height;
    
    self.contentLabel.text = item.content;
    y += MiddleSpace;
    //用户是否发布了图片
    if (item.publishImg&&item.publishImg.length!=0){
        self.publishImg.hidden = NO;
        self.publishImg.frame = CGRectMake((kWidth-PublishImgWidth)/2,y, PublishImgWidth,PublishImgHeiht);
        //此处应设置图片
        self.publishImg.image = [UIImage imageNamed:@"l"];
    }else{
        self.publishImg.hidden = YES;
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef content = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(content,HexRGB(0xd5d5d5).CGColor);
    CGContextSetLineWidth(content,1);
    CGContextBeginPath(content);
    CGContextMoveToPoint(content, rect.origin.x,rect.size.height);
    CGContextAddLineToPoint(content, rect.size.width, rect.size.height);
    CGContextStrokePath(content);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
