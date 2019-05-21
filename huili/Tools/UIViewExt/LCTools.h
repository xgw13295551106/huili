//
//  LCTools.h
//  ios_demo
//
//  Created by 刘翀 on 16/4/8.
//  Copyright © 2016年 xinhuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface LCTools : NSObject

+(NSString *)rsaEncryptStr:(NSString *)str;
/**
 *  通过传入的字符串，获取要得到的沙盒路径
 *
 *  @param fileName 传入文件名
 *
 *  @return 返回沙盒里的文件的路径
 */
+ (NSString *)getPathwithPathComponent:(NSString *)fileName;
/**
 获取Caches目录路径

 @return 缓存路径
 */
+ (NSString *)getCachesPath;
/**
 *  获取当前日期
 *
 *  @return 返回当前日期（24小时制）
 */
+(NSString *)getCurrentTime;
/**
 *  验证手机号是否合法
 *
 *  @param mobile 传入的手机号
 *
 *  @return 返回yes or no
 */
+(BOOL)isValablePhone:(NSString *)mobile;
/**
 *  计算时间差（显示的是几小时前或几分钟前）
 *
 *  @param specailTime 传入一定的时间
 *
 *  @return 返回显示几天或几小时前
 */
+(NSString *)twoTimeInterval:(NSString *)specailTime;
/**
 *  判断设备是否联网
 *
 *  @return 返回YES OR NO
 */
+ (BOOL)connectedToNetwork;

/**
 根据出生年月判断多少岁

 @param birthDay 生日 （格式:yyyy-MM-dd）

 @return 返回岁数
 */
+ (NSString *)getAgeWithBirthDay:(NSString *)birthDay;


/**
 根据出生年月判断岁数（详细到天）

 @param birthDay 生日（格式：yyyy-MM-dd）

 @return 返回岁数
 */
+ (NSString *)getDetailAgeWithBirthDay:(NSString *)birthDay;


/**
 检查邮箱格式是否正确

 @param email 邮箱string

 @return 返回YES OR NO
 */
+ (BOOL)isValidateEmail:(NSString *)email;

/**
 隐藏字符串中指定位置的文字

 @param string 要隐藏的string
 @param range  要隐藏的范围

 @return 返回隐藏后的文字
 */
+ (NSString *)encryptLoanerInfoWith:(NSString *)string byRange:(NSRange)range;

/**
 时间倒计时

 @param time 时间戳
 @return 返回天 时 分 秒格式的剩余时间
 */
+(NSString*)timerFireMethod:(NSDate *)timeDate;

/**
 根据多少秒，格式化返回倒计时天-时-分-秒

 @param second  还剩秒数
 @return 天-时-分-秒
 */
+ (NSString *)getLeftTimeWithSecond:(NSString *)second;

/**
 获取单个文件大小

 @param filePath 文件路径
 @return 返回大小数值
 */
+ (long long) fileSizeAtPath:(NSString*) filePath;

/**
 获取文件夹的文件大小，返回多少M（用于缓存）

 @param folderPath 文件夹路径
 @return 返回多少M
 */
+ (float) folderSizeAtPath:(NSString*) folderPath;

/**
 清除文件

 @param path 文件或文件夹的路径
 */
+(void)clearCache:(NSString *)path;

/**获取当前屏幕显示的viewcontroller*/
+(UIViewController *)getCurrentVC;


/**
 计算文字高度

 @param maxSize MAXFLOAT最大size
 @param font 文字大小
 @param text 文字内容
 @return 文字尺寸
 */
+(CGSize)textSizeWithMaxSize:(CGSize)maxSize font:(UIFont *)font text:(NSString *)text;

@end
