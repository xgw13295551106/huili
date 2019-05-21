//
//  LCAlipayModel.h
//  ConsumerProject
//
//  Created by zhongweike on 2017/8/28.
//  Copyright © 2017年 John.peng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCAlipayModel : NSObject

/** app_id设置 */
@property (nonatomic,copy) NSString *appId;
/** 支付宝接口名称 */
@property (nonatomic,copy) NSString *method;
/** 参数编码格式 */
@property (nonatomic,copy) NSString *charset;
/** 当前时间点 */
@property (nonatomic,copy) NSString *timestamp;
/** 支付版本 */
@property (nonatomic,copy) NSString *version;
/** sign_type */
@property (nonatomic,copy) NSString *sign_type;
/** biz_content */
@property (nonatomic,strong) NSDictionary *biz_content;
/** signer */
@property (nonatomic,copy) NSString *signer;









@end
