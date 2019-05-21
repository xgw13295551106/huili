//
//  AttributesModel.m
//  yihuo
//
//  Created by Carl on 2017/12/27.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "AttributeModel.h"

@implementation AttributeModel

+(AttributeModel *)model
{
    return [[AttributeModel alloc] init];
}

- (void)initWithDictionary:(NSDictionary*)dic {
    
    self.attribute_id = [dic stringForKey:@"id"];
    self.name = [dic stringForKey:@"name"];
}

@end
