//
//  LCBindPhoneViewController.h
//  StudioRecognition
//
//  Created by zhongweike on 2017/10/13.
//  Copyright © 2017年 zhongweike. All rights reserved.
//

#import "YHBaseViewController.h"

typedef void(^BindPhoneBlock)(BOOL isSuccessed);

/**
 第三方登录后绑定手机号
 */
@interface LCBindPhoneViewController : YHBaseViewController


@property (nonatomic,strong)BindPhoneBlock bindBlock;
/** 需要的信息 open_id type 1为qq2为微信 */
@property (nonatomic,strong)NSDictionary *thirdDic;

@end
