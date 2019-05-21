//
//  CommonConfig.h
//  ConvenienceStore
//
//  Created by Carl on 2017/10/18.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    allStatus = 111,        ///< 选择全部
    submitStatus,           ///< 已提交(待支付)
    payStatus,              ///< 已支付(待接单)
    storeAcceptStatus,      ///< 商家已接单(等待骑手)
    riderAcceptStatus,      ///< 骑手已接单(等待骑手到店)
    riderSendStatus,        ///< 骑手已到店取货，开始配送
    riderFinishStatus,      ///< 骑手已送达（已完成）
    waitJudgeStatus,        ///< 待评价
    haveJudgeStatus,        ///< 已评价(订单所有流程结束)
    
}OrderStatus;     ///< 我的订单状态

typedef enum {
    payEvent = 111,     ///< 支付事件
    buyAgentEvent,      ///< 再次购买
    cancelEvent,        ///< 取消操作
    refundEvent,        ///< 申请售后
    cancelRefundEvent,  ///< 取消退款
    acceptEvent,        ///< 确认收货
    wuliuEvent,         ///< 查看物流
}OrderButtonEvent; ///< 订单中的按钮点击事件类型

@interface CommonConfig : NSObject

/**微信公众号**/
@property(nonatomic,strong)NSString *wxG;
/**联系电话**/
@property(nonatomic,strong)NSString *mobileSer;
/**电子邮箱**/
@property(nonatomic,strong)NSString *email;
/**官方网站**/
@property(nonatomic,strong)NSString *net;
/**logo图标**/
@property(nonatomic,strong)NSString *logo;
/**版权信息**/
@property(nonatomic,strong)NSString *copyright;
/**注册协议**/
@property(nonatomic,strong)NSString *registXieyi;
/**签到积分**/
@property(nonatomic,strong)NSString *sign;

/**分享**/
@property(nonatomic,strong)NSString *shareUrl;

/**首页广告语**/
@property(nonatomic,strong)NSString *homeAd;
/**页面广告语**/
@property(nonatomic,strong)NSString *pageAd;
/**及时配送费**/
@property(nonatomic,strong)NSString *jishiFee;
/**快速配送费**/
@property(nonatomic,strong)NSString *kuaisuFee;
/**100积分兑换金额**/
@property(nonatomic,strong)NSString *jifenChange;
/**客服QQ**/
@property(nonatomic,strong)NSString *KefuQQ;
/**融云**/
@property(nonatomic,strong)NSString *RongID;

/**手续费规则**/
@property(nonatomic,strong)NSString *feeRules;

/** 铜牌会员折扣 */
@property (nonatomic,copy) NSString *vip_level1;
/** 银牌会员折扣 */
@property (nonatomic,copy) NSString *vip_level2;
/** 金牌会员折扣 */
@property (nonatomic,copy) NSString *vip_level3;
/** 钻石会员折扣 */
@property (nonatomic,copy) NSString *vip_level4;



/**
 创建一个新的实例
 */
+(CommonConfig *)shared;
/**
 通过字典初始化数据
 */
-(void)initWithArr:(NSArray *)array;

@end
