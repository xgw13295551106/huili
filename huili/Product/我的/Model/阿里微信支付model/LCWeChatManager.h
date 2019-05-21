//
//  LCWeChatManager.h
//  ConsumerProject
//
//  Created by zhongweike on 2017/8/29.
//  Copyright © 2017年 John.peng. All rights reserved.
//

#import <Foundation/Foundation.h>


@class LCWeChatModel;

typedef void(^WeChatPayBlock)(BOOL success);

@interface LCWeChatManager : NSObject<WXApiDelegate>

@property (nonatomic,strong)WeChatPayBlock resultBlock;

/**
 *  调用微信支付
 *
 *  @param wechatModel 包含微信支付所用参数的model
 */
- (void)weChatPayWithModel:(LCWeChatModel *)wechatModel
                  andBlock:(WeChatPayBlock)resultBlock;


/**
 获取单例

 @return LCWeChatManager
 */
+ (instancetype)manager;

@end
