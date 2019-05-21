//
//  LCMyOrderDetailModel.h
//  YeFu
//
//  Created by zhongweike on 2017/12/11.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCMyOrderGoodsModel.h"
#import "LCMyOrderAddressModel.h"

@interface LCMyOrderDetailModel : NSObject

/** id */
@property (nonatomic,copy) NSString *id;
/** 订单状态 0为待支付 1为已支付待发货 2为已发货待收货 3为确认收货已完成 5为售后  8为取消  */
@property (nonatomic,copy) NSString *order_status;
/** 支付状态 0未支付1已支付 */
@property (nonatomic,copy) NSString *pay_status;
/** 1支付宝 2微信 3余额 4积分 */
@property (nonatomic,copy) NSString *pay_type;
/** 发布时间 */
@property (nonatomic,copy) NSString *created_at;
/** 订单总金额 */
@property (nonatomic,copy) NSString *amount;
/** 数量 */
@property (nonatomic,copy) NSString *num;
/** 服务者id */
@property (nonatomic,copy) NSString *server_id;
/** 服务者名称 */
@property (nonatomic,copy) NSString *server_name;
/** 服务者账号 */
@property (nonatomic,copy) NSString *server_login;
/** 商品列表（里面是商品图片goods_img） */
@property (nonatomic,strong) NSArray<LCMyOrderGoodsModel *> *goods;
/** 订单编号 */
@property (nonatomic,copy) NSString *order_sn;
/** 配送开始时间 */
@property (nonatomic,copy) NSString *start_time;
/** 支付事件 */
@property (nonatomic,copy) NSString *pay_time;
/** 商家接单时间 */
@property (nonatomic,copy) NSString *sup_time;
/** 配送员接单时间 */
@property (nonatomic,copy) NSString *ser_time;
/** 配送员到店时间 */
@property (nonatomic,copy) NSString *arr_time;
/** 完成时间 */
@property (nonatomic,copy) NSString *finish_time;
/** 取消时间 */
@property (nonatomic,copy) NSString *cancel_time;
/** 配送费 */
@property (nonatomic,copy) NSString *shipping_fee;
/** 申请退款状态 0为待处理 1为等地商家收货 2为等待重新发货 3已完成*/
@property (nonatomic,copy) NSString *back_status;
/** 1是退货，2是换货 */
@property (nonatomic,copy) NSString *back_type;;

/** 选时配送的时间区间 */
@property (nonatomic,copy) NSString *shipping_id;

/** 配送地址 */
@property (nonatomic,strong) LCMyOrderAddressModel *address_id;
/** 备注 */
@property (nonatomic,copy) NSString *remark;
/** 商家联系电话 */
@property (nonatomic,copy) NSString *supplier_mobile;
/** 总计件数 */
@property (nonatomic,copy) NSString *total_count;
/** 收货地址 */
@property (nonatomic,copy) NSString *detail_address;
/** 收货人 */
@property (nonatomic,copy) NSString *consignee;
/** 收货人手机号 */
@property (nonatomic,copy) NSString *mobile;
/** 手续费 */
@property (nonatomic,copy) NSString *service_charge;
/** 付款时间 */
@property (nonatomic,copy) NSString *pay_at;
/** 发货时间 */
@property (nonatomic,copy) NSString *send_at;
/** 完成时间 */
@property (nonatomic,copy) NSString *finish_at;
/** 积分抵扣金额 */
@property (nonatomic,copy) NSString *integral_money;
/** 实付款 */
@property (nonatomic,copy) NSString *pay_amount;
/** 售后问题描述 */
@property (nonatomic,copy) NSString *back_remark;








@end
