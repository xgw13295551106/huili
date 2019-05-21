//
//  LCWeChatModel.h
//  ConsumerProject
//
//  Created by zhongweike on 2017/8/29.
//  Copyright © 2017年 John.peng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCWeChatModel : NSObject



/**
 *  商家向财付通申请的商家id
 */
@property (nonatomic,copy)NSString *partnerid;
/**
 *  预支付订单
 */
@property (nonatomic,copy)NSString *prepayid;
/**
 *  商家根据财付通文档填写的数据和签名
 */
@property (nonatomic,copy)NSString *package;
/**
 *  随机串，防重发
 */
@property (nonatomic,copy)NSString *noncestr;
/**
 *  时间戳，防重发
 */
@property (nonatomic,copy)NSString *timestamp;
/**
 *  商家根据微信开放平台文档对数据做的签名
 */
@property (nonatomic,copy)NSString *sign;



@end
