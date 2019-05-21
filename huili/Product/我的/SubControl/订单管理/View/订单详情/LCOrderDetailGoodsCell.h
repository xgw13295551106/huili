//
//  LCOrderDetailGoodsCell.h
//  yihuo
//
//  Created by zhongweike on 2017/12/27.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LCMyOrderDetailModel;
@class LCMyOrderGoodsModel;

typedef void(^OrderDetailGoodsBlock)(LCMyOrderGoodsModel *goodsModel);

/**
 订单详情商品cell
 */
@interface LCOrderDetailGoodsCell : UITableViewCell

/**
 获取订单详情中的商品cell

 @param tableView 显示cell的tableview
 @param indexPath cell的所在位置
 @param identifier cell的标识
 @param model 商品model
 @param block 点击申请售后button的回调
 @param isRefund 是否显示申请售后Yes为显示
 @return 商品cell
 */
+ (instancetype)getOrderDetailGoodsCell:(UITableView *)tableView
                               andIndex:(NSIndexPath *)indexPath
                          andIdentifier:(NSString *)identifier
                               andModel:(LCMyOrderGoodsModel *)model
                               andBlock:(OrderDetailGoodsBlock)block
                                andType:(BOOL)isRefund;

+ (CGFloat)getOrderDetailGoodsCellHeight;


@end
