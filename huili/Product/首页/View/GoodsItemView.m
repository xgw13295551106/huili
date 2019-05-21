//
//  GoodItemView.m
//  yihuo
//
//  Created by zhongweike on 2017/12/26.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "GoodsItemView.h"

@interface GoodsItemView (){
    UIImageView *topImgView;
    UILabel *nameLabel;
    UILabel *coinLabel;
}


@end

@implementation GoodsItemView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        CGFloat img_width = self.width -5*2;
        topImgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, img_width, img_width)];
        [self addSubview:topImgView];
        
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(topImgView.minX, topImgView.maxY+5, topImgView.width, 32)];
        nameLabel.textColor = [UIColor colorWithHexString:@"797A79"];
        nameLabel.font = [UIFont systemFontOfSize:13];
        nameLabel.numberOfLines = 2;
        [self addSubview:nameLabel];
        
        coinLabel = [[UILabel alloc]initWithFrame:CGRectMake(topImgView.minX, nameLabel.maxY+3, nameLabel.width, 20)];
        coinLabel.textColor = [UIColor colorWithHexString:@"F23232"];
        coinLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:coinLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickSelf)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setInfoDic:(NSDictionary *)infoDic{
    _infoDic = infoDic;
    //{id,name,price,img}
    [topImgView sd_setImageWithURL:[NSURL URLWithString:[infoDic stringForKey:@"img"]] placeholderImage:DefaultsImg];
    nameLabel.text = [infoDic stringForKey:@"name"];
    float coin = [infoDic[@"price"] floatValue];
    coinLabel.text = [NSString stringWithFormat:@"￥%.2f",coin];
}


- (void)clickSelf{
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchGoodsItemView:)]) {
        [self.delegate touchGoodsItemView:self.infoDic];
    }
}


@end
