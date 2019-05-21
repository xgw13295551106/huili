//
//  BalanceRechargeViewController.h
//  Bee
//
//  Created by zxy on 2017/4/12.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "YHBaseViewController.h"
#import "WXApi.h"

@interface BalanceRechargeViewController : YHBaseViewController<WXApiDelegate>

@property(nonatomic)NSArray *array;

@end
