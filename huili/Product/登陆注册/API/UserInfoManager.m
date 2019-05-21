//
//  UserInfoManager.m
//  ConsumerProject
//
//  Created by John on 2017/8/11.
//  Copyright © 2017年 John.peng. All rights reserved.
//

#import "UserInfoManager.h"

#define  kAppUserInfo @"kAppUserInfo"

@implementation UserInfoManager

static UserInfoManager *manager = nil;
+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
    });
    return manager;
}

+ (BOOL)isLogin{
    if ([UserInfoManager manager].currUserInfo.token && [UserInfoManager manager].currUserInfo.token.length > 0) {
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)logout{
    [UserInfoManager manager].currUserInfo = nil;
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:kAppUserInfo];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveUserInfo:(UserInfoModel *)user {
     //用户在手机上用于保存文件的文件夹路径
    NSString *userFilePath = [NSString stringWithFormat:@"%@/%@",DOWNLOADS_PATH,user.id];
    if(![[NSFileManager defaultManager] fileExistsAtPath:userFilePath]){
        //如果不存在,则说明是用户是第一次登录这个程序，那么建立这个文件夹，用于保存用户下载的数据
        [[NSFileManager defaultManager] createDirectoryAtPath:userFilePath withIntermediateDirectories:YES attributes:nil error:nil];
        NSLog(@"%@",userFilePath);
    }else{
        NSLog(@"%@",userFilePath);
    }
    NSData *encodeData = [NSKeyedArchiver archivedDataWithRootObject:user];
    [[NSUserDefaults standardUserDefaults] setObject:encodeData forKey:kAppUserInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


+ (UserInfoModel *)currentUser{
    return [UserInfoManager manager].currUserInfo;
}

- (UserInfoModel *)currUserInfo {

    NSData *encodeObject = [[NSUserDefaults standardUserDefaults] objectForKey:kAppUserInfo];
    _currUserInfo = [NSKeyedUnarchiver unarchiveObjectWithData:encodeObject];

    return _currUserInfo;
}

@end
