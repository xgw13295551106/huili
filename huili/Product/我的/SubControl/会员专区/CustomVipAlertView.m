//
//  CustomVipAlertView.m
//  huili
//
//  Created by zhongweike on 2018/1/18.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import "CustomVipAlertView.h"

@interface CustomVipAlertView (){
    UILabel *leftLabel1;       ///< 铜牌会员
    UILabel *leftLabel2;       ///< 银牌会员
    UILabel *leftLabel3;       ///< 金牌会员
    UILabel *leftLabel4;       ///< 钻石会员
    
    UILabel *contentLabel1;    ///< 铜牌会员特权
    UILabel *contentLabel2;    ///< 银牌会员特权
    UILabel *contentLabel3;    ///< 金牌会员特权
    UILabel *contentLabel4;    ///< 钻石会员特权
}

@property (nonatomic,strong)VipAlertBlock closeBlock;


@end

@implementation CustomVipAlertView


+ (instancetype)getCustomVipAlertViewWith:(CGRect)frame{
    CustomVipAlertView *view = [[CustomVipAlertView alloc]initWithFrame:frame];
    
    return view;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.width, 25)];
    titleLabel.textColor = [UIColor colorWithHexString:@"000000"];
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    titleLabel.text = @"会员特权说明";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    //铜牌
    leftLabel1 = [self getLeftLabel:@"铜牌会员:"];
    leftLabel1.minY = titleLabel.maxY+10;
    [self addSubview:leftLabel1];
    
    NSString *string1 = [NSString stringWithFormat:@"享受全场%.f折，盟友消费返积分。",[CommonConfig shared].vip_level1.floatValue *10];
    contentLabel1 = [self getRightLabel:CGPointMake(leftLabel1.maxX+3, leftLabel1.minY) andString:string1];
    [self addSubview:contentLabel1];
    CGSize size1 = [contentLabel1 sizeThatFits:CGSizeMake(self.width-10-contentLabel1.minX, MAXFLOAT)];
    size1.height = size1.height>20?40:20;
    contentLabel1.size = size1;
    
    //银牌
    leftLabel2 = [self getLeftLabel:@"银牌会员:"];
    leftLabel2.minY = contentLabel1.maxY+5;
    [self addSubview:leftLabel2];
    
    NSString *string2 = [NSString stringWithFormat:@"享受全场%.f折，盟友消费返积分。",[CommonConfig shared].vip_level2.floatValue *10];
    contentLabel2 = [self getRightLabel:CGPointMake(contentLabel1.minX, leftLabel2.minY) andString:string2];
    [self addSubview:contentLabel2];
    CGSize size2 = [contentLabel2 sizeThatFits:CGSizeMake(self.width-10-contentLabel2.minX, MAXFLOAT)];
    size2.height = size2.height>20?40:20;
    contentLabel2.size = size2;
    
    //金牌
    leftLabel3 = [self getLeftLabel:@"金牌会员:"];
    leftLabel3.minY = contentLabel2.maxY+5;
    [self addSubview:leftLabel3];
    
    NSString *string3 = [NSString stringWithFormat:@"享受全场%.f折，盟友消费返积分。",[CommonConfig shared].vip_level3.floatValue *10];
    contentLabel3 = [self getRightLabel:CGPointMake(contentLabel1.minX, leftLabel3.minY) andString:string3];
    [self addSubview:contentLabel3];
    CGSize size3 = [contentLabel3 sizeThatFits:CGSizeMake(self.width-10-contentLabel3.minX, MAXFLOAT)];
    size3.height = size3.height>20?40:20;
    contentLabel3.size = size3;
    
    //钻石
    leftLabel4 = [self getLeftLabel:@"钻石会员:"];
    leftLabel4.minY = contentLabel3.maxY+5;
    [self addSubview:leftLabel4];
    
    NSString *string4 = [NSString stringWithFormat:@"享受全场%.f折，盟友消费返积分。",[CommonConfig shared].vip_level4.floatValue *10];
    contentLabel4 = [self getRightLabel:CGPointMake(contentLabel1.minX, leftLabel4.minY) andString:string4];
    [self addSubview:contentLabel4];
    CGSize size4 = [contentLabel4 sizeThatFits:CGSizeMake(self.width-10-contentLabel4.minX, MAXFLOAT)];
    size4.height = size4.height>20?40:20;
    contentLabel4.size = size4;
    
    //关闭button
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(0, contentLabel4.maxY+25, self.width, 44)];
    [closeButton setTitle:@"确定" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [closeButton setBackgroundColor:STYLECOLOR];
    [closeButton addTarget:self action:@selector(clickCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
    self.height = closeButton.maxY;
    
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
}

- (UILabel *)getLeftLabel:(NSString *)titleString{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 80, 20)];
    label.textColor = [UIColor colorWithHexString:@"252529"];
    label.font = [UIFont systemFontOfSize:14];
    label.text = titleString;
    label.textAlignment = NSTextAlignmentLeft;
    
    return label;
}

- (UILabel *)getRightLabel:(CGPoint)point andString:(NSString *)text{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.origin = point;
    label.textColor = [UIColor colorWithHexString:@"26262A"];
    label.font = [UIFont systemFontOfSize:14];
    label.text = text;
    label.numberOfLines = 2;;
    
    return label;
}


- (void)setCloseBlock:(VipAlertBlock)closeBlock{
    _closeBlock = closeBlock;
}

- (void)clickCloseButton:(UIButton *)button{
    if (self.closeBlock) {
        self.closeBlock();
    }
}

@end
