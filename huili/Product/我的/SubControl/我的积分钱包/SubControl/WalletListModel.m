//
//  WalletListModel.m
//  YeFu
//
//  Created by Carl on 2017/12/8.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "WalletListModel.h"

@implementation WalletListModel

+(WalletListModel *)model
{
    return [[WalletListModel alloc] init];
}

- (void)initWithDictionary:(NSDictionary*)dic {
    
    self.name = [dic stringForKey:@"name"];
    
    
}

@end
