//
//  YHHelpper.m
//  benben
//
//  Created by xunao on 15-2-27.
//  Copyright (c) 2015年 xunao. All rights reserved.
//

#import "YHHelpper.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "BaseNavViewController.h"
#import "YHLoginViewController.h"

@implementation YHHelpper

/**
 * 字母、数字、中文正则判断（不包括空格）
 */
+ (BOOL)isInputRuleNotBlank:(NSString *)str {
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5\\d]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
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
    [param setObject:@"" forKey:@"group"];
    [param setObject:phone forKey:@"phone"];
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
+(BOOL)isMobileNumber:(NSString *)mobileNum
{
    //    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
//    NSString *regex =@"(\\+\\d+)?(\\d{3,4}\\-?)?\\d{8}$";
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    BOOL isMatch = [pred evaluateWithObject:mobileNum];
    
    return isMatch;
}
+(CGSize)textSizeWithMaxSize:(CGSize)maxSize font:(UIFont *)font text:(NSString *)text
{
    NSDictionary *dict = @{NSFontAttributeName:font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
}
//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
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
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

//判断是否为整形
+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：

+(BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

+(BOOL)isNumber:(NSString*)string{
    if( ![self isPureInt:string] &&![self isPureFloat:string])
    {
        return NO;
    }else{
        return YES;
    }
}

//字典转Json字符串
+ (NSString*)convertToJSONData:(id)infoDict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString = @"";
    
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return jsonString;
}
//JSON字符串转化为字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

#pragma mark--打电话
+(void)callPhoneAlert:(NSString*)phone setTitle:(NSString*)title{
    ScottAlertView *alertView = [ScottAlertView alertViewWithTitle:title message:phone];
    
    [alertView addAction:[ScottAlertAction actionWithTitle:@"取消" style:ScottAlertActionStyleCancel handler:^(ScottAlertAction *action) {
        
    }]];
    [alertView addAction:[ScottAlertAction actionWithTitle:@"确定" style:ScottAlertActionStyleDestructive handler:^(ScottAlertAction *action) {
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [[YHHelpper getCurrentVC].view addSubview:callWebview];
    }]];
    
    ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:alertView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleFade];
    alertController.tapBackgroundDismissEnable = NO;
    [[YHHelpper getCurrentVC] presentViewController:alertController animated:YES completion:nil];
    
}

+(void)alertLogin{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"您还未登录" message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        YHLoginViewController *vc=[[YHLoginViewController alloc]init];
        BaseNavViewController *nav=[[BaseNavViewController alloc]initWithRootViewController:vc];
        [[YHHelpper getCurrentVC] presentViewController:nav animated:YES completion:nil];
        
    }];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [alert addAction:cancel];
    
    [[YHHelpper getCurrentVC] presentViewController:alert animated:YES completion:nil];
}


+(void)alertLoginOrther{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"您的账号在其他设备上登录" message:@"是否重新登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        YHLoginViewController *vc=[[YHLoginViewController alloc]init];
        BaseNavViewController *nav=[[BaseNavViewController alloc]initWithRootViewController:vc];
        [[YHHelpper getCurrentVC] presentViewController:nav animated:YES completion:nil];
        
    }];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [alert addAction:cancel];
    
    [[YHHelpper getCurrentVC] presentViewController:alert animated:YES completion:nil];
}


/**
 * 获取热门搜索
 */
+(void)getHotKey{
    [[XAClient sharedClient] postInBackground:[NSString stringWithFormat:@"%@%@",YH_REQUEST_DOMAIN,HOTKEY] withParam:nil success:^(id responseObject) {
        int code=[responseObject intForKey:@"code"];
        if (code==1) {
            NSArray *array=[responseObject objectForKey:@"data"];
            [UserDefaults setValue:array forKey:@"hotKey"];
        }
    } failure:nil];
}


@end
