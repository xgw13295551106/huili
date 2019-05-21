//
//  Fram.h
//  benben
//
//  Created by xunao on 15-3-2.
//  Copyright (c) 2015年 xunao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>

@interface Frame : NSObject

//处理sql语句中单引号
+(NSString *)checkSqlStr:(NSString *)str;
//时间戳转换成xx前
+(NSString *)transformDisplayDate:(int)time;
//数字添加逗号分隔符
+(NSString *)formatNumber:(int)number;
//删除文件
+(BOOL)deleteFileWithFullPath:(NSString *)filePath;
//获取下载地址
+(NSString *)getDownloadPath:(NSString *)urlString;
//文件是否存在
+(BOOL)isFileExist:(NSString *)fullPath;
//获取Library下路径
+(NSString *)getLibraryFilePathWithFolder:(NSString *)folder fileName:(NSString *)fileName;
//正则匹配
+(BOOL)regularMatch:(NSString *)regex string:(NSString *)string;
//身份证
+(BOOL)isIdCard:(NSString *)number;

//去掉空格
+(NSString*)trim:(NSString*)string;
+(NSMutableDictionary*)ReadAllPeoples;
+ (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText;
+ (NSString *) phonetic:(NSString*)sourceString;

/**md5加密**/
+(NSString *)md5:(NSString *)str;
+(NSString *)unit:(int)num;
/**判断手机格式**/
+ (BOOL)isMobile:(NSString *)mobileNumbel;
/**判断手机或者固话**/
+(BOOL)isMobileAndNum:(NSString *)mobileNum;
/**判断邮箱格式**/
+(BOOL)isValidateEmail:(NSString *)email;

@end

@interface NSDictionary (custom)
-(id)objectForKeyCheckNull:(id)aKey;
-(id)objectForKey:(id)aKey DefaultValue:(id)value;
-(NSInteger)integerForKey:(id)aKey;
-(int)intForKey:(id)aKey;
-(NSString *)stringForKey:(id)aKey;
-(NSDictionary *)dictForKey:(id)akey;
-(NSArray *)arrayForKey:(id)akey;

@end

@interface NSString (custom)
+(NSString *)stringWithStringCheckNull:(NSString *)value;
+(NSString *)stringWithInt:(int)value;
+(BOOL)trimEmpty:(NSString *)str;
-(NSString *)stringByReplacePathExtension:(NSString *)extensions;
//是否包含Emoji表情
-(BOOL)isContainsEmoji;
//中英混合文字长度
-(int)chineseLength;
+ (BOOL)isChinese:(NSString *)str;//判断是否是纯汉字
@end

@interface UIDevice (ALSystemVersion)
+ (float)iOSVersion;
+(NSString *)deviceModel;
@end

@interface UIImage (CustomExtend)

//根据颜色返回图片
+(UIImage*) imageWithColor:(UIColor*)color;

@end

@interface UIColor (CustomColor)

+(UIColor *)randomColor;

@end
#pragma mark ColorFrom16
@interface UIColor (ColorFrom16)

+ (UIColor *) colorWithHexString:(NSString *)hexstr;
+ (UIColor *) colorWithHexString:(NSString *)hexstr alpha:(CGFloat)alphaValue;
/*
 * Tip：根据0x值生成UIColor
 */
+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;

/*
 * Tip：返回UIColor的0x值
 */
+ (NSString *) hexFromUIColor: (UIColor*) color;
/*
 * Tip：返回当前颜色下偏暗的颜色，每次偏移20
 */
- (UIColor*)darkerColor;
/*
 * Tip：返回当前颜色下偏亮的颜色，每次偏移20
 */
- (UIColor*)lighterColor;

@end

@interface UIView (custom)

-(void)removeAllSubviews;

@end

@interface UILabel (autosize)

/**自适应label宽高，yes宽不变，no高不变*/
- (void)autoSizeWithType:(BOOL)type;

@end
#pragma mark - UIView+Frame 分类整合

IB_DESIGNABLE

@interface UIView (Frame)

@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat right;

@property(nonatomic,assign)CGFloat x;

@property(nonatomic,assign)CGFloat y;

@property(nonatomic,assign)CGFloat width;

@property(nonatomic,assign)CGFloat height;

@property (nonatomic, assign)CGFloat centerX;
@property (nonatomic, assign)CGFloat centerY;
@property (nonatomic, assign)CGSize size;
@property(nonatomic, assign) IBInspectable CGFloat borderWidth;
@property(nonatomic, assign) IBInspectable UIColor *borderColor;
@property(nonatomic, assign) IBInspectable CGFloat cornerRadius;

/**
 *  水平居中
 */
- (void)alignHorizontal;
/**
 *  垂直居中
 */
- (void)alignVertical;
/**
 *  判断是否显示在主窗口上面
 *
 *  @return 是否
 */
- (BOOL)isShowOnWindow;

- (UIViewController *)parentController;

- (void)addTarget:(id)target
           action:(SEL)action;

/**type为1-4分别表示 1-left 2-top 3-wid 4-height,value 为rect对应的值*/
- (void)resetFrameWithType:(NSInteger)type andValue:(CGFloat)value;
    
@end







