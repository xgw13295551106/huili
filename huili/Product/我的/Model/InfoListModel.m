//
//  InfoListModel.m
//  YeFu
//
//  Created by Carl on 2017/12/4.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "InfoListModel.h"

@implementation InfoListModel

+(InfoListModel *)model
{
    return [[InfoListModel alloc] init];
}

- (void)initWithDictionary:(NSDictionary*)dic {
    
    self.name = [dic stringForKey:@"name"];
    self.img = [dic stringForKey:@"img"];
    self.cat_id = [dic intForKey:@"cat_id"];
    
}

@end
