//
//  LCWuliuViewController.h
//  huili
//
//  Created by zhongweike on 2018/1/12.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import "YHBaseViewController.h"

@interface LCWuliuViewController : YHBaseViewController

/** 订单id */
@property (nonatomic,copy) NSString *order_id;

/**
 订单中第一个商品的图片
 */
@property (nonatomic,copy) NSString *order_goods_img;

@end
