//
//  BillModel.m
//  YeFu
//
//  Created by Carl on 2017/12/9.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "BillModel.h"

@implementation BillModel

+(BillModel *)model
{
    return [[BillModel alloc] init];
}

- (void)initWithDictionary:(NSDictionary*)dic {
    
    self.order_id = [dic stringForKey:@"id"];
    self.time = [dic stringForKey:@"created_at"];
    self.order_sn=[dic stringForKey:@"order_sn"];
    self.price=[dic stringForKey:@"order_amount"];
    self.amount=[dic intForKey:@"order_amount"];
    NSArray *imgArr = [dic objectForKey:@"goods_img"];
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (NSDictionary *one in imgArr) {
        [tmpArray addObject:[one stringForKey:@"goods_img"]];
    }
    self.imgArr=[tmpArray copy];
   
}

@end
