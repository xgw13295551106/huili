//
//  GoodsModel.h
//  YeFu
//
//  Created by Carl on 2017/12/4.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "BaseModel.h"

@interface GoodsModel : BaseModel

@property(nonatomic,strong)NSString *co_id;
@property(nonatomic,strong)NSString *cart_id;
@property(nonatomic,strong)NSString *goods_id;
@property(nonatomic,strong)NSString *goods_img;
@property(nonatomic,strong)NSString *goods_name;
@property(nonatomic,strong)NSString *goods_des;
@property(nonatomic,strong)NSString *goods_price;
@property(nonatomic,strong)NSString *goods_oldprice;
@property(nonatomic,strong)NSString *goods_spec;//规格
@property(nonatomic,strong)NSString *inventory;//库存
@property(nonatomic)int goods_ammount;//数量
@property(nonatomic)BOOL isSelect;
@property(nonatomic)NSString *percent;
/** 价格 */
@property (nonatomic,copy) NSString *price;
/** 原价或者会员价 */
@property (nonatomic,copy) NSString *super_price;
/** 秒杀结束时间 */
@property (nonatomic,copy) NSString *end;




/**
 创建一个新的实例
 */
+(GoodsModel *)model;
/**
 通过字典初始化数据
 */
-(void)initWithDictionary:(NSDictionary *)dic;//商品

-(void)initWithDictionary2:(NSDictionary *)dic;//购物车

-(void)initWithDictionary3:(NSDictionary *)dic;//收藏

@end
