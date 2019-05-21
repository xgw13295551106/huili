//
//  BaseNavViewController.h
//  xiuzheng
//
//  Created by Carl on 17/5/3.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNavViewController : UINavigationController


/**
 设置nav颜色
 
 @param color 传入的color
 @param isClear 是否为透明色 用来进行调整
 */
- (void)setNavigationBarColorWith:(UIColor *)color andClear:(BOOL)isClear;

@end
