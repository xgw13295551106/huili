//
//  BaseNavViewController.m
//  xiuzheng
//
//  Created by Carl on 17/5/3.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "BaseNavViewController.h"

@interface BaseNavViewController ()

@end

@implementation BaseNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBar.translucent = NO;
    
    self.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor whiteColor]}];
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:STYLECOLOR] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage new]];
}


+ (void)initialize{
    [self createBarButtonItemTheme];
    
    [self createNavBarTheme];
}


/**
 *  设置导航栏按钮主题
 */
+ (void)createBarButtonItemTheme{
    UIBarButtonItem *item = [UIBarButtonItem appearance];

    item.tintColor = [UIColor whiteColor];
    
    [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
      
    
    
    
    
    
    
}

/**
 *  设置导航栏主题
 */
+ (void)createNavBarTheme{
    UINavigationBar *navBar = [UINavigationBar appearance];
    

    [navBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];

}



- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -5;
        
        //设置导航栏的按钮
        //        UIBarButtonItem *backButton = [UIBarButtonItem itemWithImageName:@"navigationbar_back_image" highImageName:@"navigationbar_back_image" target:self action:@selector(back)];
        //        viewController.navigationItem.leftBarButtonItems = @[negativeSpacer, backButton];
        
        // 就有滑动返回功能
        self.interactivePopGestureRecognizer.delegate = nil;
        
    }
    [super pushViewController:viewController animated:animated];
    
}

/**
 设置nav颜色
 
 @param color 传入的color
 @param isClear 是否为透明色 用来进行调整
 */
- (void)setNavigationBarColorWith:(UIColor *)color andClear:(BOOL)isClear{
    [self.navigationBar setTranslucent:isClear];
    
    CGRect rect = CGRectMake(0.0f, 0.0f, win_width, NavHeight);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
}



//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    // fix 'nested pop animation can result in corrupted navigation bar'
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.interactivePopGestureRecognizer.enabled = NO;
//    }
//    
//    [super pushViewController:viewController animated:animated];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
