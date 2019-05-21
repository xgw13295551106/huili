//
//  LCAlipayManager.h
//  ConsumerProject
//
//  Created by zhongweike on 2017/8/29.
//  Copyright © 2017年 John.peng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LCAlipayModel;

typedef void(^AliPayManageBlock)(NSDictionary *resultDic);


@protocol LCAlipayManagerDelegate <NSObject>

@required
- (void)getAlipayResultWith:(NSDictionary *)resultDic;

@end

@interface LCAlipayManager : NSObject

@property (nonatomic,strong)AliPayManageBlock resultBlock;

@property (nonatomic,weak)id<LCAlipayManagerDelegate>delegate;


/**
 *  调用支付宝支付
 *
 *  @param orderString 支付订单字符串
 */
- (void)AliPayWithOrderString:(NSString *)orderString andBlock:(AliPayManageBlock)resultBlock;

/**
 获取单例

 @return 返回manager
 */
+ (instancetype)manager;



@end
