//
//  NSString+LCJudgeNumber.m
//  ios_demo
//
//  Created by 刘翀 on 16/6/6.
//  Copyright © 2016年 xinhuo. All rights reserved.
//

#import "NSString+LCJudgeNumber.h"

@implementation NSString (LCJudgeNumber)

+ (BOOL)stringIsNull:(NSString *)string{
    //判断用户名是否为空
    if(string == nil){
        return YES;
    }
    if ([string isEqual:[NSNull null]]) {
        return YES;
    }
    NSString *str = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([str isEqualToString:@""]) {
        return YES;
    }
    return NO;//不为空
}


@end
