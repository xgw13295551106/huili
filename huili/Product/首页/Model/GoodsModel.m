//
//  GoodsModel.m
//  YeFu
//
//  Created by Carl on 2017/12/4.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "GoodsModel.h"

@implementation GoodsModel

+(GoodsModel *)model
{
    return [[GoodsModel alloc] init];
}

- (void)initWithDictionary:(NSDictionary*)dic {
    
    self.goods_id = [dic stringForKey:@"id"];
    self.goods_img = [dic stringForKey:@"goods_img"];
    self.goods_name = [dic stringForKey:@"name"];
    self.goods_des= [dic stringForKey:@"subtitle"];
    self.goods_price=[dic stringForKey:@"price"];
    self.goods_oldprice= [dic stringForKey:@"super_price"];
    self.goods_spec=[dic stringForKey:@"speci"];
    self.goods_ammount=[dic intForKey:@"num"];
    self.inventory=[dic stringForKey:@"inventory"];
    self.percent=[dic stringForKey:@"percent"];
    self.price = [dic stringForKey:@"price"];
    self.super_price = [dic stringForKey:@"super_price"];
    self.end = [dic stringForKey:@"end"];
}

- (void)initWithDictionary2:(NSDictionary*)dic {
    
    self.goods_id = [dic stringForKey:@"goods_id"];
    self.cart_id=[dic stringForKey:@"id"];
    self.goods_img = [dic stringForKey:@"goods_img"];
    self.goods_name = [dic stringForKey:@"goods_name"];
    self.goods_des= [dic stringForKey:@"subtitle"];
    self.goods_price=[dic stringForKey:@"price"];
    self.goods_oldprice= [dic stringForKey:@"super_price"];
    self.goods_spec=[dic stringForKey:@"speci"];
    self.goods_ammount=[dic intForKey:@"goods_num"];
    self.inventory=[dic stringForKey:@"inventory"];
    self.price = [dic stringForKey:@"price"];
    self.super_price = [dic stringForKey:@"super_price"];
    self.end = [dic stringForKey:@"end"];
}

- (void)initWithDictionary3:(NSDictionary*)dic {
    self.co_id = [dic stringForKey:@"id"];
    self.goods_id = [dic stringForKey:@"goods_id"];
    self.goods_img = [dic stringForKey:@"goods_img"];
    self.goods_name = [dic stringForKey:@"name"];
    self.goods_des= [dic stringForKey:@"subtitle"];
    self.goods_price=[dic stringForKey:@"price"];
    self.goods_oldprice= [dic stringForKey:@"super_price"];
    self.goods_spec=[dic stringForKey:@"speci"];
    self.goods_ammount=[dic intForKey:@"num"];
    self.inventory=[dic stringForKey:@"inventory"];
    self.price = [dic stringForKey:@"price"];
    self.super_price = [dic stringForKey:@"super_price"];
    self.end = [dic stringForKey:@"end"];
}

@end
