//
//  LCWeChatManager.m
//  ConsumerProject
//
//  Created by zhongweike on 2017/8/29.
//  Copyright © 2017年 John.peng. All rights reserved.
//

#import "LCWeChatManager.h"
#import "LCWeChatModel.h"
#import "WXApi.h"

@implementation LCWeChatManager

+ (instancetype)manager{
    static dispatch_once_t onceToken;
    static LCWeChatManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[LCWeChatManager alloc] init];
    });
    return instance;
}

- (void)weChatPayWithModel:(LCWeChatModel *)wechatModel andBlock:(WeChatPayBlock)resultBlock{
    
    self.resultBlock = resultBlock;
    
    [WXApi registerApp:WXAPPID];
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = wechatModel.partnerid;
    request.prepayId= wechatModel.prepayid;
    request.package = wechatModel.package;
    request.nonceStr= wechatModel.noncestr;
    request.timeStamp= wechatModel.timestamp.intValue;
    request.sign= wechatModel.sign;
    [WXApi sendReq:request];
    
}

- (void)onResp:(BaseResp *)resp{
    PayResp *response = (PayResp *)resp;
    switch(response.errCode){
            case WXSuccess:
            //服务器端查询支付通知或查询API返回的结果再提示成功
            [self returnResult:YES];
            NSLog(@"支付成功");
            break;
        default:
            NSLog(@"支付失败，retcode=%d",resp.errCode);
            [self returnResult:NO];
            break;
    }
}


- (void)returnResult:(BOOL)success{
    if (self.resultBlock) {
        self.resultBlock(success);
    }
}

@end
