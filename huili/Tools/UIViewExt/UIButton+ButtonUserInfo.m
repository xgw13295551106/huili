//
//  UIButton+ButtonUserInfo.m
//  PocketMedicalManagement
//
//  Created by AaronLee on 14-8-6.
//  Copyright (c) 2014年 com.XINZONG. All rights reserved.
//

#import "UIButton+ButtonUserInfo.h"
#import <objc/runtime.h>

#define BTN_USERINFO_KEY        @"kUIButtonUserInfoKey"
#define BTN_MODAL_KEY           @"kUIButtonModalKey"

@implementation UIButton (ButtonUserInfo)
@dynamic userInfo;

- (void)setUserInfo:(NSDictionary *)userInfo
{
    objc_setAssociatedObject(self, BTN_USERINFO_KEY, userInfo, OBJC_ASSOCIATION_RETAIN);
}

- (NSDictionary *)userInfo
{
    NSDictionary* info = objc_getAssociatedObject(self, BTN_USERINFO_KEY);
    return info;
}

- (void)setModal:(id)modal
{
    objc_setAssociatedObject(self, BTN_MODAL_KEY, modal, OBJC_ASSOCIATION_RETAIN);
}

- (id)modal
{
    id modal = objc_getAssociatedObject(self, BTN_MODAL_KEY);
    return modal;
}

@end
