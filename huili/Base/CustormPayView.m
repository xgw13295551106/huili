//
//  CustormPayView.m
//  YeFu
//
//  Created by zhongweike on 2017/12/16.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "CustormPayView.h"

@interface CustormPayView ()<UIGestureRecognizerDelegate>{
    UIView *payView;       ///< 支付背景view

    UIButton *purseButton;  //钱包button
    UIButton *alipayButton;  //支付宝button
    UIButton *wechatButton;  //微信button
    UIButton *confirmButotn;  //立即支付
    CustormPayType payType;   //当前选中的payType
    
    CGFloat self_width;
    CGFloat self_height;
}
@property (nonatomic,strong)CustormPayBlock payBlock;

@end

static CustormPayView *custormPayView = nil;

@implementation CustormPayView

+ (instancetype)defaultCustormPayView{
    if (custormPayView == nil) {
        CGFloat iPhoneX_bottomH = KIsiPhoneX?34:0;
        custormPayView = [[CustormPayView alloc]initWithFrame:CGRectMake(0, 0, win_width, win_height-iPhoneX_bottomH)];
        [custormPayView setBackgroundColor:[UIColor colorWithHexString:@"000000" alpha:0.7]];
    }
    return custormPayView;
}

+ (void)dismiss{
    [custormPayView removeView];
}

+ (instancetype)shareCustormPayView:(CustormPayBlock)payBlock{
    custormPayView = [CustormPayView defaultCustormPayView];
    custormPayView.payBlock = payBlock;
    [[UIApplication sharedApplication].keyWindow addSubview:custormPayView];
    
    [custormPayView setupShowView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:custormPayView action:@selector(removeView)];
    tap.delegate = custormPayView;
    [custormPayView addGestureRecognizer:tap];
    
    return custormPayView;
}

- (void)setupShowView{
    self_width = custormPayView.width;
    self_height = custormPayView.height;
    
    //支付框
    CGFloat payView_h = 260;
    payView = [[UIView alloc]initWithFrame:CGRectMake(0, self_height-payView_h, self_width, payView_h)];
    [payView setBackgroundColor:[UIColor whiteColor]];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self addSubview:payView];
    }];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, self_width, 22)];
    titleLabel.textColor = [UIColor colorWithHexString:@"选择支付方式"];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.text = @"选择支付方式";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [payView addSubview:titleLabel];
    
    //通用坐标布局
    CGFloat leftImgView_x = 20;
    CGFloat leftImgView_w = 26;
    CGFloat leftImgView_h = leftImgView_w;
    CGFloat typeLabel_w = 100;
    CGFloat typeLabel_h = leftImgView_h;
    CGFloat selectButton_w = 22;
    CGFloat selectButton_h = selectButton_w;
    CGFloat selectbutton_x = self_width - 12 -selectButton_w;
    
    //---------------钱包支付------------------//
    //余额支付的左侧image
    UIImageView *leftImgView1 = [self setLeftImgViewWithFrame:CGRectMake(leftImgView_x, titleLabel.maxY+20, leftImgView_w, leftImgView_h) andImage:[UIImage imageNamed:@"user_vip_recharge_pocket"]];
    //余额支付label
    CGFloat typeLabel_x = CGRectGetMaxX(leftImgView1.frame) +15;
    UILabel *purseLabel = [self setTypeLabelWithFrame:CGRectMake(typeLabel_x, leftImgView1.y, 70, typeLabel_h) andText:@"钱包支付"];
    //余额支付button
    CGFloat purseButton_y = leftImgView1.center.y - selectButton_h/2;
    purseButton = [self setSelectButtonWith:CGRectMake(selectbutton_x,purseButton_y , selectButton_w, selectButton_h) andTag:PursePayType];
    //显示用户余额的label
    CGFloat balanceLabel_x = purseLabel.maxX+8;
    CGFloat balanceLabel_w = purseButton.minX-8 -balanceLabel_x;
    UILabel *balanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(balanceLabel_x, purseLabel.minY, balanceLabel_w, purseLabel.height)];
    balanceLabel.textColor = [UIColor colorWithHexString:@"858685"];
    balanceLabel.font = [UIFont systemFontOfSize:13];
    balanceLabel.text = [NSString stringWithFormat:@"余额%@",[UserInfoManager currentUser].balance];
    [payView addSubview:balanceLabel];
    //当余额为0时执行特殊操作
    if ([UserInfoManager currentUser].balance.floatValue == 0) {
        leftImgView1.image = [UIImage imageNamed:@"user_vip_recharge_pocket"];
//        purseButton.hidden = YES;
    }else{
        leftImgView1.image = [UIImage imageNamed:@"user_vip_recharge_pocket"];
//        purseButton.hidden = NO;
    }
    
    //分割线1
    UIView *divideView1 = [self setDivideViewWithFrame:CGRectMake(0, CGRectGetMaxY(leftImgView1.frame)+15, self_width, 1)];
    //---------------支付宝支付------------------//
    //支付宝支付左侧image
    UIImageView *leftImgView2 = [self setLeftImgViewWithFrame:CGRectMake(leftImgView_x, divideView1.maxY+10, leftImgView_w, leftImgView_h) andImage:[UIImage imageNamed:@"user_vip_recharge_alipay"]];
    //支付宝支付label
    [self setTypeLabelWithFrame:CGRectMake(typeLabel_x, leftImgView2.origin.y, typeLabel_w,typeLabel_h ) andText:@"支付宝支付"];
    //支付宝选中button
    CGFloat alipayButton_y = leftImgView2.center.y - selectButton_h/2;
    alipayButton = [self setSelectButtonWith:CGRectMake(selectbutton_x, alipayButton_y, selectButton_w, selectButton_h) andTag:AlipayType];
    
    //分割线2
    UIView *divideView2 = [self setDivideViewWithFrame:CGRectMake(0, CGRectGetMaxY(leftImgView2.frame)+10, win_width, 1)];
    //---------------微信支付------------------//
    //微信支付左侧image
    UIImageView *leftImgView3 = [self setLeftImgViewWithFrame:CGRectMake(leftImgView_x, divideView2.maxY+10, leftImgView_w, leftImgView_h) andImage:[UIImage imageNamed:@"user_vip_recharge_wechat"]];
    //微信支付label
    [self setTypeLabelWithFrame:CGRectMake(typeLabel_x, leftImgView3.origin.y, typeLabel_w, typeLabel_h) andText:@"微信支付"];
    //微信支付button
    CGFloat wechatButton_y = leftImgView3.center.y - selectButton_h/2;
    wechatButton = [self setSelectButtonWith:CGRectMake(selectbutton_x, wechatButton_y, selectButton_w, selectButton_h) andTag:WechatPayType];
    
    
    //立即支付
    confirmButotn = [UIButton buttonWithType:UIButtonTypeSystem];
    [confirmButotn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButotn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButotn setBackgroundColor:STYLECOLOR];
    [confirmButotn setFrame:CGRectMake(0, payView_h-44, self_width, 44)];
    [confirmButotn addTarget:self action:@selector(confirmPayAction:) forControlEvents:UIControlEventTouchUpInside];
    [payView addSubview:confirmButotn];
    
    NSLog(@"%f",CGRectGetMaxY(confirmButotn.frame)+10);
    
    //设置默认支付方式
    payType = PursePayType;
    purseButton.selected = YES;
    alipayButton.selected = NO;
    wechatButton.selected = NO;
    
    
}


/**
 添加分割线
 
 @param frame 分割线的frame
 @return 分割线view
 */
- (UIView *)setDivideViewWithFrame:(CGRect)frame{
    UIView *divideView = [[UIView alloc]initWithFrame:frame];
    [divideView setBackgroundColor:[UIColor colorWithHexString:@"E4E3E5"]];
    [payView addSubview:divideView];
    return divideView;
}

/**
 添加左侧imageview
 
 @param frame imageView 的frame
 @return leftImageView
 */
- (UIImageView *)setLeftImgViewWithFrame:(CGRect)frame andImage:(UIImage *)image{
    UIImageView *leftImgView = [[UIImageView alloc]initWithFrame:frame];
    [leftImgView setImage:image];
    leftImgView.contentMode  = UIViewContentModeCenter;
    [payView addSubview:leftImgView];
    return leftImgView;
}

/**
 添加支付类型label
 
 @param frame label的frame
 @return label
 */
- (UILabel *)setTypeLabelWithFrame:(CGRect)frame andText:(NSString *)text{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithHexString:@"666766"];
    label.text = text;
    //    [label sizeToFit];
    [payView addSubview:label];
    return label;
}

/**
 添加勾选button
 
 @param frame button的frame
 @return button
 */
- (UIButton *)setSelectButtonWith:(CGRect)frame andTag:(CustormPayType)payType{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    button.tag = payType;
    [button setImage:[UIImage imageNamed:@"user_vip_recharge_unselect"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"user_vip_recharge_select"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(touchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [payView addSubview:button];
    return button;
}

#pragma mark Action
//点击选中button触发事件
- (void)touchButtonAction:(UIButton *)button{
    if (button.tag == PursePayType) {
        payType = PursePayType;
        purseButton.selected = YES;
        alipayButton.selected = NO;
        wechatButton.selected = NO;
    }else if (button.tag == AlipayType){
        payType = AlipayType;
        purseButton.selected = NO;
        wechatButton.selected = NO;
        alipayButton.selected = YES;
    }else{
        payType = WechatPayType;
        purseButton.selected = NO;
        alipayButton.selected = NO;
        wechatButton.selected = YES;
    }
}


- (void)confirmPayAction:(UIButton *)button{
    if (self.payBlock && payType) {
        self.payBlock(payType,button);
    }else{
        [self makeToast:@"未选择支付方式" duration:1.2 position:CSToastPositionBottom];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    //屏蔽shareView的子视图手势事件
    if ([touch.view isDescendantOfView:payView]) {
        return NO;
    }
    
    return YES;
}

- (void)removeView{
    
    [custormPayView removeAllSubviews];
    [custormPayView removeFromSuperview];
    payView = nil;
    custormPayView = nil;
}


@end
