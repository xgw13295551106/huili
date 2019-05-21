//
//  NSDictionary+Ext.h
//  ALToolsTest
//
//  Created by AaronLee on 14-9-9.
//  Copyright (c) 2014年 com.AaronLee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Ext)

/*
 * Tip：将字典转化成json字符串
 * Return：转化后的json串 - "key":"value","key":"value"
 */
- (NSString*)jsonValue;

@end
