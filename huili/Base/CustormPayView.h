//
//  CustormPayView.h
//  YeFu
//
//  Created by zhongweike on 2017/12/16.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    PursePayType = 10,     ///< 钱包（余额）支付
    AlipayType,            ///< 支付宝支付
    WechatPayType          ///< 微信支付
}CustormPayType;//支付类型
//回调传回选择的type，和确认支付的button(方便支付时对button进行特殊操作)
typedef void(^CustormPayBlock)(CustormPayType payType,UIButton *payButton);

@interface CustormPayView : UIView


/**
 弹出支付选择框

 @param payBlock 选择支付方式回调block
 @return 支付弹框
 */
+ (instancetype)shareCustormPayView:(CustormPayBlock)payBlock;

/**
 支付弹框消失
 */
+ (void)dismiss;


@end
