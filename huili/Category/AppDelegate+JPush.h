//
//  AppDelegate+JPush.h
//  ValueOnline_server
//
//  Created by zhongweike on 2017/9/9.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import "AppDelegate.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate (JPush)<JPUSHRegisterDelegate>

- (void)setUpJPushWithOptions:(NSDictionary *)launchOptions;

@end
