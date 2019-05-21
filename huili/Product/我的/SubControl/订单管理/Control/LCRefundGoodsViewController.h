//
//  LCRefundGoodsViewController.h
//  yihuo
//
//  Created by zhongweike on 2017/12/28.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "YHBaseViewController.h"
@class LCMyOrderGoodsModel;

/**
 申请售后
 */
@interface LCRefundGoodsViewController : YHBaseViewController


/** 订单id */
@property (nonatomic,copy) NSString *order_id;
/** 要退款的商品id */
@property (nonatomic,strong) LCMyOrderGoodsModel *goodsModel;



@end
