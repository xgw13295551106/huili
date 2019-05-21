//
//  GoodsTableViewCell.m
//  YeFu
//
//  Created by Carl on 2017/12/4.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "GoodsTableViewCell.h"
#import "ProgressView.h"

@interface GoodsTableViewCell ()
@property(nonatomic,weak)UIImageView *img;
@property(nonatomic,weak)UILabel *name;
@property(nonatomic,weak)UILabel *goods_price;

@property(nonatomic,weak)ProgressView *progressView;

@property(nonatomic,weak)UILabel *super_price;
@property(nonatomic,weak)UIView *line;
@property(nonatomic,weak)UIButton *progressBtn;
@property (nonatomic,strong)UIImageView *signImgView;

@end

@implementation GoodsTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(10*PROPORTION, 15*PROPORTION, 100*PROPORTION, 100*PROPORTION)];
        [img setImage:DefaultsImg];
        [img setContentMode:UIViewContentModeScaleAspectFill];
        [img.layer setMasksToBounds:YES];
        [self addSubview:img];
        _img=img;
        
        UILabel *name=[[UILabel alloc]initWithFrame:CGRectMake(img.right+10*PROPORTION, 10*PROPORTION, AL_DEVICE_WIDTH-(img.right+20*PROPORTION), 50*PROPORTION)];
        [name setTextColor:text1Color];
        [name setNumberOfLines:2];
        [name setFont:[UIFont boldSystemFontOfSize:15*PROPORTION]];
        [self addSubview:name];
        _name=name;
        
        UILabel *goods_price=[[UILabel alloc]initWithFrame:CGRectMake(img.right+10, name.bottom+10, AL_DEVICE_WIDTH-(img.right+20*PROPORTION), 30*PROPORTION)];
        [goods_price setTextColor:[UIColor colorWithHexString:@"f23030"]];
        [goods_price setFont:[UIFont boldSystemFontOfSize:18]];
        [self addSubview:goods_price];
        _goods_price=goods_price;
        
       
        ProgressView *progressView=[[ProgressView alloc]initWithFrame:CGRectMake(AL_DEVICE_WIDTH-125, 130*PROPORTION-20, 115, 20)];
        [progressView setPresent:0.5];
        [self addSubview:progressView];
        _progressView=progressView;
        [progressView setHidden:YES];
        
        UIButton *progressBtn=[[UIButton alloc]initWithFrame:CGRectMake(progressView.x+40, progressView.top-30, progressView.width-40,25)];
        _progressBtn=progressBtn;
        [progressBtn setHidden:YES];
        [progressBtn setBackgroundColor:STYLECOLOR];
        [progressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [progressBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        [progressBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [progressBtn.layer setCornerRadius:12.5];
        [progressBtn.layer setMasksToBounds:YES];
        [self addSubview:progressBtn];
        progressBtn.userInteractionEnabled = NO;
        
        
        UILabel *super_price=[[UILabel alloc]initWithFrame:CGRectMake(_goods_price.x, _goods_price.bottom, 140, 20*PROPORTION)];
        [super_price setFont:[UIFont systemFontOfSize:14]];
        [super_price setTextColor:[UIColor blackColor]];
        [self addSubview:super_price];
        _super_price=super_price;
        [super_price setFrame:CGRectMake(_goods_price.x, _goods_price.bottom, super_price.width, 20*PROPORTION)];
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 10*PROPORTION, super_price.width, 2)];
        [line setBackgroundColor:LineColor];
        [super_price addSubview:line];
        _line=line;
        [super_price setHidden:YES];
        [line setHidden:YES];
        
        UIImage *vipImage = [UIImage imageNamed:@"commodity_button_label"];
        _signImgView = [[UIImageView alloc]initWithFrame:CGRectMake(_super_price.maxX+2, _signImgView.minY, vipImage.size.width, vipImage.size.height)];
        [_signImgView setImage:vipImage];
        [self addSubview:_signImgView];
        
    }
    return self;
}

-(void)setIs_new:(NSString *)is_new{
    if ([is_new isEqualToString:@"1"]) {
        [_progressView setHidden:NO];
        [_progressBtn setHidden:NO];
    }else{
        [_progressView setHidden:YES];
    }
}

-(void)setIs_special:(NSString *)is_special{
    _is_special=is_special;
    if ([is_special isEqualToString:@"1"]) {
        [_progressBtn setHidden:NO];
        [_goods_price setFrame:CGRectMake(_img.right+10, _name.bottom, AL_DEVICE_WIDTH-(_img.right+20*PROPORTION), 25*PROPORTION)];
        [_super_price sizeToFit];
        [_super_price setFrame:CGRectMake(_goods_price.x, _goods_price.bottom, _super_price.width, 25*PROPORTION)];
        [_line setFrame:CGRectMake(0, 12.5*PROPORTION, _super_price.width, 2)];
        [_super_price setHidden:NO];
        [_line setHidden:NO];
    }else{
        [_goods_price setFrame:CGRectMake(_img.right+10, _name.bottom+10, AL_DEVICE_WIDTH-(_img.right+20*PROPORTION), 30*PROPORTION)];
        [_super_price setHidden:YES];
        [_line setHidden:YES];
    }
}

-(void)setModel:(GoodsModel *)model{
    _model=model;
    [_img sd_setImageWithURL:[NSURL URLWithString:_model.goods_img] placeholderImage:DefaultsImg];
    [_name setText:_model.goods_name];
    [_goods_price setText:[NSString stringWithFormat:@"￥%@",_model.price]];
    [_goods_price sizeToFit];
    _goods_price.size = CGSizeMake(_goods_price.width, 30*PROPORTION);
    
    [_img setFrame:CGRectMake(10*PROPORTION, 15*PROPORTION, 100*PROPORTION, 100*PROPORTION)];
    [self checkFram];
    //[_progressView setPresent:[_model.percent floatValue]];
    [_super_price setText:[NSString stringWithFormat:@"￥%@",_model.super_price]];
    [_super_price sizeToFit];
    [_super_price setFrame:CGRectMake(_goods_price.maxX+5, _goods_price.minY, _super_price.width, _goods_price.height)];
    [_super_price setHidden:NO];
    _signImgView.minX = _super_price.maxX+2;
    _signImgView.centerY = _super_price.centerY;
}

- (void)setIs_collect:(BOOL)is_collect{
    _is_collect = is_collect;
    
    _super_price.hidden = is_collect;
    _signImgView.hidden = is_collect;
}


-(void)checkFram{
    [_name setFrame:CGRectMake(_img.right+10*PROPORTION, 15*PROPORTION, AL_DEVICE_WIDTH-(_img.right+20*PROPORTION), 50*PROPORTION)];
    [_goods_price setFrame:CGRectMake(_img.right+10, _name.bottom+15, _goods_price.width, 30*PROPORTION)];
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
