//
//  SVProgressHUDHelp.m
//  ConvenienceStore
//
//  Created by Carl on 2017/10/17.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "SVProgressHUDHelp.h"

@implementation SVProgressHUDHelp

+(void)SVProgressHUDFail:(NSString*)str{
    [SVProgressHUD showErrorWithStatus:str];
    [SVProgressHUD dismissWithDelay:1];
}
+(void)SVProgressHUDSuccess:(NSString*)str{
    [SVProgressHUD showSuccessWithStatus:str];
    [SVProgressHUD dismissWithDelay:1];
}

@end
