//
//  BaseTabbarViewController.m
//  EduParent
//
//  Created by zhongweike on 2017/9/19.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "BaseTabbarViewController.h"
#import "DCCommodityViewController.h"
#import "CartViewController.h"
#import "LCUserInfoViewController.h"
#import "BaseNavViewController.h"
#import "YHLoginViewController.h"
#import "Reachability.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "YHHomeViewController.h"

@interface BaseTabbarViewController ()<UITabBarControllerDelegate>{
    BOOL __shouldAutorotate;
}

@property (nonatomic,strong)Reachability *reachability; /// 监听网络状态

@property(nonatomic,weak)CartViewController*c3;

@end

@implementation BaseTabbarViewController

+ (void)initialize{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithHex:0xff000000 alpha:0.8]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    
    [AMapServices sharedServices].enableHTTPS = YES;
    
    [LCLocationTool sharedLocation];

}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notifi_CartChange object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartChange:) name:Notifi_CartChange object:nil];
    [self cartChange:nil];
}

-(void)cartChange:(NSNotification*)noti{
    NSDictionary *dic=noti.userInfo;
    int outValue=[dic intForKey:@"out"];
    if (outValue==1) {
        _c3.tabBarItem.badgeValue=nil;
        return;
    }
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:[UserDefaults stringForKey:@"supplier_id"] forKey:@"supplier_id"];
    [param setValue:TOKEN forKey:@"token"];
    [[XAClient sharedClient]postInBackground:[NSString stringWithFormat:@"%@%@",YH_REQUEST_DOMAIN,CartNumber] withParam:param success:^(id responseObject) {
        int code=[responseObject intForKey:@"code"];
        if (code==1) {
            NSLog(@"%@",responseObject);
            NSDictionary *data=[responseObject objectForKey:@"data"];
            int num=[data intForKey:@"num"];
            if (num==0) {
               _c3.tabBarItem.badgeValue=nil;
            }else{
                _c3.tabBarItem.badgeValue=[NSString stringWithInt:num];
            }
             [[NSUserDefaults standardUserDefaults]setObject:@(num) forKey:Car_Goods_Num];
        }
    } failure:nil];
}


- (void)setUpUI{
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"999999"],NSFontAttributeName:[UIFont fontWithName:@"ArialMT" size:14.0*PROPORTION]} forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:STYLECOLOR,NSFontAttributeName:[UIFont fontWithName:@"ArialMT" size:14*PROPORTION]} forState:UIControlStateSelected];
    
    YHHomeViewController *c1=[[YHHomeViewController alloc]init];
    c1.tabBarItem.image=[[UIImage imageNamed:@"tab_home_def" ] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    c1.tabBarItem.selectedImage=[[UIImage imageNamed:@"tab_home_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    c1.tabBarItem.title=@"首页";
    
    DCCommodityViewController *c2=[[DCCommodityViewController alloc]init];
    c2.tabBarItem.image=[[UIImage imageNamed:@"tab_menu_def"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    c2.tabBarItem.selectedImage=[[UIImage imageNamed:@"tab_menu_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    c2.tabBarItem.title=@"分类";
    
    CartViewController*c3=[[CartViewController alloc]init];
    _c3=c3;
    c3.tabBarItem.image=[[UIImage imageNamed:@"tab_cart_def"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    c3.tabBarItem.selectedImage=[[UIImage imageNamed:@"tab_cart_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    c3.tabBarItem.title=@"购物车";
    
    LCUserInfoViewController *c4=[[LCUserInfoViewController alloc]init];
    c4.tabBarItem.image=[[UIImage imageNamed:@"tab_user_def"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    c4.tabBarItem.selectedImage=[[UIImage imageNamed:@"tab_user_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    c4.tabBarItem.title=@"我的";
    
    
    
    
    BaseNavViewController* nav1 = [[BaseNavViewController alloc] initWithRootViewController:c1];
    BaseNavViewController* nav2 = [[BaseNavViewController alloc] initWithRootViewController:c2];
    BaseNavViewController* nav3 = [[BaseNavViewController alloc] initWithRootViewController:c3];
    BaseNavViewController* nav4 = [[BaseNavViewController alloc] initWithRootViewController:c4];
    
    
    
   
    self.viewControllers = [NSArray arrayWithObjects:nav1,nav2,nav3,nav4, nil];
    self.delegate = self;
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];

    
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if (viewController == tabBarController.viewControllers[2]||viewController == tabBarController.viewControllers[3]) {
        if (TOKEN) {
            return YES;
        }else{
            [YHHelpper alertLogin];
            return NO;
        }
    }else{
        return YES;
    }
}

@end
