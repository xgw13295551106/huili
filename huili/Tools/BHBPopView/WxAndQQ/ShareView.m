//
//  ShareView.m
//  EduParent
//
//  Created by Carl on 2017/9/26.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "ShareView.h"

@interface ShareView ()

@property(nonatomic)NSString *url;

@property(nonatomic)NSString *title;

@property(nonatomic)NSString *content;

@property(nonatomic)NSString *icon;

@end


@implementation ShareView

+(ShareView *)ShareViewClient
{
    static ShareView *_ShareViewClient;
    if (_ShareViewClient == nil) {
        _ShareViewClient = [[ShareView alloc] init];
    }
    return _ShareViewClient;
}

#pragma mark--分享

-(void)shareClick:(NSString*)url setTitle:(NSString*)title setContent:(NSString*)content setIcon:(NSString*)icon;
{
    _url=url;
    _title=title;
    _content=content;
    _icon=icon;
    BHBItem * item0 = [[BHBItem alloc]initWithTitle:@"微信好友" Icon:@"weixind"];
    BHBItem * item1 = [[BHBItem alloc]initWithTitle:@"朋友圈" Icon:@"pengyouquanda"];
    BHBItem * item2 = [[BHBItem alloc]initWithTitle:@"QQ好友" Icon:@"QQa"];
    BHBItem * item3 = [[BHBItem alloc]initWithTitle:@"QQ空间" Icon:@"kongjian"];
    
    //添加popview
    [BHBPopView showToView:[self getCurrentVC].view.window withItems:@[item0,item1,item2,item3]andSelectBlock:^(BHBItem *item) {
        if ([item isKindOfClass:[BHBGroup class]]) {
            NSLog(@"选中%@分组",item.title);
        }else{
            NSLog(@"选中%@项",item.title);
            int tag=-1;
            if ([item.title isEqualToString:@"微信好友"]) {
                tag=0;
            }else if ([item.title isEqualToString:@"朋友圈"]){
                tag=1;
            }else if ([item.title isEqualToString:@"QQ好友"]){
                tag=2;
            }else{
                tag=3;
            }
            [self shareSelect:tag];
        }
    }];
}

#pragma mark--分享

-(void)shareSelect:(int)tag{
    NSLog(@"%d",tag);
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    
    NSString *shareText =app_Name;
    if (_title) {
        shareText=_title;
    }
    
    NSString *shareContent =SHARECONTENT;
    
    if (_content) {
        shareText=_content;
    }
    
    UMSocialPlatformType platformType;
    switch (tag) {
        case 0:
        {
            platformType = UMSocialPlatformType_WechatSession;
        }
            break;
        case 1:
        {
            platformType = UMSocialPlatformType_WechatTimeLine;
        }
            break;
        case 2:
        {
            platformType = UMSocialPlatformType_QQ;
        }
            break;
        case 3:
        {
            platformType = UMSocialPlatformType_Qzone;
        }
            break;
        default:
        {
            platformType = UMSocialPlatformType_WechatSession;
        }
            break;
    }
    
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WXAPPID appSecret:WXAPPSECRET redirectURL:shareUrl];
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    //    NSString* thumbURL = shareImageUrl;
    UIImage *img=[UIImage imageNamed:App_icon];
    if (_icon) {
        img=[UIImage imageNamed:_icon];
    }
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:shareText descr:shareContent thumImage:img];
    
    //设置网页地址
    if (_url) {
        shareObject.webpageUrl=_url;
    }else{
        shareObject.webpageUrl = [CommonConfig shared].shareUrl;
    }
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:[self getCurrentVC] completion:^(id result, NSError *error) {
        if (error) {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"分享失败" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok=[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:ok];
            [[self getCurrentVC] presentViewController:alert animated:YES completion:nil];
            NSLog(@"%@",error);
        }else
        {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"分享成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok=[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:ok];
            [[self getCurrentVC] presentViewController:alert animated:YES completion:nil];
        }
    }];
    
}

//获取当前屏幕显示的viewcontroller
-(UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

@end
