//
//  UIButton+ButtonUserInfo.h
//  PocketMedicalManagement
//
//  Created by AaronLee on 14-8-6.
//  Copyright (c) 2014年 com.XINZONG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ButtonUserInfo)

/*
 * 类似tag值，可以使UIButton携带更多信息
 */
@property (nonatomic,readwrite,retain)NSDictionary* userInfo;
/*
 * 类似tag值，可以使UIButton携带更多信息
 */
@property (nonatomic,readwrite,retain)id modal;

@end
