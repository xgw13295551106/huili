//
//  MessageListTableViewCell.m
//  YeFu
//
//  Created by Carl on 2017/12/8.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "MessageListTableViewCell.h"

@interface MessageListTableViewCell ()

@property (nonatomic,weak)UIImageView *img;
@property (nonatomic,weak)UILabel *time;
@property (nonatomic,weak)UILabel *title;

@end

@implementation MessageListTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *bg=[[UIView alloc]initWithFrame:CGRectMake(10, 0, AL_DEVICE_WIDTH-20, 180)];
        [bg.layer setBorderWidth:1];
        [bg.layer setBorderColor:[LineColor CGColor]];
        [bg setBackgroundColor:[UIColor whiteColor]];
        [bg.layer setCornerRadius:5];
        [bg.layer setMasksToBounds:YES];
        [self addSubview:bg];
        
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bg.width, 140)];
        [img setImage:DefaultsImg];
        _img=img;
        [img.layer setMasksToBounds:YES];
        [img setContentMode:UIViewContentModeScaleAspectFill];
        [bg addSubview:img];
        
        UILabel *time=[[UILabel alloc]initWithFrame:CGRectMake(bg.width-120, 140, 90, 40)];
        _time=time;
        [time setTextColor:text2Color];
        [bg addSubview:time];
        [time setFont:[UIFont systemFontOfSize:14]];
        [time setTextAlignment:NSTextAlignmentRight];
        
        UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(10, 140, bg.width-140, 40)];
        _title=title;
        [title setTextColor:text1Color];
        [bg addSubview:title];
        [title setFont:[UIFont systemFontOfSize:14]];
        
        UIImageView *row=[[UIImageView alloc]initWithFrame:CGRectMake(bg.width-30, 140, 30, 40)];
        [row setImage:[UIImage imageNamed:@"next"]];
        [row setContentMode:UIViewContentModeCenter];
        [bg addSubview:row];
    }
    return self;
}

-(void)setModel:(MessageModel *)model{
    _model=model;
    [_img sd_setImageWithURL:[NSURL URLWithString:_model.img] placeholderImage:DefaultsImg];
    [_time setText:_model.time];
    [_title setText:_model.title];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
