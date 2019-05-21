//
//  LCTools.m
//  ios_demo
//
//  Created by 刘翀 on 16/4/8.
//  Copyright © 2016年 xinhuo. All rights reserved.
//

#import "LCTools.h"
#import<SystemConfiguration/SCNetworkReachability.h>
#import <MapKit/MapKit.h>
#import "CRSA.h"

@implementation LCTools
//RSA加密
+(NSString *)rsaEncryptStr:(NSString *)str
{
    //    NSString *encryptString = [RSA encryptString:str publicKey:RSA_PUBLIC_KEY];
    NSString *encryptString = [[CRSA shareInstance]encryptByRsa:str withKeyType:KeyTypePublic];
    return encryptString;
}

//获取沙河路径
+ (NSString *)getPathwithPathComponent:(NSString *)fileName
{
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *path=[docPath stringByAppendingPathComponent:fileName];
    return path;
}

// 获取Caches目录路径
+ (NSString *)getCachesPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
    NSString *cachesDir = [paths lastObject];
    return cachesDir;
}

//获得日期
+(NSString *)getTimewithdate:(NSString *)datetime andWithDateStyle:(NSString *)datestyle{
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    
    [dateformatter setDateFormat:datestyle];
    
    NSDate *timedate = [NSDate dateWithTimeIntervalSince1970:[datetime intValue]];
    
    NSString *timestring = [dateformatter stringFromDate:timedate];
    
    return timestring;
    
}
//获取当前日期
+(NSString *)getCurrentTime
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateformatter stringFromDate:date];
}
//验证手机号码是否合法
+(BOOL)isValablePhone:(NSString *)mobile{

    //    电信号段:133/153/180/181/189/177
    
    //    联通号段:130/131/132/155/156/185/186/145/176
    
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    
    //    虚拟运营商:170
    
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject:mobile];
    
    
}

//计算时间差
+(NSString *)twoTimeInterval:(NSString *)specailTime{
    
    NSTimeInterval nowdateinterval = [[NSDate date] timeIntervalSince1970];
    
    int cha = [specailTime intValue] - (int)nowdateinterval;
    
    BOOL isBefore;
    
    if(cha<0){ //在当前时间之前
        
        isBefore =YES;
        
    }else{
        
        isBefore =NO;
    }
    
    cha = abs(cha);
    
    NSString *timeString;
    
    if (cha<3600) {
        timeString = [NSString stringWithFormat:@"%f", cha/60.0];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@分钟", timeString];
        
    }
    if (cha>=3600&&cha<86400) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600.0];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时", timeString];
    }
    if (cha>=86400)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400.0];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@天", timeString];
        
    }
    
    if (isBefore) {
        
        timeString = [NSString stringWithFormat:@"%@前",timeString];
        
    }else{
        
        timeString = [NSString stringWithFormat:@"剩余%@",timeString];
        
    }
    
    return timeString;
    
}

+ (NSString *)getAgeWithBirthDay:(NSString *)birthDay{
    if ([NSString stringIsNull:birthDay]) {
        return @"未知";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //生日
    NSDate *currentDate = [dateFormatter dateFromString:birthDay];
    
    //补充知识 从nsdate中分割出年月日
    // 出生日期转换 年月日
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:currentDate];
    NSInteger brithDateYear  = [components1 year];//获取年
    //NSInteger brithDateDay   = [components1 day];//获取日
    //NSInteger brithDateMonth = [components1 month];//获取月份
    
    // 获取当前时间 年月日
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger currentDateYear  = [components2 year];
    
    // 计算年龄
    NSInteger iAge = currentDateYear-brithDateYear;
    
    return [NSString stringWithFormat:@"%li",iAge];
}
//得到详细生日
+ (NSString *)getDetailAgeWithBirthDay:(NSString *)birthDay{
    if ([NSString stringIsNull:birthDay]) {
        return @"未知";
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    
    NSDate *nowDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //生日
    NSDate *birthData = [dateFormatter dateFromString:birthDay];
    
    //用来得到详细的时差
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitSecond | NSCalendarUnitSecond;
    NSDateComponents *date = [calendar components:unitFlags fromDate:birthData toDate:nowDate options:0];
    NSString *detailAge = nil;
    if([date year] >0)
    {
        detailAge = [NSString stringWithFormat:(@"%ld岁%ld月%ld天"),(long)[date year],(long)[date month],(long)[date day]];
        NSLog(@"%@",[NSString stringWithFormat:(@"%ld岁%ld月%ld天"),(long)[date year],(long)[date month],(long)[date day]]) ;
    }
    else if([date month] >0)
    {
        detailAge = [NSString stringWithFormat:(@"%ld月%ld天"),(long)[date month],(long)[date day]];
        NSLog(@"%@",[NSString stringWithFormat:(@"%ld月%ld天"),(long)[date month],(long)[date day]]);
    }
    else if([date day]>0){
        detailAge = [NSString stringWithFormat:(@"%ld天"),(long)[date day]];
        NSLog(@"%@",[NSString stringWithFormat:(@"%ld天"),(long)[date day]]);
    }
    else {
        detailAge = @"0天";
        NSLog(@"0天");
    }
    return detailAge;
}


//身份证号
+ (BOOL)validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

//判断设备是否联网
+ (BOOL)connectedToNetwork
{
    //创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    
    struct sockaddr_storage zeroAddress;//IP地址
    
    bzero(&zeroAddress, sizeof(zeroAddress));//将地址转换为0.0.0.0
    zeroAddress.ss_len = sizeof(zeroAddress);//地址长度
    zeroAddress.ss_family = AF_INET;//地址类型为UDP, TCP, etc.
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    //获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    //如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags)
    {
        return NO;
    }
    //根据获得的连接标志进行判断
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable&&!needsConnection) ? YES : NO;
    
    /*
     1、sockaddr_storage
     This structure stores socket address information. Because this structure is large enough to store IPv4 or IPv6 address information, its use promotes protocol-family and protocol-version independence, and simplifies cross-platform development. Use this structure in place of the sockaddr structure.
     
     2、
     extern void bzero（void *s, int n）;
     用法：#include <string.h>
     功能：置字节字符串s的前n个字节为零且包括‘\0’。
     说明：bzero无返回值，并且使用string.h头文件，string.h曾经是posix标准的一部分，但是在POSIX.1-2001标准里面，
     这些函数被标记为了遗留函数而不推荐使用。在POSIX.1-2008标准里已经没有这些函数了。推荐使用memset替代bzero。
     
     bzero( &tt, sizeof( tt ) );      //等价于memset(&tt,0,sizeof(tt));
     bzero( s, 20 );                  //等价于memset(s,0,20);
     
     */
}

//邮箱地址的正则表达式
+ (BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
//隐藏制定位置的文字
+ (NSString *)encryptLoanerInfoWith:(NSString *)string byRange:(NSRange)range{
    if (range.location+range.length > string.length) {
        if (range.location>string.length) {
            return string;
        }else{
            range = NSMakeRange(range.location, string.length-range.location);
        }
    }
    NSString *replyString = @"";
    for (int i = 0; i<range.length; i++) {
        replyString = [replyString stringByAppendingString:@"*"];
    }
    
    return [string stringByReplacingCharactersInRange:range withString:replyString];
}
//时间倒计时
+(NSString*)timerFireMethod:(NSDate *)timeDate{
    
    NSDate *startDate = [NSDate date];//得到当前时间
    NSDate *toDate=timeDate;//[NSDate dateWithTimeIntervalSince1970:time];
    NSCalendar* chineseClendar = [[NSCalendar alloc ] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //NSUInteger unitFlags = NSCalendarUnitHour | NSCalendarUnitMonth | NSCalendarUnitSecond | NSCalendarUnitDay | NSCalendarUnitMinute | NSCalendarUnitYear; //需要得到哪些就写哪些
    NSUInteger unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *cps = [chineseClendar components:unitFlags fromDate:startDate  toDate: toDate options:0];
    NSInteger diffHour = [cps hour];
    NSInteger diffMin    = [cps minute];
    NSInteger diffSec   = [cps second];
    NSInteger diffDay   = [cps day];
    NSInteger diffMon  = [cps month];
    NSInteger diffYear = [cps year];
    //返回格式化的string
//    NSString *countdown = [NSString stringWithFormat:@"%ld天 %ld小时 %ld分钟 %ld秒", diffDay,diffHour, diffMin, diffSec];
    diffHour = diffHour<0?0:diffHour;
    diffMin = diffMin<0?0:diffMin;
    diffSec = diffSec<0?0:diffSec;
    NSString *countdown = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", diffHour, diffMin, diffSec];
    if (diffSec<0) {
        countdown=[NSString stringWithFormat:@"00:00:00"];
    }
    return countdown;
}
//根据还剩多少秒，返回倒计时天-时-分-秒
+ (NSString *)getLeftTimeWithSecond:(NSString *)secondString{
    long totalSecond = [secondString longLongValue];
    if (totalSecond == 0) {
        return @"已结束";
    }
    //首先得到有多少天
    long day = totalSecond/(3600 *24);
    //得到天后还有多少小时
    long hour = totalSecond%(3600 *24) / 3600;
    //接着得到多少分
    long minute  = totalSecond%(3600 *24) %3600 /60;
    //最后得到还有多少秒
    long second = totalSecond%(3600 *24) %3600 %60;
    NSString *leftTimeString = [NSString stringWithFormat:@"%li天%li时%li分%li秒",day,hour,minute,second];
    return leftTimeString;
}

#pragma mark - 下面两个获取文件大小的返回值都是数据类型,可以用NSString stringWithFormat转换成字符串
//单个文件的大小
+ (long long) fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil]  fileSize];
    }
    return 0;
}


- (long long) fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil]  fileSize];
    }
    return 0;
}

//遍历文件夹获得文件夹大小，返回多少M
+ (float ) folderSizeAtPath:(NSString*) folderPath{
    
    NSFileManager* manager = [NSFileManager   defaultManager];
    
    if (![manager  fileExistsAtPath:folderPath]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    
    NSString* fileName;
    
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
        
    }
    
    return folderSize/(1024.0*1024.0);
    
}

#pragma mark - 清除缓存的方法
+(void)clearCache:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    
    // 这个是清除SDWebImage的缓存的,没有引用这个第三方类库不用写
    //[[SDImageCache sharedImageCache] clearMemory];
}

//获取当前屏幕显示的viewcontroller
//获取顶层vc
+(UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    //    如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        
        NSLog(@"===%@",[window subviews]);
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        //        UINavigationController * nav = tabbar.selectedViewController ; 上下两种写法都行
        result=nav.childViewControllers.lastObject;
        
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{
        result = nextResponder;
    }
    return result;
}



+(CGSize)textSizeWithMaxSize:(CGSize)maxSize font:(UIFont *)font text:(NSString *)text
{
    NSDictionary *dict = @{NSFontAttributeName:font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
}

@end
