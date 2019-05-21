//
//  NSDate+Ext.h
//  PocketMedicalManagement
//
//  Created by AaronLee on 14-9-9.
//  Copyright (c) 2014年 com.XINZONG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Ext)

/*
 * Tip：获取日期是周几
 * Note：返回值顺序为周日 - 周六   值为0 - 6
 */
- (NSInteger)weekDay;

/*
 * Tip：获取日期是周几
 */
- (NSString*)weekDayTodayByLanguage:(NSString*)lan;

@end
