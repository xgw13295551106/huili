//
//  AppDelegate+CreatTabr.m
//  EduParent
//
//  Created by Carl on 17/8/24.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "AppDelegate+CreatTabr.h"
#import "BaseNavViewController.h"
#import "YHLoginViewController.h"
#import "BaseTabbarViewController.h"
#import "HcdGuideView.h"
#import "LCLeadViewController.h"

@interface AppDelegate()

@end

@implementation AppDelegate (CreatTabr)

#pragma mark--初始化Controller
-(void)ConfigController{
    if (@available(iOS 11.0, *)) {
        [UITableView appearance].estimatedRowHeight = 0;
        [UITableView appearance].estimatedSectionHeaderHeight = 0;
        [UITableView appearance].estimatedSectionFooterHeight = 0;
    }
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:FirstOpen] intValue]==1) {
        [self createBaseTabbar];
    }else{
        self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        LCLeadViewController *vc = [[LCLeadViewController alloc]init];
        self.window.rootViewController = vc;
        [self.window makeKeyAndVisible];
    }
//    if (!([[UserDefaults stringForKey:@"Guide"] intValue]>0)) {
//        [self creatGuide];
//    }
}

- (void)createBaseTabbar{
    //现在创建tabbar走这个方法
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    BaseTabbarViewController *tabbar = [[BaseTabbarViewController alloc]init];
    self.window.rootViewController = tabbar;
    [self.window makeKeyAndVisible];
    
}
-(void)creatLogin{
    
    YHLoginViewController *vc=[[YHLoginViewController alloc]init];
    BaseNavViewController* nav = [[BaseNavViewController alloc] initWithRootViewController:vc];
    self.window.rootViewController=nav;
}

-(void)creatGuide{
    NSMutableArray *images = [NSMutableArray new];
    
    [images addObject:[UIImage imageNamed:@"1"]];
    [images addObject:[UIImage imageNamed:@"2"]];
    [images addObject:[UIImage imageNamed:@"3"]];
    
    HcdGuideView *guideView = [HcdGuideView sharedInstance];
    guideView.window = self.window;
    [guideView showGuideViewWithImages:images
                        andButtonTitle:@"立即体验"
                   andButtonTitleColor:[UIColor whiteColor]
                      andButtonBGColor:[UIColor clearColor]
                  andButtonBorderColor:[UIColor whiteColor]];
    
}

@end
