//
//  UserInfoModel.m
//  ConsumerProject
//
//  Created by John on 2017/8/11.
//  Copyright © 2017年 John.peng. All rights reserved.
//

#import "UserInfoModel.h"
#import <objc/runtime.h>

@implementation UserInfoModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self  = [super init]) {
        self = [UserInfoModel mj_objectWithKeyValues:dic];
    }
    return self;
}

+ (instancetype)getUserModel:(NSDictionary *)dic{
    UserInfoModel *userModel = [[UserInfoModel alloc]initWithDic:dic];
    return userModel;
}

-(NSString*)hidlogin{
    NSString *tel = [self.login stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    return tel;
}

@end
