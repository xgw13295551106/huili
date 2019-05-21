//
//  NSArray+Ext.m
//  PocketMedicalManagement
//
//  Created by 虫虫乐 on 14-8-27.
//  Copyright (c) 2014年 com.XINZONG. All rights reserved.
//

#import "NSArrayExt.h"
#import "NSDictionaryExt.h"

@implementation NSArray (Ext)

- (NSString *)jsonValue
{
    NSString* result = @"[";
    for (NSDictionary* dic in self) {
        NSString* tmp = [dic jsonValue];
        result = [tmp stringByAppendingString:@","];
    }
    result = [result substringToIndex:result.length - 1];
    result = [result stringByAppendingString:@"]"];
    if ([result compare:@"]"] == 0) {
        return nil;
    }else
        return result;
}

- (NSArray *)arrayByReplaceValue:(NSString *)value ForKey:(NSString *)key WithDic:(NSDictionary *)dic
{
    NSMutableArray* result = [self mutableCopy];
    NSString* fkey = [dic objectForKey:@"key"];
    NSString* fvalue = [dic objectForKey:@"value"];
    if (fkey.length) {
        for (int index = 0; index < result.count; index++) {
            NSMutableDictionary* vdic = [[result objectAtIndex:index] mutableCopy];
            if ([[vdic allKeys] containsObject:fkey] && [[vdic objectForKey:fkey] isEqualToString:fvalue]) {
                [vdic setObject:value forKey:key];
                [result replaceObjectAtIndex:index withObject:vdic];
            }
        }
    }
    return result;
}

@end
