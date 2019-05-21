//
//  LCMyOrderGoodsModel.h
//  YeFu
//
//  Created by zhongweike on 2017/12/15.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCMyOrderGoodsModel : NSObject

/** id */
@property (nonatomic,copy) NSString *id;
/** 商品id */
@property (nonatomic,copy) NSString *goods_id;
/** 商品图片 */
@property (nonatomic,copy) NSString *goods_img;
/** 商品名 */
@property (nonatomic,copy) NSString *goods_name;
/** 商品价格 */
@property (nonatomic,copy) NSString *goods_amount;
/** 商品内容介绍 */
@property (nonatomic,copy) NSString *subtitle;
/** 规格描述 */
@property (nonatomic,copy) NSString *speci;
/** 商品购买数量 */
@property (nonatomic,copy) NSString *goods_num;
/** 商品属性 */
@property (nonatomic,copy) NSString *attr_ids;
/** attr_names */
@property (nonatomic,copy) NSString *attr_names;
/** 商品数量 */
@property (nonatomic,copy) NSString *number;
/** 商品价格 */
@property (nonatomic,copy) NSString *price;
















@end
