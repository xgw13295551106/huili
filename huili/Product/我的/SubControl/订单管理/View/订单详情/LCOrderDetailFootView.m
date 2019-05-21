//
//  LCOrderDetailFootView.m
//  yihuo
//
//  Created by zhongweike on 2017/12/26.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "LCOrderDetailFootView.h"
#import "LCMyOrderDetailModel.h"

#define CancelColor     [UIColor colorWithHexString:@"80828E"]   ///< 已取消颜色
#define OtherColor      [UIColor colorWithHexString:@"F13030"]   ///< cell用的灰色

@interface LCOrderDetailFootView (){
    UIView *topView;              ///< 上方金额的view
    UIView *bottomView;           ///< 订单信息的view
    
    UILabel *coinLabel;           ///< 商品总价label
    UILabel *scoreLabel;          ///< 积分抵扣label
    UILabel *payMoneyLabel;       ///< 实付款合计label
    
    UIButton *cancelButton;       ///< 取消button
    UIButton *otherButton;        ///< 付款、收货、取消退款、重新购买、再次购买
    
    UILabel *orderNoLabel;       ///< 订单编号
    UILabel *orderTimeLabel;     ///< 订单创建时间
    UILabel *payTypeLabel;       ///< 支付方式
    
    
    CGFloat self_width;
    CGFloat self_height;
    
}
@property (nonatomic,strong)LCMyOrderDetailModel *model;
@property (nonatomic,strong)OrderDetailFootBlock footBlock;


@end

@implementation LCOrderDetailFootView

+ (instancetype)getOrderDetailFootView:(CGRect)frame andModel:(LCMyOrderDetailModel *)detailModel andBlock:(OrderDetailFootBlock)footBlock{
    LCOrderDetailFootView *footView = [[LCOrderDetailFootView alloc]initWithFrame:frame];
    footView.footBlock = footBlock;
    [footView setInfoWith:detailModel];
    return footView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self_width = frame.size.width;
        self_height = frame.size.height;
        [self setBackgroundColor:[UIColor colorWithHexString:@"F6F7F6"]];
        [self setupControls];
    }
    return self;
}

//初始化view
- (void)setupControls{
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self_width, 220)];
    [topView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:topView];
    
    //集成topView上的控件
    [self setTopViewUI];
    
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, topView.maxY+10, self_width, 80)];
    [bottomView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:bottomView];
    
    //集成bottomView上的控件
    [self setBottomViewUI];
    
    //订单操作button
    otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [otherButton setFrame:CGRectMake(topView.width-10-80, bottomView.maxY+20, 80, 30)];
    [otherButton setTitle:@"去付款" forState:UIControlStateNormal];
    [otherButton setTitleColor:OtherColor forState:UIControlStateNormal];
    otherButton.titleLabel.font = [UIFont systemFontOfSize:14];
    otherButton.layer.cornerRadius = 2;
    otherButton.layer.masksToBounds = YES;
    otherButton.layer.borderColor = [OtherColor CGColor];
    otherButton.layer.borderWidth = 1;
    [self addSubview:otherButton];
    [otherButton addTarget:self action:@selector(clickOtherAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //取消订单button
    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setFrame:CGRectMake(otherButton.minX-20-otherButton.width, otherButton.minY, otherButton.width, otherButton.height)];
    [cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
    [cancelButton setTitleColor:CancelColor forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    cancelButton.layer.cornerRadius = 2;
    cancelButton.layer.masksToBounds = YES;
    cancelButton.layer.borderColor = [CancelColor CGColor];
    cancelButton.layer.borderWidth = 1;
    [self addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(clickCancelAction:) forControlEvents:UIControlEventTouchUpInside];
}

//TODO:集成topview上的控件
- (void)setTopViewUI{
    
    //左侧标题label的大小
    CGFloat label_x = 15;
    CGFloat label_w = topView.width - 2*label_x;
    CGFloat label_h = 20;
    
    //订单号
    orderNoLabel = [self getAboutInfoLabel:CGRectMake(label_x, 10, label_w, label_h) andTextAlignment:NSTextAlignmentLeft andText:@""];
    [topView addSubview:orderNoLabel];
    
    //创建时间
    orderTimeLabel = [self getAboutInfoLabel:CGRectMake(label_x, orderNoLabel.maxY+3, label_w, label_h) andTextAlignment:NSTextAlignmentLeft andText:@""];
    [topView addSubview:orderTimeLabel];
    
    //付款时间
    payTypeLabel = [self getAboutInfoLabel:CGRectMake(label_x, orderTimeLabel.maxY+3, label_w, label_h) andTextAlignment:NSTextAlignmentLeft andText:@""];
    [topView addSubview:payTypeLabel];
    
    topView.height = payTypeLabel.maxY+15;
    
}

//TODO:集成bottomView上的控件
- (void)setBottomViewUI{
    
    //左侧标题label的大小
    CGFloat leftLabel_w = 85;
    CGFloat leftLabel_x = 15;
    CGFloat leftLabel_h = 20;
    
    //右侧信息label的大小
    CGFloat rightLabel_x = leftLabel_x+leftLabel_w+8;
    CGFloat rightLabel_w = topView.width - 10 - rightLabel_x;
    CGFloat rightLabel_h = leftLabel_h;
    
    //商品总价
    UILabel *leftLabel1 = [self getAboutInfoLabel:CGRectMake(leftLabel_x, 10, leftLabel_w, leftLabel_h) andTextAlignment:NSTextAlignmentLeft andText:@"商品总价"];
    [bottomView addSubview:leftLabel1];
    
    coinLabel = [self getAboutInfoLabel:CGRectMake(rightLabel_x, leftLabel1.minY, rightLabel_w, rightLabel_h) andTextAlignment:NSTextAlignmentRight andText:@"￥0"];
    [bottomView addSubview:coinLabel];
    
    UILabel *leftLabel2 = [self getAboutInfoLabel:CGRectMake(leftLabel_x, leftLabel1.maxY+10, leftLabel_w, leftLabel_h) andTextAlignment:NSTextAlignmentLeft andText:@"积分抵扣"];
    [bottomView addSubview:leftLabel2];
    
    scoreLabel = [self getAboutInfoLabel:CGRectMake(rightLabel_x, leftLabel2.minY, rightLabel_w, rightLabel_h) andTextAlignment:NSTextAlignmentRight andText:@"-￥0.00"];
    [bottomView addSubview:scoreLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, scoreLabel.maxY+15, bottomView.width, 1)];
    lineView.backgroundColor = LineColor;
    [bottomView addSubview:lineView];
    
    payMoneyLabel = [self getAboutInfoLabel:CGRectMake(15, lineView.maxY+10, bottomView.width-15*2, 25) andTextAlignment:NSTextAlignmentRight andText:@""];
    [bottomView addSubview:payMoneyLabel];
    
    bottomView.height = payMoneyLabel.maxY+15;
}


//TODO:获取信息相关的小label
- (UILabel *)getAboutInfoLabel:(CGRect)frame andTextAlignment:(NSTextAlignment)textAlignment andText:(NSString *)text{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.textColor = [UIColor colorWithHexString:@"898B96"];
    label.font = [UIFont systemFontOfSize:14];
    label.text = text;
    label.textAlignment = textAlignment;
    
    return label;
}


//TODO:获取订单总价的label
- (UILabel *)getOrderPriceLabel:(CGRect)frame andTextAlignment:(NSTextAlignment)textAlignment andText:(NSString *)text{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.textColor = [UIColor colorWithHexString:@"242428"];
    label.font = [UIFont systemFontOfSize:14];
    label.text = text;
    label.textAlignment = textAlignment;
    
    return label;
}
//赋值更新view
- (void)setInfoWith:(LCMyOrderDetailModel *)detailModel{
    _model = detailModel;
    
    orderNoLabel.text = [NSString stringWithFormat:@"订单编号：%@",detailModel.order_sn];
    orderTimeLabel.text = [NSString stringWithFormat:@"下单时间：%@",detailModel.created_at];
    NSString *payType = @"";
    if (detailModel.pay_type.intValue == 1) {
        payType = @"支付宝支付";
    }else if (detailModel.pay_type.intValue == 2){
        payType = @"微信支付";
    }else{
        payType = @"钱包支付";
    }
    payTypeLabel.text = [NSString stringWithFormat:@"支付方式：%@",payType];
    
    //----------------订单时间view相关--------------//
    bottomView.minY = topView.maxY+10;
    coinLabel.text = [NSString stringWithFormat:@"￥%@",detailModel.amount];
    scoreLabel.text = [NSString stringWithFormat:@"-￥%@",detailModel.integral_money];
    payMoneyLabel.attributedText = [self setAttributedStringStyleWithFirst:detailModel.pay_amount];
    
    self.height = bottomView.maxY;
    
    cancelButton.hidden = YES;
    otherButton.hidden = YES;
    [cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
    cancelButton.maxX = otherButton.minX - 10;
    if (detailModel.order_status.intValue == 0) {//待支付，显示支付和取消button
        cancelButton.hidden = NO;
        otherButton.hidden = NO;
        [otherButton setTitle:@"去付款" forState:UIControlStateNormal];
    }else if (detailModel.order_status.intValue == 1){
        cancelButton.hidden = NO;
        cancelButton.origin = otherButton.origin;
    }else if (detailModel.order_status.intValue == 2){//待收货
        otherButton.hidden = NO;
        cancelButton.hidden = NO;
        [cancelButton setTitle:@"查看物流" forState:UIControlStateNormal];
        [otherButton setTitle:@"确认收货" forState:UIControlStateNormal];
    }else if (detailModel.order_status.intValue == 3){//已完成
        otherButton.hidden = NO;
        [cancelButton setTitle:@"申请售后" forState:UIControlStateNormal];
        [otherButton setTitle:@"再次购买" forState:UIControlStateNormal];
    }else if (detailModel.order_status.intValue == 5){//售后方面
        if (detailModel.back_status.intValue == 0) {
            otherButton.hidden = YES;
            [otherButton setTitle:@"取消退款" forState:UIControlStateNormal];
        }else if (detailModel.back_status.intValue == 1){//退款成功
            otherButton.hidden = NO;
            [otherButton setTitle:@"重新购买" forState:UIControlStateNormal];
        }
    }else if (detailModel.order_status.intValue == 8){
        otherButton.hidden = NO;
        [otherButton setTitle:@"重新购买" forState:UIControlStateNormal];
    }
    
    self.height = otherButton.maxY+15;
    
}



/**
 创建富文本对象并返回
 
 @param string1 第一段文字
 @return 返回创建好的富文本
 */
- (NSMutableAttributedString *)setAttributedStringStyleWithFirst:(NSString *)string1 {
    NSString *title = @"实付款：";
    NSString *first_string = [NSString stringWithFormat:@"￥%@",string1];
    NSString *totalString = [NSString stringWithFormat:@"%@%@", title,first_string];
    //找到各个string在总字符串中的位置
    NSRange title_range = [totalString rangeOfString:title];
    NSRange first_range = [totalString rangeOfString:first_string];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:totalString];
    //实付款的格式
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:title_range];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:title_range];
    //金额的格式
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"F23939"] range:first_range];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:first_range];
    
    return str;
}

//TODO:点击取消button
- (void)clickCancelAction:(UIButton *)button{
    if (self.footBlock) {
        if (_model.order_status.intValue == 2) {//查看物流
            self.footBlock(self.model, wuliuEvent);
        }else{//取消订单
            self.footBlock(self.model, cancelEvent);
        }
    }
}

//TODO:点击订单操作button
- (void)clickOtherAction:(UIButton *)button{
    if (self.footBlock) {
        if (_model.order_status.intValue == 0) {//待支付，显示支付和取消button
            self.footBlock(self.model,payEvent);
        }else if (_model.order_status.intValue == 2){//待收货
            self.footBlock(self.model,acceptEvent);
        }else if (_model.order_status.intValue == 3){//已完成
            self.footBlock(self.model,buyAgentEvent);
        }else if (_model.order_status.intValue == 5){//售后方面
            if (_model.back_status.intValue == 0) {//退款待处理
                self.footBlock(self.model,cancelRefundEvent);
            }else if (_model.back_status.intValue == 1){//退款成功
                self.footBlock(self.model,buyAgentEvent);
            }
        }else if (_model.order_status.intValue == 8){ //重新购买
            self.footBlock(self.model, buyAgentEvent);
        }
    }
}




@end
