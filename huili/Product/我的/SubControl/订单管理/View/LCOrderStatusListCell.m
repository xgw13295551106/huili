//
//  LCOrderStatusListCell.m
//  YeFu
//
//  Created by zhongweike on 2017/12/12.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "LCOrderStatusListCell.h"
#import "LCMyOrderDetailModel.h"

#define cellHieght 90

#define PointColor_light    [UIColor colorWithHexString:@"28B915"]   ///< 亮点颜色
#define OrderDarkColor      [UIColor colorWithHexString:@"D7D8D7"]   ///< cell用的灰色

@interface LCOrderStatusListCell (){
    UIView *pointView;
    UIView *verLineView;
    UIView *statusView;           ///< 专门显示订单状态的view
    UILabel *statusLabel;         ///< statusView中，显示订单状态的label
    UILabel *statusContentLabel;  ///< statusView中，显示订单状态详情的label
    UILabel *statusTimeLabel;     ///< statusView中，显示状态时间的label
    UIButton *telButton;          ///< 拨打电话button
    UIButton *judgeButton;        ///< 去评价button
}

@property (nonatomic,strong)OrderStatusListCellBlock block;
@property (nonatomic,strong)LCMyOrderDetailModel *model;
@property (nonatomic,strong)NSArray *statusArray;

@end

@implementation LCOrderStatusListCell

+ (instancetype)getOrderStatusListCell:(UITableView *)tableView andIndex:(NSIndexPath *)indexPath andIdentifier:(NSString *)identifier andModel:(LCMyOrderDetailModel *)model andList:(NSArray *)statusList andBlock:(OrderStatusListCellBlock)block{
    LCOrderStatusListCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[LCOrderStatusListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.block = block;
    cell.statusArray = statusList;
    [cell setInfoWith:model andIndex:indexPath andCountIndex:[tableView numberOfRowsInSection:0]];
    return cell;
}

+ (CGFloat)getOrderStatusListCellHeight{
    return cellHieght;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setBackgroundColor:[UIColor colorWithHexString:@"F6F7F6"]];
        [self setUpControls];
    }
    return self;
}

- (void)setUpControls{
    statusView = [[UIView alloc]initWithFrame:CGRectMake(20, 15, win_width-20-10, 80)];
    [statusView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:statusView];
    
    //订单详情状态lable
    statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 150, 20)];
    statusLabel.textColor = [UIColor colorWithHexString:@"343534"];
    statusLabel.font = [UIFont systemFontOfSize:16];
    statusLabel.textAlignment = NSTextAlignmentLeft;
    [statusView addSubview:statusLabel];
    
    //订单状态变更时间
    statusTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(statusView.width-8-120, statusLabel.minY, 120, 20)];
    statusTimeLabel.textColor = [UIColor colorWithHexString:@"848584"];
    statusTimeLabel.font = [UIFont systemFontOfSize:14];
    statusTimeLabel.textAlignment = NSTextAlignmentRight;
    [statusView addSubview:statusTimeLabel];
    
    //订单状态详情
    statusContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(statusLabel.minX, statusLabel.maxY+10, 0, 20)];
    statusContentLabel.textColor = [UIColor colorWithHexString:@"848584"];
    statusContentLabel.font = [UIFont systemFontOfSize:14];
    statusContentLabel.textAlignment = NSTextAlignmentLeft;
    [statusView addSubview:statusContentLabel];
    
    //拨打电话button
    UIImage *telImage = [UIImage imageNamed:@"order_button_phone"];
    UIImage *telImage_pre = [UIImage imageNamed:@"order_button_phone_pre"];
    telButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [telButton setFrame:CGRectMake(statusView.width-8-telImage.size.width, statusContentLabel.centerY-telImage.size.height/2, telImage.size.width, telImage.size.height)];
    [telButton setImage:telImage forState:UIControlStateNormal];
    [telButton setImage:telImage_pre forState:UIControlStateHighlighted];
    [telButton addTarget:self action:@selector(ringUpAction:) forControlEvents:UIControlEventTouchUpInside];
    [statusView addSubview:telButton];
    telButton.hidden = YES;
    
    //去评价
    CGFloat button_w = 80;
    CGFloat button_h = 28;
    CGFloat button_y = statusContentLabel.centerY-button_h/2;
    judgeButton = [self getOneButton:CGRectMake(statusTimeLabel.maxX-button_w, button_y, button_w, button_h) andTitle:@"去评价"];
    [judgeButton addTarget:self action:@selector(clickJudgeAction:) forControlEvents:UIControlEventTouchUpInside];
    [statusView addSubview:judgeButton];
    judgeButton.hidden = YES;
    
    //绿色小圆点
    pointView = [[UIView alloc]initWithFrame:CGRectMake(9, cellHieght/2-6/2, 6, 6)];
    pointView.backgroundColor = PointColor_light;
    pointView.layer.cornerRadius = 6/2;
    pointView.layer.masksToBounds = YES;
    [self addSubview:pointView];
    
    //竖线
    verLineView = [[UIView alloc]initWithFrame:CGRectMake(pointView.centerX-0.5, pointView.maxY, 1, statusView.height-pointView.maxY)];
    [verLineView setBackgroundColor:OrderDarkColor];
    [self addSubview:verLineView];
}

//TODO:获取简单封装的button
- (UIButton *)getOneButton:(CGRect)frame andTitle:(NSString *)title{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor colorWithHexString:@"343534"] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor]];
    button.layer.borderColor = [UIColor colorWithHexString:@"C9CAC9"].CGColor;
    button.layer.borderWidth = 1;
    button.layer.cornerRadius = 2;
    button.layer.masksToBounds = YES;
    
    return button;
}

- (CGFloat)setInfoWith:(LCMyOrderDetailModel *)model andIndex:(NSIndexPath *)indexPath andCountIndex:(NSInteger)count{
    CGFloat totalH = 0;
    self.model = model;
    LCMyOrderDetailModel *statusModel = [LCMyOrderDetailModel mj_objectWithKeyValues:_statusArray[indexPath.row]];
    NSDictionary *infoDic = [self getOrderStatusDecInfo:statusModel];
    statusLabel.text  =  infoDic[@"status"];
    statusTimeLabel.text = infoDic[@"time"];
    statusContentLabel.text = infoDic[@"content"];
    [statusContentLabel sizeToFit];
    statusContentLabel.size = CGSizeMake(statusContentLabel.width, 20);
    telButton.hidden = YES;
    judgeButton.hidden = YES;
    if (indexPath.row == 0 && count>1) {
        verLineView.frame = CGRectMake(pointView.centerX-0.5, pointView.maxY, 1, cellHieght/2);
        pointView.backgroundColor = PointColor_light;
        
    }else if (indexPath.row == 0 && count == 1){
        verLineView.size = CGSizeMake(0, 0);
        pointView.backgroundColor = PointColor_light;
    }else if (indexPath.row == count-1){
        verLineView.frame = CGRectMake(pointView.centerX-0.5, 0, 1, cellHieght/2);
        pointView.backgroundColor = OrderDarkColor;
    }else{
        verLineView.frame = CGRectMake(pointView.centerX-0.5, 0, 1, cellHieght);
        pointView.backgroundColor = OrderDarkColor;
    }
    
    if (statusModel.order_status.intValue >= 2 && statusModel.order_status.intValue <=5) {
        telButton.hidden = NO;
    }else if (statusModel.order_status.intValue == 6 && _model.order_status.intValue == 6){
        judgeButton.hidden = NO;
    }
    
    return totalH;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark button点击事件
//TODO:拨打电话
- (void)ringUpAction:(UIButton *)button{
    if (self.block) {
        self.block(YES, self.model);
    }
}

//TODO:点击去评价
- (void)clickJudgeAction:(UIButton *)button{
    if (self.block) {
        self.block(NO, self.model);
    }
}

//TODO:获取订单状态内容 0待支付 1已支付 2商家接单 3配送员接单 4已到店 5开始服务 6送达 7已评价 8用户取消订单
- (NSMutableDictionary *)getOrderStatusDecInfo:(LCMyOrderDetailModel *)model{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    int orderStatus = model.order_status.intValue;
    NSString *order_status_time = nil;
    NSString *order_status = nil;
    NSString *order_status_content = nil;
    if (orderStatus == 0) {
        order_status = @"订单提交成功";
        order_status_time = _model.created_at;
        order_status_content = [NSString stringWithFormat:@"订单号：%@",_model.order_sn];
    }else if (orderStatus == 1) {
        order_status = @"已支付";
        order_status_time = _model.pay_time;
        order_status_content = @"订单支付成功";
    }else if (orderStatus == 2){
        order_status = @"商家已接单";
        order_status_time = _model.sup_time;
        order_status_content = @"商品准备中";
    }else if (orderStatus == 3){
        order_status = @"配送员已接单";
        order_status_time = _model.ser_time;
        order_status_content = [NSString stringWithFormat:@"配送员正在赶往商家，配送员:%@",_model.server_name];
    }else if (orderStatus == 4){
        order_status = @"配送员已到店";
        order_status_time = _model.arr_time;
        order_status_content = [NSString stringWithFormat:@"正在为您配送，配送员:%@",_model.server_name];
    }else if (orderStatus == 5){
        order_status = @"配送员配送中";
        order_status_time = _model.start_time;
        order_status_content = [NSString stringWithFormat:@"正在为您配送，配送员:%@",_model.server_name];
    }else if (orderStatus == 6){
        order_status = @"订单完成";
        order_status_time = _model.finish_time;
        order_status_content = @"订单配送完成，欢迎再次选购";
    }else if (orderStatus == 7){
        order_status = @"订单完成";
        order_status_time = _model.finish_time;
        order_status_content = @"订单已完成，欢迎再次选购";
    }else if (orderStatus == 8){
        order_status = @"订单已取消";
        order_status_time = _model.cancel_time;
        order_status_content = @"订单配送完成，欢迎再次选购";
    }else{
        order_status = @"未获知订单状态";
        order_status_time = _model.created_at;
        order_status_content = @"未获知订单状态";
    }
    dic[@"status"] = order_status;
    dic[@"time"] = order_status_time;
    dic[@"content"] = order_status_content;
    
    return dic;
}

@end
