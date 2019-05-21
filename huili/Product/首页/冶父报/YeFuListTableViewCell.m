//
//  YeFuListTableViewCell.m
//  YeFu
//
//  Created by Carl on 2017/12/14.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "YeFuListTableViewCell.h"
#import "ShareView.h"

@interface YeFuListTableViewCell ()

@property(nonatomic,weak)UILabel *title;

@property(nonatomic,weak)UILabel *typeAndTime;

@property(nonatomic,weak)UIButton *look;

@property(nonatomic,weak)UIImageView *img;

@end

@implementation YeFuListTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, AL_DEVICE_WIDTH-120, 50)];
        [title setFont:[UIFont boldSystemFontOfSize:18]];
        [title setTextColor:text1Color];
        [title setNumberOfLines:2];
        [self addSubview:title];
        _title=title;
        
        UILabel *typeAndTime=[[UILabel alloc]initWithFrame:CGRectMake(10, 50, 200,25 )];
        [typeAndTime setTextColor:text2Color];
        [typeAndTime setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:typeAndTime];
        _typeAndTime=typeAndTime;
        
        UIButton *shareBtn=[[UIButton alloc]initWithFrame:CGRectMake(AL_DEVICE_WIDTH-160, typeAndTime.y, 50, 25)];
        [shareBtn setImage:[UIImage imageNamed:@"home_icon_share"] forState:UIControlStateNormal];
        [shareBtn setTitle:@" 分享" forState:UIControlStateNormal];
        [shareBtn setTitleColor:STYLECOLOR forState:UIControlStateNormal];
        [shareBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:shareBtn];
        [shareBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *look=[[UIButton alloc]initWithFrame:CGRectMake(shareBtn.left-50, typeAndTime.y, 50, 25)];
        [look setImage:[UIImage imageNamed:@"home_icon_check"] forState:UIControlStateNormal];
        [look setTitleColor:text2Color forState:UIControlStateNormal];
        [look.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:look];
        _look=look;
        
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(AL_DEVICE_WIDTH-110, 5, 100, 65)];
        [img setImage:DefaultsImg];
        [self addSubview:img];
        [img.layer setMasksToBounds:YES];
        [img setContentMode:UIViewContentModeScaleAspectFill];
        _img=img;
    }
    return self;
}

-(void)setModel:(YeFuListModel *)model{
    _model=model;
    [_title setText:model.title];
    [_typeAndTime setText:[NSString stringWithFormat:@"%@ %@",model.cat_name,model.created_at]];
    [_look setTitle:[NSString stringWithFormat:@" %@",model.count] forState:UIControlStateNormal];
    [_img sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:DefaultsImg];
}

-(void)shareClick{
    [[ShareView ShareViewClient] shareClick:_model.url setTitle:_model.title setContent:_model.cat_name setIcon:_model.img];
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
