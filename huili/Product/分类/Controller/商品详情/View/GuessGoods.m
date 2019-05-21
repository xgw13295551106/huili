//
//  GuessGoods.m
//  YeFu
//
//  Created by Carl on 2017/12/18.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "GuessGoods.h"

@interface GuessGoods ()

@property(nonatomic,weak)UIImageView *goodsImg;

@property(nonatomic,weak)UILabel *goodsName;

@property(nonatomic,weak)UILabel *price;

@end

@implementation GuessGoods

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        UIImageView *goodsImg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, self.width-20, self.height-80)];
        _goodsImg=goodsImg;
        [goodsImg setImage:DefaultsImg];
        [goodsImg setContentMode:UIViewContentModeScaleAspectFill];
        [goodsImg.layer setMasksToBounds:YES];
        [self addSubview:goodsImg];
        UILabel *goodsName=[[UILabel alloc]initWithFrame:CGRectMake(10, goodsImg.bottom, self.width-20, 40)];
        _goodsName=goodsName;
        [goodsName setFont:[UIFont boldSystemFontOfSize:16]];
        [goodsName setTextColor:text1Color];
        [goodsName setNumberOfLines:2];
        [self addSubview:goodsName];
        
        UILabel *price=[[UILabel alloc]initWithFrame:CGRectMake(10, goodsName.bottom, self.width-20, 30)];
        [price setTextColor:[UIColor colorWithHexString:@"f23030"]];
        [price setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:price];
        _price=price;
    }
    return self;
}

-(void)setModel:(GoodsModel *)model{
    [_goodsImg sd_setImageWithURL:[NSURL URLWithString:model.goods_img] placeholderImage:DefaultsImg];
    [_goodsName setText:model.goods_name];
    [_price setText:[NSString stringWithFormat:@"¥%@",model.goods_price]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
