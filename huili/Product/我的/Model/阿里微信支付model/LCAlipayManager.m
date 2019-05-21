//
//  LCAlipayManager.m
//  ConsumerProject
//
//  Created by zhongweike on 2017/8/29.
//  Copyright © 2017年 John.peng. All rights reserved.
//

#import "LCAlipayManager.h"
#import "LCAlipayModel.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation LCAlipayManager

+ (instancetype)manager{
    static dispatch_once_t onceToken;
    static LCAlipayManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[LCAlipayManager alloc] init];
    });
    return instance;
}

- (void)AliPayWithOrderString:(NSString *)orderString andBlock:(AliPayManageBlock)resultBlock{
    self.resultBlock = resultBlock;
    if (![NSString stringIsNull:orderString]) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = AppSchemes;
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            if (self.resultBlock) {
                self.resultBlock(resultDic);
            }
        }];
    }
}



@end
