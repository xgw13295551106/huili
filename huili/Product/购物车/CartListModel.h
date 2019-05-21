//
//  CartListModel.h
//  yihuo
//
//  Created by Carl on 2017/12/25.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "BaseModel.h"

@interface CartListModel : BaseModel

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
@property(nonatomic)NSString *attr_ids;
@property(nonatomic)NSString *attr_names;


/**
 创建一个新的实例
 */
+(CartListModel *)model;
/**
 通过字典初始化数据
 */
-(void)initWithDictionary:(NSDictionary *)dic;//购物车

@end
