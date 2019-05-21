//
//  CustomVipAlertView.h
//  huili
//
//  Created by zhongweike on 2018/1/18.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^VipAlertBlock)();

/**
 会员特权说明弹框
 */
@interface CustomVipAlertView : UIView

+(instancetype)getCustomVipAlertViewWith:(CGRect)frame;


- (void)setCloseBlock:(VipAlertBlock)closeBlock;

@end
