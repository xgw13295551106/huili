//
//  AttributesModel.m
//  yihuo
//
//  Created by Carl on 2017/12/27.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "AttributesModel.h"

@implementation AttributesModel

+(AttributesModel *)model
{
    return [[AttributesModel alloc] init];
}

- (void)initWithDictionary:(NSDictionary*)dic {
    
    self.attributesModel_id = [dic stringForKey:@"id"];
    self.name = [dic stringForKey:@"name"];
    NSArray *array=[dic objectForKey:@"child"];
    for (int i=0; i<array.count; i++) {
        NSDictionary *dic=[array objectAtIndex:i];
        AttributeModel *model=[AttributeModel model];
        [model initWithDictionary:dic];
        [self.array addObject:model];
    }
    
    
}

-(NSMutableArray*)array{
    if (_array==nil) {
        _array=[[NSMutableArray alloc]init];
    }
    return _array;
}

@end
