//
//  NSArray+Ext.h
//  PocketMedicalManagement
//
//  Created by 虫虫乐 on 14-8-27.
//  Copyright (c) 2014年 com.XINZONG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Ext)

/*
 * Tip：将字典转化成json字符串
 * Return：转化后的json串 - "key":"value","key":"value"
 * Note：数组必须是字典数组，否则返回nil
 */
- (NSString*)jsonValue;

/*
 * Tip：替换数组中元素的value
 * Params：value - 将被替换成的值
 *         key   - 被替换的值对应的key
 *         dic   - 筛选条件，替换数组中满足dic的条件的字典中的键为key的值为value
 * Return：被替换后的数组
 * Note：dic 目前只支持一个筛选条件 格式为{"key":"key","value":"value"}
 */
- (NSArray*)arrayByReplaceValue:(NSString*)value ForKey:(NSString*)key WithDic:(NSDictionary*)dic;

@end
