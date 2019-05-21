//
//  XAClient.h
//  NetWork
//
//  Created by xunao on 15-2-9.
//  Copyright (c) 2015年 xunao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface XAClient : NSObject

@property (nonatomic) BOOL isNetWorkAvailable;
@property (nonatomic) BOOL isNetWorkEnable;
@property (nonatomic) AFHTTPSessionManager *httpManager;

+(XAClient *) sharedClient;

/**
 单例请求接口POST
 */
-(BOOL)POST:(NSString *)apiUrl withParam:(NSMutableDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *))failure;

/**
 多例请求接口POST
 */
-(BOOL)postInBackground:(NSString *)api withParam:(NSMutableDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *))failure;


@end
