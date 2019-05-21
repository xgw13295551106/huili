//
//  NSDictionary+Ext.m
//  ALToolsTest
//
//  Created by AaronLee on 14-9-9.
//  Copyright (c) 2014年 com.AaronLee. All rights reserved.
//

#import "NSDictionaryExt.h"

@implementation NSDictionary (Ext)

- (NSString *)jsonValue
{
    NSString* result = @"{";
    for (NSString* key in [self allKeys]) {
        NSString* value = [self objectForKey:key];
        result = [result stringByAppendingFormat:@"\"%@\":\"%@\",",key,value];
    }
    result = [result substringToIndex:result.length - 1];
    result = [result stringByAppendingString:@"}"];
    return result;
}

@end
