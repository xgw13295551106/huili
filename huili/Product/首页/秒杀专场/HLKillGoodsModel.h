//
//  HLKillGoodsModel.h
//  huili
//
//  Created by zhongweike on 2018/1/9.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLKillGoodsModel : NSObject

/** id */
@property (nonatomic,copy) NSString *id;


/** 商品名 */
@property (nonatomic,copy) NSString *name;

/** 商品图片 */
@property (nonatomic,copy) NSString *goods_img;

/** 秒杀价 */
@property (nonatomic,copy) NSString *kill_price;

/** 原价 */
@property (nonatomic,copy) NSString *price;




@end
