//
//  CommonConfig.m
//  ConvenienceStore
//
//  Created by Carl on 2017/10/18.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "CommonConfig.h"

@implementation CommonConfig

+(CommonConfig *)shared
{
    static CommonConfig *_config = nil;
    if (_config == nil) {
        _config = [[CommonConfig alloc] init];
        
        _config.wxG=@"";
        _config.mobileSer=@"";
        _config.email=@"";
        _config.net=@"";
        _config.logo=@"";
        _config.email=@"";
        _config.copyright=@"";
        _config.registXieyi=@"";
        _config.shareUrl=@"";
        _config.homeAd=@"";
        _config.pageAd=@"";
        _config.jishiFee=@"";
        _config.kuaisuFee=@"";
        _config.jifenChange=@"";
        _config.KefuQQ=@"";
        _config.RongID=@"";
        _config.feeRules=@"";
        _config.vip_level1 = @"";
        _config.vip_level2 = @"";
        _config.vip_level3 =@"";
        _config.vip_level4 = @"";
    }
    return _config;
}


-(void)initWithArr:(NSArray *)array{
    if (array.count>0) {///**微信公众号**/
        NSDictionary *dic=[array objectAtIndex:0];
        self.wxG=[dic stringForKey:@"content"];
    }
    if (array.count>1) {///**联系电话**/
        NSDictionary *dic=[array objectAtIndex:1];
        self.mobileSer=[dic stringForKey:@"content"];
    }
    if (array.count>2) {///**电子邮箱**/
        NSDictionary *dic=[array objectAtIndex:2];
        self.email=[dic stringForKey:@"content"];
    }
    if (array.count>3) {///**官方网站**/
        NSDictionary *dic=[array objectAtIndex:3];
        self.net=[dic stringForKey:@"content"];
    }
    if (array.count>4) {///**logo图标**/
        NSDictionary *dic=[array objectAtIndex:4];
        self.logo=[dic stringForKey:@"content"];
    }
    if (array.count>5) {//**版权信息**/
        NSDictionary *dic=[array objectAtIndex:5];
        self.copyright=[dic stringForKey:@"content"];
    }
    if (array.count>6) {///**注册协议**/
        NSDictionary *dic=[array objectAtIndex:6];
        self.registXieyi=[dic stringForKey:@"url"];
    }
    if (array.count>7) {//
        NSDictionary *dic=[array objectAtIndex:7];
        self.vip_level1=[dic stringForKey:@"content"];
    }
    if (array.count>8) {//
        NSDictionary *dic=[array objectAtIndex:8];
        self.shareUrl=[dic stringForKey:@"content"];
    }
    if (array.count>9) {//
        NSDictionary *dic=[array objectAtIndex:9];
        self.vip_level2=[dic stringForKey:@"content"];
    }
    if (array.count>10) {//
        NSDictionary *dic=[array objectAtIndex:10];
        self.vip_level3=[dic stringForKey:@"content"];
    }
    if (array.count>12) {//
        NSDictionary *dic=[array objectAtIndex:12];
        self.vip_level4=[dic stringForKey:@"content"];
    }
    if (array.count>13) {//
        NSDictionary *dic=[array objectAtIndex:13];
        self.kuaisuFee=[dic stringForKey:@"content"];
    }
    if (array.count>14) {//
        NSDictionary *dic=[array objectAtIndex:14];
        self.jifenChange=[dic stringForKey:@"content"];
    }
    if (array.count>16) {//
        NSDictionary *dic=[array objectAtIndex:16];
        self.KefuQQ=[dic stringForKey:@"content"];
    }
    if (array.count>17) {//
        NSDictionary *dic=[array objectAtIndex:17];
        self.RongID=[dic stringForKey:@"content"];
    }
    if (array.count>20) {//
        NSDictionary *dic=[array objectAtIndex:20];
        self.feeRules=[dic stringForKey:@"url"];
    }
    
}


@end
