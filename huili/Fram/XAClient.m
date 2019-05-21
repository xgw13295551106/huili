//
//  XAClient.m
//  NetWork
//
//  Created by xunao on 15-2-9.
//  Copyright (c) 2015年 xunao. All rights reserved.
//

#import "XAClient.h"
#import "Frame.h"

#define timeout   10.f

@implementation XAClient
+(XAClient *)sharedClient
{
    static XAClient *_sharedClient;
    if (_sharedClient == nil) {
        _sharedClient = [[XAClient alloc] init];
    }
    return _sharedClient;
}

-(BOOL)isNetWorkAvailable
{
    return [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != AFNetworkReachabilityStatusNotReachable;
}

-(AFHTTPSessionManager *)httpManager
{
    if (_httpManager == nil) {
        _httpManager = [AFHTTPSessionManager manager];
        _httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
        
//        [NSSet setWithObject:@"text/html"];
        [_httpManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _httpManager.requestSerializer.timeoutInterval = timeout;
        [_httpManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    }
    return _httpManager;
}


//POST方式
-(BOOL)POST:(NSString *)apiUrl withParam:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    //取消其他所有请求
    [self.httpManager.operationQueue cancelAllOperations];
    //检查网络是否可用
    if (!self.isNetWorkAvailable) {
        if (failure) {
            NSError *error = [[NSError alloc] initWithDomain:@"netWorkError" code:-10086 userInfo:[NSDictionary dictionaryWithObject:@"网络不可用" forKey:@"des"]];
            failure(error);
        }
        return NO;
    }
    
    if ([UserDefaults objectForKey:@"device"]) {
        [params setObject:[UserDefaults objectForKey:@"device"] forKey:@"device"];
    }else{
        NSString *deviceUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [params setObject:deviceUUID forKey:@"device"];
        [UserDefaults setValue:deviceUUID forKey:@"device"];
    }
    //时间戳
    NSDate *senddate = [NSDate date];
    NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
    //    NSLog(@"date2时间戳 = %@",date2);
    [params setValue:date2 forKey:@"timestamp"];
    
    //sign
    NSString *dateMD5=[YHHelpper md5:date2];
    NSString *sign=[NSString stringWithFormat:@"%@%@%@",dateMD5,KEY,[UserDefaults objectForKey:@"device"]];
    NSString *signMD5=[YHHelpper md5:sign];
    [params setValue:signMD5 forKey:@"sign"];
    
    NSLog(@"%@%@", apiUrl, [self paramToString:params]);
    //请求接口
    [self.httpManager POST:apiUrl parameters:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        int code=[responseObject intForKey:@"code"];
        if (code==2) {
            [self tokenDelect];
        }
        if (success != nil) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
    
        if (error.code == NSURLErrorCancelled) {
            NSLog(@"请求被取消");
        }else if (failure != nil) {
            failure(error);
        }
    }];
    return YES;
}

-(BOOL)postInBackground:(NSString *)api withParam:(NSMutableDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    //取消其他所有请求
    [httpManager.operationQueue cancelAllOperations];
    [httpManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    httpManager.requestSerializer.timeoutInterval = timeout;
    [httpManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    //检查网络是否可用
    if (!self.isNetWorkAvailable) {
        if (failure) {
            NSError *error = [[NSError alloc] initWithDomain:@"netWorkError" code:-10086 userInfo:[NSDictionary dictionaryWithObject:@"网络不可用" forKey:@"des"]];
            failure(error);
        }
        return NO;
    }
    
    
    if ([UserDefaults objectForKey:@"device"]) {
        [params setObject:[UserDefaults objectForKey:@"device"] forKey:@"device"];
    }else{
        NSString *deviceUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [params setObject:deviceUUID forKey:@"device"];
        [UserDefaults setValue:deviceUUID forKey:@"device"];
    }
    //时间戳
    NSDate *senddate = [NSDate date];
    NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
    //    NSLog(@"date2时间戳 = %@",date2);
    [params setValue:date2 forKey:@"timestamp"];
    
    //sign
    NSString *dateMD5=[YHHelpper md5:date2];
    NSString *sign=[NSString stringWithFormat:@"%@%@%@",dateMD5,KEY,[UserDefaults objectForKey:@"device"]];
    NSString *signMD5=[YHHelpper md5:sign];
    [params setValue:signMD5 forKey:@"sign"];
    
    NSLog(@"%@%@", api, [self paramToString:params]);
    //请求接口 AFN
    [httpManager POST:api parameters:params success:^(NSURLSessionDataTask *operation, id responseObject) {

        int code=[responseObject intForKey:@"code"];
        if (code==2) {
            [self tokenDelect];
        }
        if (success != nil) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"%@",error);
        if (error.code == NSURLErrorCancelled) {
            NSLog(@"请求被取消");
        }else if (failure != nil) {
            failure(error);
        }
    }];
    return YES;
}


-(NSString *)paramToString:(NSDictionary *)params
{
    __block NSString *paramStr = @"";
    if (params) {
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *object = [NSString stringWithFormat:@"%@", obj];
            NSString *val = [object stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            if (paramStr.length == 0) {
                paramStr = [NSString stringWithFormat:@"?%@=%@",key, val];
            }else {
                paramStr = [NSString stringWithFormat:@"%@&%@=%@", paramStr,key, val];
            }
        }];
    }
    return paramStr;
}

#pragma mark--token过期
-(void)tokenDelect{
    
//    NSArray *array=[[CurrentUserModel model]queryAllWithCondition:nil orderby:nil];
//    for (int i=0; i<array.count; i++) {
//        CurrentUserModel *model=[array objectAtIndex:i];
//        [model deleteModel];
//    }
//    [DataManager shared].currentUser=nil;
}

@end
