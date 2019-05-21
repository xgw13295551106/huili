//
//  NSDate+Ext.m
//  PocketMedicalManagement
//
//  Created by AaronLee on 14-9-9.
//  Copyright (c) 2014年 com.XINZONG. All rights reserved.
//

#import "NSDateExt.h"

@implementation NSDate (Ext)

- (NSInteger)weekDay
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:(NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit) fromDate:self];
    NSInteger weekday = [components weekday] - 1;
    return weekday;
}

- (NSString*)weekDayTodayByLanguage:(NSString *)lan
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE"];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:lan]];
    //[formatter setLocalizedDateFormatFromTemplate:lan];
    NSString* weekday = [formatter stringFromDate:self];
    return weekday;
}

@end
