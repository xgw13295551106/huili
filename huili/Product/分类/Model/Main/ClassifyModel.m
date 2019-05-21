//
//  ClassifyModel.m
//  YeFu
//
//  Created by Carl on 2017/12/5.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "ClassifyModel.h"

@implementation ClassifyModel

+(ClassifyModel *)model
{
    return [[ClassifyModel alloc] init];
}

- (void)initWithDictionary:(NSDictionary*)dic {
    
    self.name = [dic stringForKey:@"name"];
    self.img = [dic stringForKey:@"img"];
    self.sub_id = [dic stringForKey:@"id"];
}

@end
