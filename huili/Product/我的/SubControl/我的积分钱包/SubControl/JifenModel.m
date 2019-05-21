//
//  JifenModel.m
//  YeFu
//
//  Created by Carl on 2017/12/8.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "JifenModel.h"

@implementation JifenModel

+(JifenModel *)model
{
    return [[JifenModel alloc] init];
}

- (void)initWithDictionary:(NSDictionary*)dic {
    
    self.name = [dic stringForKey:@"name"];
    
}

@end
