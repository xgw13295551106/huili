//
//  AppDelegate+Config.m
//  EduParent
//
//  Created by Carl on 17/8/24.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "AppDelegate+Config.h"
#import "CommonConfig.h"

@implementation AppDelegate (Config)

-(void)ConfigSDK{
    //初始化键盘
    [self ConfigIQKeyboardManager];
    [self ConfigInfo];
    //高德
    [self configAMap];
    
    //获取热门搜素
    [YHHelpper getHotKey];
    
    [self getYeFuClass];
}
#pragma mark--初始化键盘
-(void)ConfigIQKeyboardManager{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable =YES;
    manager.shouldResignOnTouchOutside =YES;
    manager.shouldToolbarUsesTextFieldTintColor =YES;
    manager.enableAutoToolbar =NO;//控制键盘上面的Done是否显示
}

/***************************初始化参数***************************************/
-(void)ConfigInfo{
    NSArray *arrayConfig=[UserDefaults objectForKey:@"config"];
    if (arrayConfig) {
        [[CommonConfig shared] initWithArr:arrayConfig];
    }
    NSString *url=[NSString stringWithFormat:@"%@%@",YH_REQUEST_DOMAIN,GetConfig];
    [[XAClient sharedClient] postInBackground:url withParam:nil success:^(id responseObject) {
        int code=[responseObject intForKey:@"code"];
        if (code==1) {
            NSArray *array=[responseObject objectForKey:@"data"];
            [UserDefaults setValue:array forKey:@"config"];
            [[CommonConfig shared] initWithArr:array];
        }
    } failure:nil];
}
/***************************初始化参数***************************************/


/***************************获取冶父报类型***************************************/
-(void)getYeFuClass{
    NSString *url=[NSString stringWithFormat:@"%@%@",YH_REQUEST_DOMAIN,GetYeFuClass];
    [[XAClient sharedClient] postInBackground:url withParam:nil success:^(id responseObject) {
        int code=[responseObject intForKey:@"code"];
        if (code==1) {
            NSArray *arrar=[responseObject objectForKey:@"data"];
            [UserDefaults setValue:arrar forKey:@"artcat"];
        }
    } failure:nil];
}
/***************************获取冶父报类型***************************************/

#pragma mark--高德
-(void)configAMap{
    [AMapServices sharedServices].enableHTTPS = YES;
    [AMapServices sharedServices].apiKey =AMAPKEY;
}

@end
