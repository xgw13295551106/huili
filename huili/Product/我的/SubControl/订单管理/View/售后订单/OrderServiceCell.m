//
//  OrderServiceCell.m
//  huili
//
//  Created by zhongweike on 2018/1/12.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import "OrderServiceCell.h"
#import "LCMyOrderDetailModel.h"

#define cell_height 142

#define waitImage    [UIImage imageNamed:@"order_button_clock"]
#define FinishImage  [UIImage imageNamed:@"order_button_finish"]

@interface OrderServiceCell (){
    UILabel *orderNoLabel;      ///< 服务单号
    UILabel *backTypeLabel;     ///< 售后类型（退货、换货）
    
    UIImageView *goodsImgView;  ///< 商品图片
    UILabel *nameLabel;         ///< 商品名label
    UILabel *statusLabel;       ///< 处理状态
    UILabel *statusContentLabel;///< 处理状态详情
    UIImageView *statusImgView; ///< 售后申请状态图片
}
@property (nonatomic,strong)LCMyOrderDetailModel *model;

@end

@implementation OrderServiceCell


+ (CGFloat)getOrderServiceCellHeight{
    return cell_height;
}

+ (instancetype)getOrderServiceCell:(UITableView *)tableView andIdentifier:(NSString *)identifier andIndex:(NSIndexPath *)indexPath andModel:(LCMyOrderDetailModel *)model{
    OrderServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[OrderServiceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setInfoWith:model];
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setUpControls];
    }
    return self;
}

- (void)setUpControls{
    //服务单号
    orderNoLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 2.5, 200, 20)];
    orderNoLabel.textColor = [UIColor colorWithHexString:@"8C8D97"];
    orderNoLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:orderNoLabel];
    
    //售后类型
    backTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(win_width-10-80, orderNoLabel.minY, 80, orderNoLabel.height)];
    backTypeLabel.textColor = [UIColor colorWithHexString:@"323235"];
    backTypeLabel.font = [UIFont systemFontOfSize:14];
    backTypeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:backTypeLabel];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, orderNoLabel.maxY+2.5, win_width, 1)];
    [lineView1 setBackgroundColor:LineColor];
    [self addSubview:lineView1];
    
    //商品图片
    goodsImgView = [[UIImageView alloc]initWithFrame:CGRectMake(orderNoLabel.minX, lineView1.maxY+10, 60, 60)];
    [self addSubview:goodsImgView];
    
    //商品名
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(goodsImgView.maxX+8, goodsImgView.minY, win_width-8-(goodsImgView.maxX+8), 0)];
    nameLabel.textColor = [UIColor colorWithHexString:@"323235"];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.numberOfLines = 3;
    [self addSubview:nameLabel];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, goodsImgView.maxY+10, win_width, 1)];
    [lineView2 setBackgroundColor:LineColor];
    [self addSubview:lineView2];
    
    //售后订单状态图
    statusImgView = [[UIImageView alloc]initWithFrame:CGRectMake(goodsImgView.minX, 10+lineView2.maxY, waitImage.size.width, FinishImage.size.height)];
    [self addSubview:statusImgView];
    
    //售后审核状态
    statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(statusImgView.maxX+8, statusImgView.minY, 100, statusImgView.height)];
    statusLabel.textColor = [UIColor colorWithHexString:@"323235"];
    statusLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:statusLabel];
    
    CGFloat content_w = win_width-8-(statusLabel.maxX+8);
    statusContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(statusLabel.maxX+8, statusLabel.minY, content_w, statusLabel.height)];
    statusContentLabel.textColor = [UIColor colorWithHexString:@"323235"];
    statusContentLabel.font = [UIFont systemFontOfSize:12];
    statusContentLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:statusContentLabel];
}

- (CGFloat)setInfoWith:(LCMyOrderDetailModel *)model{
    CGFloat totalH = 0;
    _model = model;
    NSArray *goodsArray = [LCMyOrderGoodsModel mj_objectArrayWithKeyValuesArray:model.goods];
    if (goodsArray.count>0) {
        LCMyOrderGoodsModel *goods = goodsArray[0];
        [goodsImgView sd_setImageWithURL:[NSURL URLWithString:goods.goods_img] placeholderImage:DefaultsImg];
        nameLabel.text = goods.goods_name;
        CGSize size = [nameLabel sizeThatFits:CGSizeMake( win_width-8-(goodsImgView.maxX+8), MAXFLOAT)];
        nameLabel.size = size;
    }else{
        [goodsImgView setImage:DefaultsImg];
    }
    orderNoLabel.text = [NSString stringWithFormat:@"服务单号：%@",model.order_sn];
    backTypeLabel.text = model.back_type.intValue == 1?@"退货":@"换货";
    statusLabel.text = [self getStatusString:model.back_status.intValue];
    statusContentLabel.text = [self getStatusContentString:model.back_status.intValue];
    
    return totalH;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 获取审核状态

 @param back_status 审核状态数字
 @return 审核状态文字
 */
- (NSString *)getStatusString:(int)back_status{
    //0为待处理 1为等地商家收货 2为等待重新发货、等待退款 3已完成
    if (back_status == 0) {
        [statusImgView setImage:waitImage];
        return @"等待审核";
    }else if (back_status == 1){
        [statusImgView setImage:waitImage];
        return @"等待商家收货";
    }else if (back_status == 2){
        [statusImgView setImage:waitImage];
        return _model.back_type.intValue ==1?@"等待退款":@"等待重新发货";
    }else if (back_status == 3){
        [statusImgView setImage:FinishImage];
        return @"已完成";
    }else{
        [statusImgView setImage:waitImage];
        return @"正在处理";
    }
}

/**
 获取审核状态详细描述

 @param back_status back_status 审核状态数字
 @return 审核状态文字
 */
- (NSString *)getStatusContentString:(int)back_status{
    //0为待处理 1为等地商家收货 2为等待重新发货、等待退款 3已完成
    if (back_status == 0) {
        return @"您的服务单申请已提交，请等待审核";
    }else if (back_status == 1){
        return @"您的服务单已审核完成，请等待商家收货";
    }else if (back_status == 2){
        return _model.back_type.intValue ==1?@"您的服务单商家已收货，请等待退款":@"您的服务单商家已收货，请等待重新发货";
    }else if (back_status == 3){
        return _model.back_type.intValue ==1?@"您的服务单已成功退款，请注意查收":@"您的服务单商家已发货，请注意查收";
    }else{
        return @"正在处理";
    }
}

@end
