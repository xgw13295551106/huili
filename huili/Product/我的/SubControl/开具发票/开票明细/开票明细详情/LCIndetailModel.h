//
//  LCIndetailModel.h
//  YeFu
//
//  Created by zhongweike on 2017/12/20.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "BaseModel.h"

@interface LCIndetailModel : BaseModel

/** 数量 */
@property (nonatomic,copy) NSString *num;
/** 时间 */
@property (nonatomic,copy) NSString *created_at;
/** 开票类型 1电子 2纸质 */
@property (nonatomic,copy) NSString *type;
/** 抬头类型 */
@property (nonatomic,copy) NSString *title_type;
/** 发票类型 1普通 2专用 */
@property (nonatomic,copy) NSString *flag;
/** 抬头 */
@property (nonatomic,copy) NSString *title;
/** 内容 */
@property (nonatomic,copy) NSString *content;
/** 金额 */
@property (nonatomic,copy) NSString *amount;
/** 纳税人识别号 */
@property (nonatomic,copy) NSString *taxpayer_identity;
/** 地址、电话 */
@property (nonatomic,copy) NSString *address_mob;
/** 开户行及账号 */
@property (nonatomic,copy) NSString *bank_number;
/** 电子邮箱 */
@property (nonatomic,copy) NSString *email;
/** 收件人 */
@property (nonatomic,copy) NSString *name;
/** 联系电话 */
@property (nonatomic,copy) NSString *mobile;
/** 所在地区 */
@property (nonatomic,copy) NSString *region;
/** 详细地址 */
@property (nonatomic,copy) NSString *address_info;
/** 发票状态0待开票 1已开票(电子)2已发出(纸质版) */
@property (nonatomic,copy) NSString *status;
/** 发出时间 */
@property (nonatomic,copy) NSString *out_time;
/** 快递单号 */
@property (nonatomic,copy) NSString *track_num;
/** 开票时间 */
@property (nonatomic,copy) NSString *in_time;
/** 发票中的订单商品 */
@property (nonatomic,strong) NSArray *order;





@end
