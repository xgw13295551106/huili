//
//  MessageModel.m
//  YeFu
//
//  Created by Carl on 2017/12/8.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

+(MessageModel *)model
{
    return [[MessageModel alloc] init];
}

- (void)initWithDictionary:(NSDictionary*)dic {
    
    self.message_id = [dic stringForKey:@"id"];
    self.title = [dic stringForKey:@"title"];
    self.time = [dic stringForKey:@"join_at"];
    self.img=[dic stringForKey:@"img"];
    self.url=[dic stringForKey:@"url"];
    
}

@end
