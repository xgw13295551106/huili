//
//  GoPayViewController.h
//  YeFu
//
//  Created by Carl on 2017/12/19.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "YHBaseViewController.h"

@interface GoPayViewController : YHBaseViewController

@property(nonatomic)NSDictionary *dicData;



/**
 1为立即购买进入，2为购物车进入，3为再次购买
 */
@property (nonatomic,assign)int push_type;
/** 购物车进入时必传 */
@property (nonatomic,copy) NSString *cart_id;
/** 再次购买时必传 */
@property (nonatomic,copy) NSString *order_id;



@end
