//
//  LCMyOrderListCell.m
//  YeFu
//
//  Created by zhongweike on 2017/12/11.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "LCMyOrderListCell.h"
#import "LCMyOrderDetailModel.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

#define CancelColor     [UIColor colorWithHexString:@"80828E"]   ///< 已取消颜色
#define BuyColor      [UIColor colorWithHexString:@"F13030"]   ///< 其它类型按钮颜色

#define topViewH 25
#define statusViewH 100
#define goodsViewH 80
#define bottomViewH 44


@interface LCMyOrderListCell (){
    UIView *topView;              ///< 顶部view显示订单支付状态
    UIView *goodsView;            ///< 显示订单商品的view
    UIView *bottomView;           ///< 底部view(防止时间和操作按钮)
    
    UILabel *topLabel;            ///< 顶部view中，显示订单状态的label
    UILabel *priceLabel;          ///< goodsView中，订单价格label
    UILabel *totalNumLabel;       ///< goodsView中，订单商品共计件数
    UILabel *totalTitleLabel;     ///< 合计金额标题

    UIButton *cancelButton;       ///< 取消button
    UIButton *otherButton;          ///< 支付、确认收货、取消退款，重购，再次购买button

}
@property (nonatomic,strong)MAMapView *mapView;    ///< 地图view

@property (nonatomic,strong)MyOrderListBlock orderBlock;
@property (nonatomic,strong)LCMyOrderDetailModel *model;

@end

@implementation LCMyOrderListCell


+ (instancetype)getMyOrderListCell:(UITableView *)tableView andIndex:(NSIndexPath *)indexPath andModel:(LCMyOrderDetailModel *)model andBlock:(MyOrderListBlock)orderBlock{
    NSString *identifier = @"myOrderListCell";
    LCMyOrderListCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[LCMyOrderListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.orderBlock = orderBlock;
    [cell setInfoWith:model];
    return cell;
}



+ (CGFloat)getMyOrderListCellHeight:(UITableView *)tableView andIndex:(NSIndexPath *)indexPath andModel:(LCMyOrderDetailModel *)model{
    CGFloat totalH = 0; //5+20+5
    totalH = topViewH + goodsViewH + bottomViewH +30;
    int order_status = model.order_status.intValue;
    if (order_status == 0 || order_status == 1 || order_status == 2 || order_status == 3 || order_status == 8) {
        totalH = topViewH + goodsViewH + bottomViewH +30;
    }else if (model.order_status.intValue == 5){//售后方面
        if (model.back_status.intValue == 0) {//退款待处理
            totalH = topViewH + goodsViewH + bottomViewH +30;
        }else if (model.back_status.intValue == 1){//退款成功
            totalH = topViewH + goodsViewH + bottomViewH +30;
        }
    }else{
        totalH = topViewH + goodsViewH + bottomViewH;
    }
    
    return totalH;
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setUpControls];
    }
    return self;
}
//TODO:初始化view
- (void)setUpControls{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //集成顶部view
    [self setupTopView];
    //集成显示订单商品的view
    [self setupGoodsView];
    //集成订单底部的view
    [self setupBottomView];
}
//TODO:设置顶部的view
- (void)setupTopView{
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, win_width, topViewH)];
    [topView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:topView];
    CGFloat topLabel_w = 100;
    CGFloat topLabel_x = win_width-10-topLabel_w;
    CGFloat topLabel_h = 20;
    CGFloat topLabel_y = (topView.height-topLabel_h)/2;
    topLabel = [[UILabel alloc]initWithFrame:CGRectMake(topLabel_x, topLabel_y, topLabel_w, topLabel_h)];
    topLabel.textColor = STYLECOLOR;
    topLabel.font = [UIFont systemFontOfSize:16];
    topLabel.textAlignment = NSTextAlignmentRight;
    [topView addSubview:topLabel];

}


//TODO:设置订单的商品信息view
- (void)setupGoodsView{
    goodsView = [[UIView alloc]initWithFrame:CGRectMake(0, topView.maxY, win_width, goodsViewH)];
    [goodsView setBackgroundColor:[UIColor colorWithHexString:@"F7F8F7"]];
    [self addSubview:goodsView];
    
    //右侧箭头图片
    UIImage *rightImage = [UIImage imageNamed:@"order_button_arrows_def"];
    UIImageView *rightImgView = [[UIImageView alloc]initWithImage:rightImage];
    [rightImgView sizeToFit];
    [rightImgView setFrame:CGRectMake(goodsView.width-8-rightImgView.width, goodsView.height/2-rightImgView.height/2, rightImgView.width, rightImgView.height)];
    [goodsView addSubview:rightImgView];
    
    //订单商品总件数
    totalNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(rightImgView.minX-8-100, rightImgView.centerY-22/2, 100, 22)];
    totalNumLabel.textColor = [UIColor colorWithHexString:@"000000"];
    totalNumLabel.font = [UIFont systemFontOfSize:14];
    totalNumLabel.textAlignment = NSTextAlignmentRight;
    [goodsView addSubview:totalNumLabel];
    
}

//TODO:设置底部view
- (void)setupBottomView{
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, goodsView.maxY, win_width, bottomViewH)];
    [bottomView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:bottomView];
    
    //订单价格label
    priceLabel = [[UILabel alloc]init];
    priceLabel.textColor = [UIColor colorWithHexString:@"E0251F"];
    priceLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    priceLabel.textAlignment = NSTextAlignmentRight;
    [bottomView addSubview:priceLabel];
    priceLabel.minY = 5;
    
    //合计金额标题
    totalTitleLabel = [[UILabel alloc]init];
    totalTitleLabel.textColor = [UIColor colorWithHexString:@"242427"];
    totalTitleLabel.font = [UIFont systemFontOfSize:12];
    totalTitleLabel.textAlignment = NSTextAlignmentRight;
    totalTitleLabel.text = @"合计:";
    [bottomView addSubview:totalTitleLabel];
    totalTitleLabel.minY = priceLabel.minY;
    totalTitleLabel.size = CGSizeMake(50, 20);
    
    CGFloat button_w = 80;
    CGFloat button_h = 28;
    CGFloat button_y = 8;
    //订单相关操作button
    otherButton  = [self getOneButton:CGRectMake(bottomView.width-8-button_w, button_y, button_w, button_h) andTitle:@"去付款"];
    [otherButton addTarget:self action:@selector(clickOtherButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:otherButton];
    
    //取消button
    cancelButton = [self getOneButton:CGRectMake(otherButton.minX-10-button_w, button_y, button_w, button_h) andTitle:@"取消订单"];
    [cancelButton setTitleColor:CancelColor forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(clickCancelAction:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.layer.borderColor = [CancelColor CGColor];
    [bottomView addSubview:cancelButton];
    

    
}

//TODO:获取简单封装的button
- (UIButton *)getOneButton:(CGRect)frame andTitle:(NSString *)title{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:BuyColor forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor]];
    button.layer.borderColor = [BuyColor CGColor];
    button.layer.borderWidth = 1;
    button.layer.cornerRadius = 2;
    button.layer.masksToBounds = YES;
    
    return button;
}


//TODO:对控件进行赋值
- (CGFloat)setInfoWith:(LCMyOrderDetailModel *)model{
    CGFloat totalH = 0;
    _model = model;
    //顶部view信息
    topLabel.text = [self getOrderStatusDecInfo:model];
    
    //-------------商品列表view的相关信息------------
    goodsView.minY = topView.maxY;
    totalNumLabel.text = [NSString stringWithFormat:@"共%@件",model.total_count];
    CGFloat goods_minX = 15;
    CGFloat goods_minY = 12;
    CGFloat goods_width = 56;
    CGFloat goods_height = goods_width;
    CGFloat goods_space = 5;
    for (UIView *imgView in goodsView.subviews) { //先清空之前的商品图片
        if (imgView.width < 30) {
            continue;  //这里是为了防止删掉右侧箭头
        }else{
            if ([imgView isKindOfClass:[UIImageView class]]) {
                [imgView removeFromSuperview];
            }
        }
    }
    //添加商品图片显示
    int count = model.goods.count>3?3:(int)model.goods.count;
    for(int i = 0;i<count;i++){
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(goods_minX+i*(goods_space+goods_width), goods_minY, goods_width, goods_height)];
        [goodsView addSubview:imageView];
        LCMyOrderGoodsModel *goods = [LCMyOrderGoodsModel mj_objectWithKeyValues:model.goods[i]];
        [imageView sd_setImageWithURL:[NSURL URLWithString:goods.goods_img] placeholderImage:[UIImage imageWithColor:LineColor]];
    }
    
    //---------------底部view的相关信息--------------
    bottomView.minY = goodsView.maxY;
    priceLabel.text = [NSString stringWithFormat:@"￥%@",model.amount];
    [priceLabel sizeToFit];
    priceLabel.frame = CGRectMake(win_width-10-priceLabel.width, 5, priceLabel.width, 20);
    totalTitleLabel.maxX = priceLabel.minX-2;
    
    //统一重置两个button的初始状态
    [self setAllButttonY:totalTitleLabel.maxY+8];
    
    //-------------判断底部button的显示情况
    if (model.order_status.intValue == 0) {//待支付，显示支付和取消button
        cancelButton.hidden = NO;
        otherButton.hidden = NO;
        [otherButton setTitle:@"去付款" forState:UIControlStateNormal];
    }else if (model.order_status.intValue == 1){
        cancelButton.hidden = NO;
        cancelButton.origin = otherButton.origin;
    }else if (model.order_status.intValue == 2){//待收货
        otherButton.hidden = NO;
        cancelButton.hidden = NO;
        [cancelButton setTitle:@"查看物流" forState:UIControlStateNormal];
        [otherButton setTitle:@"确认收货" forState:UIControlStateNormal];
    }else if (model.order_status.intValue == 3){//已完成
        otherButton.hidden = NO;
        [cancelButton setTitle:@"申请售后" forState:UIControlStateNormal];
        [otherButton setTitle:@"再次购买" forState:UIControlStateNormal];
    }else if (model.order_status.intValue == 5){//售后方面
        if (model.back_status.intValue == 0) {
            otherButton.hidden = YES;
            [otherButton setTitle:@"取消退款" forState:UIControlStateNormal];
        }else if (model.back_status.intValue == 1){//退款成功
            otherButton.hidden = NO;
            [otherButton setTitle:@"重新购买" forState:UIControlStateNormal];
        }else{
            totalH = totalTitleLabel.maxY+10;
        }
    }else if (model.order_status.intValue == 8){
        otherButton.hidden = NO;
        [otherButton setTitle:@"重新购买" forState:UIControlStateNormal];
    }else{ //不显示任何button
        totalH = totalTitleLabel.maxY+10;
    }
    
    totalH = bottomView.maxY;
    
    return totalH;
}

//TODO:调整所有button的纵坐标
- (void)setAllButttonY:(CGFloat)minY{
    otherButton.minY = minY;
    cancelButton.minY = minY;
    [cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
    cancelButton.maxX = otherButton.minX - 10;
    
    cancelButton.hidden = YES;
    otherButton.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark button点击事件
//TODO:点击订单操作相关button
- (void)clickOtherButtonAction:(UIButton *)button{
    if (self.orderBlock) {
        if (_model.order_status.intValue == 0) {//待支付，显示支付和取消button
            self.orderBlock(payEvent, self.model);
        }else if (_model.order_status.intValue == 1){//显示取消订单
            
        }else if (_model.order_status.intValue == 2){//点击确认收货
            self.orderBlock(acceptEvent, self.model);
        }else if (_model.order_status.intValue == 3){//已完成
            self.orderBlock(buyAgentEvent, self.model);
        }else if (_model.order_status.intValue == 5){//售后方面
            if (_model.back_status.intValue == 0) {//退款待处理
                self.orderBlock(cancelRefundEvent, self.model);
            }else if (_model.back_status.intValue == 1){//退款成功
                self.orderBlock(buyAgentEvent, self.model);
            }
        }else if (_model.order_status.intValue == 8){ //取消订单时执行重新购买
            self.orderBlock(buyAgentEvent, self.model);
        }
    }

}
//TODO:点击取消
- (void)clickCancelAction:(UIButton *)button{
    if (self.orderBlock) {
        if (_model.order_status.intValue == 2) {//查看物流
            self.orderBlock(wuliuEvent, self.model);
        }else{//取消订单
            self.orderBlock(cancelEvent, self.model);
        }
    }
    
}



- (void)dealloc{
    NSLog(@"该cell已释放");
}

//TODO:获取订单状态内容 订单状态 0为待支付 1为已支付待发货 2为已发货待收货 3为确认收货已完成 5为售后  8为取消
- (NSString *)getOrderStatusDecInfo:(LCMyOrderDetailModel *)model{
    NSString *statusString = @"";
    int orderStatus = model.order_status.intValue;
    if (orderStatus == 1) {
        statusString = @"待发货";
    }else if (orderStatus == 2){
        statusString = @"待收货";
    }else if (orderStatus == 3){
        statusString = @"已完成";
    }else if (orderStatus == 5){
        if (model.back_status.intValue == 0) {
            statusString = @"已申请售后";
        }else if (model.back_status.intValue == 1){
            statusString = @"退款成功";
        }else if (model.back_status.intValue == 2){
            statusString = @"退款失败";
        }else{
            statusString = @"退款处理中";
        }
    }else if(orderStatus == 8){
        statusString = @"已取消";
    }else if (orderStatus == 0){
        statusString = @"待付款";
    }
    
    return statusString;
}


@end
