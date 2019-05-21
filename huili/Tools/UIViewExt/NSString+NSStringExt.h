//
//  NSString+NSStringExt.h
//  LKHealthManagerEnterprise
//
//  Created by AaronLee on 14-8-8.
//  Copyright (c) 2014年 com.XINZONG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSStringExt)

/*
 * Tip：判断字符串是不是[NSNull class] 或者@"<null>"
 */
- (BOOL)isNull;
/*
 *Tip: 判断字符串是不是包含aString
 */
- (BOOL)containsString:(NSString*)aString;

/*
 * Tip：目前只用到了 “,”所以只适配了“,”
 */
- (NSString*)removeLastSymbolIfNeeded;

/*
 * Tip：根据separater生成数组
 */
- (NSArray*)arrayWithSeparater:(NSString*)separater;
/*
 *Tip: 判断字符串是不是包含中文字符
 */
- (BOOL)containChinese;
/*
 *Tip: 将unicode字符集转换成中文
 */
- (NSString*)unicodeToChinese;
/*
 *Tip: 获取中英文混长度
 */
- (long)countOfChars;
/*
 *Tip: 字符串截取
*/
- (NSString*)substringToCharAtIndex:(int)index;
/*
 *Tip: md5
 */
- (NSString*)md5String;

- (NSString *)desEncryptWithKey:(NSString *)aKey;
- (NSString *)desDecryptWithKey:(NSString *)aKey;

- (NSString*)soapStringWithMethod:(NSString*)method;
@end
