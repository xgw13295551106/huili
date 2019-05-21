//
//  OrderPayListTableViewCell.m
//  YeFu
//
//  Created by Carl on 2017/12/19.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "OrderPayListTableViewCell.h"

@interface OrderPayListTableViewCell ()
@property(nonatomic,weak)UIImageView *img;
@property(nonatomic,weak)UILabel *name;
@property(nonatomic,weak)UILabel *goods_des;
@property(nonatomic,weak)UILabel *goods_spec;
@property(nonatomic,weak)UILabel *price;
@property(nonatomic,weak)UILabel *amount;

@end

@implementation OrderPayListTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 90, 90)];
        [img setImage:DefaultsImg];
        [img setContentMode:UIViewContentModeScaleAspectFill];
        [img.layer setMasksToBounds:YES];
        [self addSubview:img];
        _img=img;
        
        UILabel *name=[[UILabel alloc]initWithFrame:CGRectMake(img.right+10, 10, AL_DEVICE_WIDTH-(img.right+120), 30)];
        [name setTextColor:text1Color];
        [name setFont:[UIFont boldSystemFontOfSize:18]];
        [self addSubview:name];
        _name=name;
        
        UILabel *goods_des=[[UILabel alloc]initWithFrame:CGRectMake(img.right+10, name.bottom, AL_DEVICE_WIDTH-(img.right+120), 30)];
        [goods_des setTextColor:text2Color];
        [goods_des setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:goods_des];
        _goods_des=goods_des;
        
        UILabel *goods_spec=[[UILabel alloc]initWithFrame:CGRectMake(img.right+10, goods_des.bottom, AL_DEVICE_WIDTH-(img.right+120), 30)];
        [goods_spec setBackgroundColor:[UIColor colorWithHexString:@"f4f4f4"]];
        [goods_spec setTextAlignment:NSTextAlignmentCenter];
        [goods_spec setTextColor:text2Color];
        [goods_spec setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:goods_spec];
        [goods_spec sizeToFit];
        [goods_spec setFrame:CGRectMake(img.right+10, goods_des.bottom, goods_spec.width+10, 30)];
        _goods_spec=goods_spec;
        
        UILabel *price=[[UILabel alloc]initWithFrame:CGRectMake(AL_DEVICE_WIDTH-110,35 , 110, 20)];
        [price setTextColor:text1Color];
        [price setFont:[UIFont systemFontOfSize:16]];
        [price setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:price];
        _price=price;
        
        UILabel *amount=[[UILabel alloc]initWithFrame:CGRectMake(AL_DEVICE_WIDTH-110,price.bottom , 110, 20)];
        [amount setTextColor:text2Color];
        [amount setFont:[UIFont systemFontOfSize:15]];
        [amount setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:amount];
        _amount=amount;
        
    }
    return self;
}

-(void)setModel:(GoodsModel *)model{
    _model=model;
    [_img sd_setImageWithURL:[NSURL URLWithString:_model.goods_img] placeholderImage:DefaultsImg];
    [_name setText:_model.goods_name];
    [_goods_des setText:_model.goods_des];
    [_goods_spec setText:_model.goods_spec];
    
    [_goods_spec sizeToFit];
    [_goods_spec setFrame:CGRectMake(_img.right+10, _goods_des.bottom, _goods_spec.width+10, 30)];
    [_price setText:[NSString stringWithFormat:@"¥%@",model.goods_price]];
    [_amount setText:[NSString stringWithFormat:@"x%d",model.goods_ammount]];
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
