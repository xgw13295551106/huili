//
//  PayButtonView.m
//  ConvenienceStore
//
//  Created by Carl on 2017/10/17.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "PayButtonView.h"

@interface PayButtonView ()

@property(nonatomic,weak)UIImageView *icon;

@property(nonatomic,weak)UILabel *payTitle;

@end

@implementation PayButtonView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        UIImageView *icon=[[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 40, 60)];
        [icon setContentMode:UIViewContentModeCenter];
        [self addSubview:icon];
        _icon=icon;
        
        UILabel *payTitle=[[UILabel alloc]initWithFrame:CGRectMake(icon.right, 0, AL_DEVICE_WIDTH-120, 60)];
        [payTitle setAdjustsFontSizeToFitWidth:YES];
        [payTitle setFont:[UIFont systemFontOfSize:16]];
        [payTitle setTextColor:text1Color];
        [self addSubview:payTitle];
        _payTitle=payTitle;
        
        UIImageView *selectImg=[[UIImageView alloc]initWithFrame:CGRectMake(AL_DEVICE_WIDTH-60, 0, 60,60)];
        [selectImg setContentMode:UIViewContentModeCenter];
        [self addSubview:selectImg];
        _selectImg=selectImg;
        
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(15, 59, AL_DEVICE_WIDTH-15, 1)];
        [line setBackgroundColor:LineColor];
        [self addSubview:line];
    }
    return self;
}

-(void)setWay:(int)way{
    _way=way;
    if (way==1) {//支付宝
        [_icon setImage:[UIImage imageNamed:@"zhifubao"]];
        [_payTitle setText:@"支付宝支付"];
        [_selectImg setImage:[UIImage imageNamed:@"weixuanzhong"]];
    }else if(way==2){
        [_icon setImage:[UIImage imageNamed:@"weixin"]];
        [_payTitle setText:@"微信支付"];
        [_selectImg setImage:[UIImage imageNamed:@"weixuanzhong"]];
    }else{
        [_icon setImage:[UIImage imageNamed:@"yu_e"]];
        [_payTitle setText:[NSString stringWithFormat:@"余额支付（可用余额：¥%@）",CurrUserInfo.balance]];
        [_selectImg setImage:[UIImage imageNamed:@"xuanzhong"]];
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
