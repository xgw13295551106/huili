//
//  YHHelpper.h
//  benben
//
//  Created by xunao on 15-2-27.
//  Copyright (c) 2015年 xunao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface YHHelpper : NSObject
//去掉空格
+(NSString*)trim:(NSString*)string;
+(NSMutableDictionary*)ReadAllPeoples;
+ (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText;
+ (NSString *) phonetic:(NSString*)sourceString;

/**md5加密**/
+(NSString *)md5:(NSString *)str;
/**判断手机格式**/
+(BOOL)isMobileNumber:(NSString *)mobileNum;
/**计算文字高度**/
+(CGSize)textSizeWithMaxSize:(CGSize)maxSize font:(UIFont *)font text:(NSString *)text;
/**获取当前root**/
+ (UIViewController *)getCurrentVC;
/**判断是否为纯数字**/
+(BOOL)isNumber:(NSString*)string;
/**判断是否为浮点**/
+(BOOL)isPureFloat:(NSString*)string;
/**判断是否为整形**/
+ (BOOL)isPureInt:(NSString*)string;
/**打电话**/
+(void)callPhoneAlert:(NSString*)phone setTitle:(NSString*)title;
/**字典转Json字符串**/
+ (NSString*)convertToJSONData:(id)infoDict;
/**JSON字符串转化为字典**/
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
/**请先登录**/
+(void)alertLogin;
/**在其他设备生登录**/
+(void)alertLoginOrther;
/**
 * 字母、数字、中文正则判断（不包括空格）
 */
+ (BOOL)isInputRuleNotBlank:(NSString *)str;


/**
 * 获取热门搜索
 */
+(void)getHotKey;

@end
