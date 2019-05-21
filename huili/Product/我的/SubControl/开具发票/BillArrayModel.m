//
//  BillArrayModel.m
//  YeFu
//
//  Created by Carl on 2017/12/9.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "BillArrayModel.h"

@implementation BillArrayModel

+(BillArrayModel *)model
{
    return [[BillArrayModel alloc] init];
}

- (instancetype)initWithDictionary:(NSDictionary*)dic {
    
    self.month = [dic stringForKey:@"month"];
    NSArray *list = dic[@"list"];
    for (int i=0; i<list.count; i++) {
        BillModel *model=[BillModel model];
        [model initWithDictionary:list[i]];
        [self.billArray addObject:model];
    }
    return self;
}

-(NSMutableArray*)billArray{
    if (_billArray==nil) {
        _billArray=[[NSMutableArray alloc]init];
    }
    return _billArray;
}

@end
