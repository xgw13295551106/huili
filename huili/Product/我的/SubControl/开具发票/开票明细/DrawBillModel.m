//
//  DrawBillModel.m
//  YeFu
//
//  Created by Carl on 2017/12/9.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "DrawBillModel.h"

@implementation DrawBillModel

+(DrawBillModel *)model
{
    return [[DrawBillModel alloc] init];
}

- (instancetype)initWithDictionary:(NSDictionary*)dic {
    
    self.order_id = [dic stringForKey:@"id"];
    self.time = [dic stringForKey:@"created_at"];
    self.order_sn=[dic stringForKey:@"order_sn"];
    self.price=[dic stringForKey:@"amount"];
    self.status=[dic stringForKey:@"status"];
    self.amount=[dic intForKey:@"amount"];
    self.type = [dic stringForKey:@"type"];
    
    
    return self;
}

@end
