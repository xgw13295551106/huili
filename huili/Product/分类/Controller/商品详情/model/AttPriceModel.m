//
//  AttPriceModel.m
//  yihuo
//
//  Created by Carl on 2017/12/27.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "AttPriceModel.h"

@implementation AttPriceModel

+(AttPriceModel *)model
{
    return [[AttPriceModel alloc] init];
}
- (void)initWithDictionary:(NSDictionary*)dic {
    
    self.attribute_id = [dic stringForKey:@"id"];
    self.attr_ids = [dic stringForKey:@"attr_ids"];
    self.attr_names = [dic stringForKey:@"attr_names"];
    self.price = [dic stringForKey:@"price"];
    self.inventory = [dic stringForKey:@"inventory"];
}

@end
