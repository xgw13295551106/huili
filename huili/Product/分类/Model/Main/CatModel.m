//
//  CatModel.m
//  YeFu
//
//  Created by Carl on 2017/12/4.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "CatModel.h"

@implementation CatModel

+(CatModel *)model
{
    return [[CatModel alloc] init];
}

- (void)initWithDictionary:(NSDictionary*)dic {
    
    self.name = [dic stringForKey:@"name"];
    self.img = [dic stringForKey:@"img"];
    self.cat_id = [dic stringForKey:@"id"];
    
    NSArray *array=[dic objectForKey:@"child"];
    [self.classifyArr removeAllObjects];
    for (int i=0; i<array.count; i++) {
        NSDictionary *dic=[array objectAtIndex:i];
        ClassifyModel *model=[ClassifyModel model];
        model.cat_id=self.cat_id;
        [model initWithDictionary:dic];
        [self.classifyArr addObject:model];
    }
}

-(NSMutableArray*)classifyArr{
    if (_classifyArr==nil) {
        _classifyArr=[[NSMutableArray alloc]init];
    }
    return _classifyArr;
}

@end
