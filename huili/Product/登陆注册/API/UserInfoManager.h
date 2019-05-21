//
//  UserInfoManager.h
//  ConsumerProject
//
//  Created by John on 2017/8/11.
//  Copyright © 2017年 John.peng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"

@interface UserInfoManager : NSObject

@property (nonatomic,strong) UserInfoModel *currUserInfo;

+ (instancetype)manager;

/**
 判断是否登录

 @return 已登录为YES 未登录为No
 */
+ (BOOL)isLogin;

/**
 退出登录

 @return 成功返回Yes
 */
+ (BOOL)logout;


/**
 返回当前登录的用户信息

 @return UserInfoModel
 */
+ (UserInfoModel *)currentUser;

- (void)saveUserInfo:(UserInfoModel *)user;

@end
