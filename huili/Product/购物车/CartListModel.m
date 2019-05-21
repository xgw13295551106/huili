//
//  CartListModel.m
//  yihuo
//
//  Created by Carl on 2017/12/25.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "CartListModel.h"

@implementation CartListModel

+(CartListModel *)model
{
    return [[CartListModel alloc] init];
}
- (void)initWithDictionary:(NSDictionary*)dic {
    self.cart_id=[dic stringForKey:@"id"];
    self.goods_id=[dic stringForKey:@"goods_id"];
    self.goods_img = [dic stringForKey:@"goods_img"];
    self.goods_name = [dic stringForKey:@"goods_name"];
    self.goods_des= [dic stringForKey:@"subtitle"];
    self.goods_price=[dic stringForKey:@"price"];
    self.goods_oldprice= [dic stringForKey:@"super_price"];
    self.goods_spec=[dic stringForKey:@"speci"];
    self.goods_ammount=[dic intForKey:@"goods_num"];
    self.inventory=[dic stringForKey:@"inventory"];
    self.attr_ids=[dic stringForKey:@"attr_ids"];
    self.attr_names=[dic stringForKey:@"attr_names"];
}

@end
