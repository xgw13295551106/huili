//
//  Fram.m
//  benben
//
//  Created by xunao on 15-3-2.
//  Copyright (c) 2015年 xunao. All rights reserved.
//

#import "Frame.h"
#import "sys/utsname.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@implementation Frame

//处理sql语句中单引号
+(NSString *)checkSqlStr:(NSString *)str
{
    return [str stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
}

+(NSString *)transformDisplayDate:(int)time
{
    if (time >= 0) {
        int nowtime = [[NSDate date] timeIntervalSince1970];
        int pasttime = nowtime - time;
        if (pasttime > 0) {
            
            int years = pasttime/(60*60*24*30*12);
            if (years > 0) {
                //大于一月
                return [NSString stringWithFormat:@"%d年前", years];
            }
            
            int months = pasttime/(60*60*24*30);
            if (months > 0) {
                //大于一月
                return [NSString stringWithFormat:@"%d月前", months];
            }
            
            int days = pasttime/(60*60*24);
            if (days > 0) {
                //大于一天
                return [NSString stringWithFormat:@"%d天前", days];
            }
            int hours = pasttime/(60*60);
            if (hours > 0) {
                return [NSString stringWithFormat:@"%d小时前", hours];
            }
            
            int mins = pasttime/60;
            if (mins > 0) {
                return [NSString stringWithFormat:@"%d分钟前", mins];
            }else {
                return @"刚刚";
            }
        }
        return @"刚刚";
    }
    return @"--";
}

+(NSString *)formatNumber:(int)number
{
    
    if (number <= 0) {
        return @"0";
    }
    NSString *result = @"";
    while (number > 0) {
        NSString *str = [Frame lastCountString:number];
        number = number/1000;
        if (number > 0) {
            result = [NSString stringWithFormat:@",%@%@", str, result];
        }else {
            result = [NSString stringWithFormat:@"%@%@", str, result];
        }
    }
    return result;
}
//取数字后三位
+(NSString *)lastCountString:(int)count
{
    NSMutableString *result = [NSMutableString string];
    int last = count%1000;
    int left = count/1000;
    if (left > 0) {
        [result appendFormat:@"%03d",last];
    }else {
        [result appendFormat:@"%i",last];
    }
    return result;
}


+(BOOL)deleteFileWithFullPath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:filePath error:nil];
}

+(NSString *)getLibraryFilePathWithFolder:(NSString *)folder fileName:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *dir = [paths objectAtIndex:0];
    NSString *gPath = [dir stringByAppendingPathComponent:folder];
    if (![[NSFileManager defaultManager] fileExistsAtPath:gPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:gPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [gPath stringByAppendingPathComponent:fileName];
}

+(NSString *)getDownloadPath:(NSString *)urlString
{
    NSString *fileName = [urlString lastPathComponent];
    
    NSString *dir = NSHomeDirectory();
    NSString *gPath = [dir stringByAppendingPathComponent:@"tmp/download_cache/"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:gPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:gPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [gPath stringByAppendingPathComponent:fileName];
}

+(BOOL)isFileExist:(NSString *)fullPath
{
    BOOL iexst = NO;
    if (fullPath != NULL && fullPath.length > 0) {
        iexst = [[NSFileManager defaultManager] fileExistsAtPath:fullPath];
    }
    return iexst;
}

//正则匹配
+(BOOL)regularMatch:(NSString *)regex string:(NSString *)string
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:string];
}

+(BOOL)isIdCard:(NSString *)number
{
    if ([NSString trimEmpty:number]) {
        return NO;
    }
    return [Frame regularMatch:@"^\\d{17}([0-9]|X|x)$" string:number];
}

+(BOOL)isValidateEmail:(NSString *)email

{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}

//去掉空格
+(NSString*)trim:(NSString*)string{
    NSString *newString = [string stringByTrimmingCharactersInSet:
                           [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return newString==nil?@"":newString;
}
//读取所有联系人
+(NSMutableDictionary*)ReadAllPeoples
{
    //取得本地通信录名柄
    ABAddressBookRef tmpAddressBook = nil;
    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0) {
        tmpAddressBook=ABAddressBookCreateWithOptions(NULL, NULL);
        dispatch_semaphore_t sema=dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(tmpAddressBook, ^(bool greanted, CFErrorRef error){
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    else
    {
        tmpAddressBook =ABAddressBookCreateWithOptions;
    }
    if (tmpAddressBook==nil) {
        return nil ;
    };
    NSArray* tmpPeoples = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(tmpAddressBook);
    NSString *phone=@"";
    for(id tmpPerson in tmpPeoples)
    {
        if (phone.length>0) {
            phone=[phone stringByAppendingString:@"|"];
        }
        NSString* tmpFirstName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonFirstNameProperty);
        //获取的联系人单一属性:Last name
        NSString* tmpLastName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonLastNameProperty);
        if (tmpFirstName==nil) {
            tmpFirstName=@"";
        }if (tmpLastName==nil) {
            tmpLastName=@"";
        }
        NSString *userName=[tmpLastName stringByAppendingString:tmpFirstName];
        //获取的联系人单一属性:Generic phone number
        ABMultiValueRef tmpPhones = ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonPhoneProperty);
        NSString* tmpPhoneIndex=@"";
        for(int j = 0; j < ABMultiValueGetCount(tmpPhones); j++)
        {
            if (j>0) {
                tmpPhoneIndex=[tmpPhoneIndex stringByAppendingString:@"#"];
            }
            NSString *tmpPhoneMid = (__bridge NSString*)ABMultiValueCopyValueAtIndex(tmpPhones, j);
            //            NSLog(@"tmpPhoneIndex%d:%@", j, tmpPhoneIndex);
            tmpPhoneMid = [tmpPhoneMid stringByReplacingOccurrencesOfString:@"-" withString:@""];
            tmpPhoneIndex=[tmpPhoneIndex stringByAppendingString:[NSString stringWithFormat:@"%@",tmpPhoneMid]];
        }
        phone=[phone stringByAppendingString:[NSString stringWithFormat:@"%@::%@",tmpPhoneIndex,userName]];
        CFRelease(tmpPhones);
    }
    CFRelease(tmpAddressBook);
    //    NSLog(@"%@",phone);
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:@"" forKey:@"group"];
    [param setValue:phone forKey:@"phone"];
    return param;
}
+ (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    float fPadding = 16.0; // 8.0px x 2
    CGSize constraint = CGSizeMake(textView.contentSize.width - fPadding, CGFLOAT_MAX);
    
    CGSize size = [strText sizeWithFont: textView.font constrainedToSize:constraint lineBreakMode:NSLineBreakByCharWrapping];
    
    float fHeight = size.height + 16.0;
    
    return fHeight;
}
+ (NSString *) phonetic:(NSString*)sourceString {
    NSString *str;
    sourceString=[self trim:sourceString];
    if (sourceString.length) {
        NSString *txt = [sourceString substringToIndex:1];
        NSMutableString *source = [txt mutableCopy];
        CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
        str = [source substringToIndex:1];
        str=[str stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[str substringToIndex:1] uppercaseString]];
        
    }else{
        str=@"#";
    }
    
    return str;
    
}

+(NSString *)unit:(int)num
{
    NSString *str;
    if (num<1000) {
        str = [NSString stringWithFormat:@"%.1f千",num/1000.0];
    }else
    {
        str = [NSString stringWithFormat:@"%.1f万",num/10000.0];
    }
    return str;
}

+(NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (int)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
/**
 *  手机号码验证
 *
 *  @param mobileNumbel 传入的手机号码
 *
 *  @return 格式正确返回true  错误 返回fals
 */
+ (BOOL)isMobile:(NSString *)mobileNumbel{
    /**
     * 移动号段正则表达式
     */
    NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
    /**
     * 联通号段正则表达式
     */
    NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(171)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
    /**
     * 电信号段正则表达式
     */
    NSString *CT_NUM = @"^((133)|(153)|(177)|(170)|(173)|(18[0,1,9]))\\d{8}$";
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
    BOOL isMatch1 = [pred1 evaluateWithObject:mobileNumbel];
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
    BOOL isMatch2 = [pred2 evaluateWithObject:mobileNumbel];
    NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
    BOOL isMatch3 = [pred3 evaluateWithObject:mobileNumbel];
    
    if (isMatch1 || isMatch2 || isMatch3) {
        return YES;
    }else{
        return NO;
    }
}

+(BOOL)isMobileAndNum:(NSString *)mobileNum
{
    /**
     * 移动号段正则表达式
     */
    NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
    /**
     * 联通号段正则表达式
     */
    NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(171)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
    /**
     * 电信号段正则表达式
     */
    NSString *CT_NUM = @"^((133)|(153)|(177)|(170)|(18[0,1,9]))\\d{8}$";
    
    /**
     * 大陆地区固话及小灵通
     */
    
    NSString *PHS_NUM = @"^0((10|2[0-5789]|\\d{3})|(10|2[0-5789]|\\d{3})-)\\d{7,8}$";
    
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
    BOOL isMatch1 = [pred1 evaluateWithObject:mobileNum];
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
    BOOL isMatch2 = [pred2 evaluateWithObject:mobileNum];
    NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
    BOOL isMatch3 = [pred3 evaluateWithObject:mobileNum];
    NSPredicate *pred4 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS_NUM];
    BOOL isMatch4 = [pred4 evaluateWithObject:mobileNum];
    
    if (isMatch1 || isMatch2 || isMatch3 || isMatch4) {
        return YES;
    }else{
        return NO;
    }
    
}


@end
///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation NSUserDefaults (custom)

-(NSString *)hstringForKey:(id)aKey
{
    id obj = [self objectForKey:aKey];
    if (obj==[NSNull null] || obj==nil) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@",obj];
}

@end

@implementation NSDictionary (custom)

-(id)objectForKeyCheckNull:(id)aKey
{
    id value = [self objectForKey:aKey];
    if ([value isEqual:[NSNull null]]) {
        return nil;
    }
    return value;
}

-(id)objectForKey:(id)aKey DefaultValue:(id)value
{
    id obj = [self objectForKey:aKey];
    if (obj==[NSNull null] || obj==nil) {
        return value;
    }
    return obj;
}

-(NSInteger)integerForKey:(id)aKey
{
    id value = [self objectForKeyCheckNull:aKey];
    return [value integerValue];
}

-(int)intForKey:(id)aKey
{
    id value = [self objectForKeyCheckNull:aKey];
    if (value) {
        return [value intValue];
    }
    return 0;
}

-(NSString *)stringForKey:(id)aKey
{
    id obj = [self objectForKey:aKey];
    if (obj==[NSNull null] || obj==nil) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@",obj];
}

-(NSDictionary *)dictForKey:(id)akey{
    id value = [self objectForKeyCheckNull:akey];
    if (value && [value isKindOfClass:[NSDictionary class]]) {
        return value;
    }
    return [NSDictionary dictionary];
}

-(NSArray *)arrayForKey:(id)akey
{
    id value = [self objectForKeyCheckNull:akey];
    if (value && [value isKindOfClass:[NSArray class]]) {
        return value;
    }
    return [NSArray array];
}
@end
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation NSString (custom)

+(NSString *)stringWithStringCheckNull:(NSString *)value
{
    if (value != nil && value.length > 0) {
        return [NSString stringWithString:value];
    }
    return @"";
}

+(NSString *)stringWithInt:(int)value
{
    return [NSString stringWithFormat:@"%i", value];
}

+(BOOL)trimEmpty:(NSString *)str
{
    NSString *trimStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return (trimStr == nil || trimStr.length <= 0);
}


-(NSString *)stringByReplacePathExtension:(NSString *)extensions
{
    if (self && self.length > 0) {
//        NSString *ext = [self pathExtension];
        NSString *newPath = [self stringByDeletingPathExtension];
        return [newPath stringByAppendingPathExtension:extensions];
    }
    return @"";
}

-(BOOL)isContainsEmoji
{
    __block BOOL isEomji = NO;
    
    if (self && self.length > 0) {
        
        [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
         
         ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
             
             const unichar hs = [substring characterAtIndex:0];
             
             // surrogate pair
             
             if (0xd800 <= hs && hs <= 0xdbff) {
                 
                 if (substring.length > 1) {
                     
                     const unichar ls = [substring characterAtIndex:1];
                     
                     const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                     
                     if (0x1d000 <= uc && uc <= 0x1f77f) {
                         
                         isEomji = YES;
                         
                     }
                     
                 }
                 
             } else if (substring.length > 1) {
                 
                 const unichar ls = [substring characterAtIndex:1];
                 
                 if (ls == 0x20e3 || ls == 0xfe0f) {
                     
                     isEomji = YES;
                     
                 }
                 
             } else {
                 
                 // non surrogate
                 
                 if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                     
                     isEomji = YES;
                     
                 } else if (0x2B05 <= hs && hs <= 0x2b07) {
                     
                     isEomji = YES;
                     
                 } else if (0x2934 <= hs && hs <= 0x2935) {
                     
                     isEomji = YES;
                     
                 } else if (0x3297 <= hs && hs <= 0x3299) {
                     
                     isEomji = YES;
                     
                 } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                     
                     isEomji = YES;
                     
                 }
                 
             }
             
         }];

    }
    
    return isEomji;

}

-(int)chineseLength
{
    int strlength = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
}

+ (BOOL)isChinese:(NSString *)str
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:str];
}

@end


///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation UIDevice (ALSystemVersion)

+ (float)iOSVersion {
    static float version = 0.f;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        version = [[[UIDevice currentDevice] systemVersion] floatValue];
    });
    return version;
}

+(NSString *)deviceModel
{
    //here use sys/utsname.h
    struct utsname systemInfo;
    //声明结构体，包含5个char数成员:sysname,nodename,release,version,machine
    uname(&systemInfo);
    //c方法，填写系统结构体内容，返回值为0，表示成功。
    //get the device model and the system version
    
    //    NSLog(@"%@", [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding]);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"]) return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"]) return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"]) return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"]) return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"]) return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"]) return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])  return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    
    return platform;
}

@end


///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation UIImage (CustomExtend)

+(UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect
{
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    return newImage;
}


+(UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2
{
    UIGraphicsBeginImageContext(image1.size);
    
    // Draw image1
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    
    // Draw image2
    [image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}


//根据颜色返回图片
+(UIImage*) imageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation UIColor (CustomColor)

+(UIColor *)randomColor
{
    return [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
}

@end

#pragma mark ColorFrom16
@implementation UIColor (ColorFrom16)

+ (UIColor *) colorWithHexString:(NSString *)hexstr alpha:(CGFloat)alphaValue
{
    NSScanner *scanner;
    unsigned int rgbval;
    scanner = [NSScanner scannerWithString: hexstr];
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    [scanner scanHexInt: &rgbval];
    return [UIColor colorWithHex: rgbval alpha:alphaValue];
}


+ (UIColor*) colorWithHexString:(NSString *)hexstr
{
    return [UIColor colorWithHexString:hexstr alpha:1.0f];
}

// 0xff ff ff
+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}

+ (NSString *) hexFromUIColor: (UIColor*) color {
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0]
                                green:components[0]
                                 blue:components[0]
                                alpha:components[1]];
    }
    
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    
    return [NSString stringWithFormat:@"#%x%x%x", (int)((CGColorGetComponents(color.CGColor))[0]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[1]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
}

- (UIColor *)darkerColor
{
    return [UIColor colorWithRed:CGColorGetComponents(self.CGColor)[0] - 20 green:CGColorGetComponents(self.CGColor)[1] - 20 blue:CGColorGetComponents(self.CGColor)[2] - 20 alpha:CGColorGetComponents(self.CGColor)[3]];
}

- (UIColor *)lighterColor
{
    return [UIColor colorWithRed:CGColorGetComponents(self.CGColor)[0] + 20 green:CGColorGetComponents(self.CGColor)[1] + 20 blue:CGColorGetComponents(self.CGColor)[2] + 20 alpha:CGColorGetComponents(self.CGColor)[3]];
}

@end
///////////////////////////////////////////////////////////////////////////////////////////////////



@implementation UIView (custom)

-(void)removeAllSubviews
{
    while ([self.subviews count] > 0) {
        [[self.subviews objectAtIndex:0] removeFromSuperview];
    }
}

@end

@implementation UILabel (autosize)

- (void)autoSizeWithType:(BOOL)type{
    //
    if (self.frame.size.width==0 &&self.frame.size.height==0 ) {
        NSLog(@"label的初始frame未设置");
        return;
    }
    //
    CGFloat label_x = self.frame.origin.x;
    CGFloat label_y = self.frame.origin.y;
    CGFloat label_width = self.frame.size.width;
    CGFloat label_height = self.frame.size.height;
    //
    self.numberOfLines = 0;
    self.lineBreakMode = NSLineBreakByTruncatingTail;
    //
    CGSize maximumLabelSize;
    if (type) {
        maximumLabelSize = CGSizeMake(label_width, 9999);
        CGSize expectSize = [self sizeThatFits:maximumLabelSize];
        
        self.frame = CGRectMake(label_x, label_y, label_width, expectSize.height);
    }else{
        maximumLabelSize = CGSizeMake(9999, label_height);
        CGSize expectSize = [self sizeThatFits:maximumLabelSize];
        
        self.frame = CGRectMake(label_x, label_y, expectSize.width, label_height);
    }
    
}
@end
#pragma mark - UIView+Frame 分类整合
@implementation UIView (Frame)

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (void)setX:(CGFloat)x
{
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
    
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
    
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
    
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
    
}

- (CGFloat)height
{
    return self.frame.size.height;
}


- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}
- (void)alignHorizontal
{
    self.x = (self.superview.width - self.width) * 0.5;
}

- (void)alignVertical
{
    self.y = (self.superview.height - self.height) *0.5;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    
    if (borderWidth < 0) {
        return;
    }
    self.layer.borderWidth = borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

- (BOOL)isShowOnWindow
{
    //主窗口
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    //相对于父控件转换之后的rect
    CGRect newRect = [keyWindow convertRect:self.frame fromView:self.superview];
    //主窗口的bounds
    CGRect winBounds = keyWindow.bounds;
    //判断两个坐标系是否有交汇的地方，返回bool值
    BOOL isIntersects =  CGRectIntersectsRect(newRect, winBounds);
    if (self.hidden != YES && self.alpha >0.01 && self.window == keyWindow && isIntersects) {
        return YES;
    }else{
        return NO;
    }
}

- (CGFloat)borderWidth
{
    return self.borderWidth;
}

- (UIColor *)borderColor
{
    return self.borderColor;
    
}

- (CGFloat)cornerRadius
{
    return self.cornerRadius;
}

- (UIViewController *)parentController
{
    UIResponder *responder = [self nextResponder];
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

- (void)addTarget:(id)target
           action:(SEL)action;
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:target
                                                                         action:action];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
}
    
    /**1-left 2-top 3-wid 4-height*/
- (void)resetFrameWithType:(NSInteger)type andValue:(CGFloat)value{
    switch (type) {
        case 1:
        {
            self.frame = CGRectMake(value, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        }
        break;
        case 2:
        {
            self.frame = CGRectMake(self.frame.origin.x, value, self.frame.size.width, self.frame.size.height);
        }
        break;
        case 3:
        {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, value, self.frame.size.height);
        }
        break;
        case 4:
        {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, value);
        }
        break;
        
        default:
        break;
    }
}

@end
