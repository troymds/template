//
//  CommentCell.m
//  XinNet
//
//  Created by tianj on 14-11-20.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "CommentCell.h"

@interface CommentCell ()
{
    UIView *bgView;
}
@end

@implementation CommentCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = HexRGB(0xe9f1f6);
        _titileLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titileLabel.backgroundColor = [UIColor clearColor];
        _titileLabel.textColor = HexRGB(0x3a3a3a);
        _titileLabel.font = [UIFont systemFontOfSize:titleFone];
        [self.contentView addSubview:_titileLabel];
        
        bgView = [[UIView alloc] initWithFrame:CGRectZero];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 3.0f;
        bgView.layer.masksToBounds = YES;
        [self.contentView addSubview:bgView];
        
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _commentLabel.backgroundColor = [UIColor clearColor];
        _commentLabel.font = [UIFont systemFontOfSize:contentFont];
        _commentLabel.textColor = HexRGB(0x3a3a3a);
        _commentLabel.numberOfLines = 0;
        [bgView addSubview:_commentLabel];
        
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth,1)];
        _line.backgroundColor = HexRGB(0xd5d5d5);
        [self.contentView addSubview:_line];
    }
    return self;
}


- (void)setObject:(CommentItem *)obj
{
    _titileLabel.frame = CGRectMake(leftDistance,topDistance,bgWidth,25);
    _titileLabel.text = obj.title;
    
    CGSize size = [AdaptationSize getSizeFromString:obj.content Font:[UIFont systemFontOfSize:contentFont] withHight:CGFLOAT_MAX withWidth:commentWidth];
    
    bgView.frame = CGRectMake(leftDistance,topDistance+25+5,bgWidth,size.height+space*2);
    _commentLabel.frame = CGRectMake(space,space,commentWidth,size.height);
    _commentLabel.text = obj.content;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
