//
//  YeFuListModel.m
//  YeFu
//
//  Created by Carl on 2017/12/14.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "YeFuListModel.h"

@implementation YeFuListModel

+(YeFuListModel *)model
{
    return [[YeFuListModel alloc] init];
}

- (void)initWithDictionary:(NSDictionary*)dic {
    
    self.yefu_id = [dic stringForKey:@"id"];
    self.title = [dic stringForKey:@"title"];
    self.img = [dic stringForKey:@"img"];
    self.cat_name= [dic stringForKey:@"cat_name"];
    self.count=[dic stringForKey:@"count"];
    self.created_at= [dic stringForKey:@"created_at"];
    self.url=[dic stringForKey:@"url"];
}

@end
