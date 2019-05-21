//
//  LCWuliuHeadView.m
//  huili
//
//  Created by zhongweike on 2018/1/12.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import "LCWuliuHeadView.h"

@interface LCWuliuHeadView (){
    UIImageView *leftImgView;
    UILabel *statusLabel;   ///< 物流状态
    UILabel *sourceLabel;   ///< 承运来源
    UILabel *numLabel;      ///< 运单编号
    UILabel *phoneLabel;    ///< 官方电话
}


@end

@implementation LCWuliuHeadView

+ (instancetype)getWuliuHeadView:(CGRect)frame andDic:(NSDictionary *)dic{
    LCWuliuHeadView *headView = [[LCWuliuHeadView alloc]initWithFrame:frame];
    [headView setInfoWithDic:dic];
    
    return headView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    //物流图片
    CGFloat leftImgView_h = self.height-2*10;
    leftImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, leftImgView_h, leftImgView_h)];
    [self addSubview:leftImgView];
    
    //物流状态
    statusLabel = [self getWuliuLabelWith:leftImgView.minY];
    statusLabel.height = 20;
    [self addSubview:statusLabel];
    
    //承运来源
    sourceLabel = [self getWuliuLabelWith:statusLabel.maxY+2];
    [self addSubview:sourceLabel];
    
    //运单编号
    numLabel = [self getWuliuLabelWith:sourceLabel.maxY+2];
    [self addSubview:numLabel];
    
    //官方电话
    phoneLabel = [self getWuliuLabelWith:numLabel.maxY +2];
    [self addSubview:phoneLabel];
    
}



- (void)setInfoWithDic:(NSDictionary *)infoDic{
    statusLabel.attributedText = [self setAttributedStringStyleWithFirst:@"在途中" andColor:[UIColor colorWithHexString:@"23B411"]];
    sourceLabel.text = [NSString stringWithFormat:@"承运来源： %@",[infoDic stringForKey:@"expTextName"]];
    numLabel.text = [NSString stringWithFormat:@"物流编号：%@",[infoDic stringForKey:@"mailNo"]];
    phoneLabel.text = [NSString stringWithFormat:@"官方电话： %@",[infoDic stringForKey:@"tel"]];
    
}

- (void)setOrder_goods_img:(NSString *)order_goods_img
{
    _order_goods_img = order_goods_img;
    [leftImgView sd_setImageWithURL:[NSURL URLWithString:_order_goods_img] placeholderImage:DefaultsImg];
}


- (UILabel *)getWuliuLabelWith:(CGFloat)minY{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(leftImgView.maxX+8, minY, self.width-8-(leftImgView.maxX+8), 18)];
    label.textColor = [UIColor colorWithHexString:@"91939D"];
    label.font = [UIFont systemFontOfSize:13];

    return label;
}

/**
 创建富文本对象并返回
 
 @param string1 第一段文字
 @return 返回创建好的富文本
 */
- (NSMutableAttributedString *)setAttributedStringStyleWithFirst:(NSString *)string1 andColor:(UIColor *)statusColor;
{
    NSString *title = @"物流状态  ";
    NSString *first_string = [NSString stringWithFormat:@"%@",string1];
    NSString *totalString = [NSString stringWithFormat:@"%@%@", title,first_string];
    //找到各个string在总字符串中的位置
    NSRange title_range = [totalString rangeOfString:title];
    NSRange first_range = [totalString rangeOfString:first_string];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:totalString];
    //物流状态
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:title_range];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:title_range];
    //金额的格式
    [str addAttribute:NSForegroundColorAttributeName value:statusColor range:first_range];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:first_range];
    
    return str;
}

@end
