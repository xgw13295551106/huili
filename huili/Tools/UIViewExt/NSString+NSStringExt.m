//
//  NSString+NSStringExt.m
//  LKHealthManagerEnterprise
//
//  Created by AaronLee on 14-8-8.
//  Copyright (c) 2014年 com.XINZONG. All rights reserved.
//

#import "NSString+NSStringExt.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation NSString (NSStringExt)

- (BOOL)isNull
{
    if ([self isKindOfClass:[NSNull class]]
        || [self isEqualToString:@"<null>"]
        || [self isEqualToString:@"(null)"]) {
        return YES;
    }
    return NO;
}

- (BOOL)containsString:(NSString *)aString
{
    NSRange range = [self rangeOfString:aString options:NSCaseInsensitiveSearch];
    if (range.length) {
        return YES;
    }else
        return NO;
}

- (BOOL)containChinese
{
    for (int index = 0; index < self.length; index++) {
        unichar cc = [self characterAtIndex:index];
        if (cc > 0x4e00 && cc < 0x9fff) {
            return YES;
        }
    }
    return NO;
}

- (NSString*)removeLastSymbolIfNeeded
{
    if (!self.length) {
        return self;
    }
    NSString* last = [self substringFromIndex:self.length - 1];
    if ([last isEqualToString:@","]) {
        NSString* result = [self substringToIndex:self.length - 1];
        return result;
    }else
        return self;
}

- (NSArray *)arrayWithSeparater:(NSString *)separater
{
    if (self.length) {
        return [self componentsSeparatedByString:separater];
    }else
        return [[NSArray alloc] init];
}

- (NSString *)unicodeToChinese
{
    NSString *tempStr1 = [self stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    if ([tempStr2 hasPrefix:@"\\\""]) {
        tempStr2 = [tempStr2 substringFromIndex:2];
    }
    if ([tempStr2 hasSuffix:@"\\\""]) {
        tempStr2 = [tempStr2 substringToIndex:tempStr2.length - 2];
    }
    tempStr2 = [tempStr2 stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

- (long)countOfChars
{
//    int strlength = 0;
//    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
//    for (int i=0 ; i<[self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
//        if (*p) {
//            p++;
//            strlength++;
//        }
//        else {
//            p++;
//        }
//    }
//    return strlength;
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [self dataUsingEncoding:enc];
    return [da length];
}

- (NSString *)substringToCharAtIndex:(int)index
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* data = [self dataUsingEncoding:enc];
    NSString* lastStr = [self substringWithRange:NSMakeRange(self.length - 1, 1)];
    if ([[lastStr dataUsingEncoding:enc] length] > 1 && data.length % 2 == 1) {
        index -= 1;
    }
    NSString* result = [[[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, MIN(index, data.length))] encoding:enc] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

- (NSString*)md5String
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (uint32_t)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString *)encrypt:(NSString *)sText encryptOrDecrypt:(CCOperation)encryptOperation key:(NSString *)key
{
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOperation == kCCDecrypt)
    {
        NSData *decryptData = [[NSData alloc] initWithBase64EncodedString:sText options:0];
        plainTextBufferSize = [decryptData length];
        vplainText = [decryptData bytes];
    }
    else
    {
        NSData* encryptData = [sText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [encryptData length];
        vplainText = (const void *)[encryptData bytes];
    }
    
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    NSString *initVec = @"12345678";
    const void *vkey = (const void *) [key UTF8String];
    const void *vinitVec = (const void *) [initVec UTF8String];
    
    CCCryptorStatus ccStatus = CCCrypt(encryptOperation,
                                       kCCAlgorithm3DES,
                                       kCCOptionPKCS7Padding,
                                       vkey,
                                       kCCKeySize3DES,
                                       vinitVec,
                                       vplainText,
                                       plainTextBufferSize,
                                       (void *)bufferPtr,
                                       bufferPtrSize,
                                       &movedBytes);
    NSLog(@"%d",ccStatus);
    NSString *result = nil;
    if (ccStatus == kCCSuccess)
    {
        if (encryptOperation == kCCDecrypt)
        {
            result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding] ;
        }
        else
        {
            NSData *data = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
            result = [[NSString alloc] initWithData:[data base64EncodedDataWithOptions:0]encoding:NSUTF8StringEncoding];
            // NSLog(@"result:%@",result);
            // NSData *temp = [GTMBase64 decodeString:result];
        }
    }
    return result;
}

- (NSString *)desEncryptWithKey:(NSString *)aKey
{
    return [self encrypt:self encryptOrDecrypt:kCCEncrypt key:aKey];
}

- (NSString *)desDecryptWithKey:(NSString *)aKey
{
    return [self encrypt:self encryptOrDecrypt:kCCDecrypt key:aKey];
}
- (NSString *)soapStringWithMethod:(NSString *)method
{
    return [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                             <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><%@ xmlns=\"http://WebService.org/\"><strInXML><![CDATA[%@]]></strInXML><strOutXML></strOutXML></%@></soap:Body></soap:Envelope>",method,self,method];
}

@end
