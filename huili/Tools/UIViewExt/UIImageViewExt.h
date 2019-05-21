//
//  UIImageView+UIImageViewExt.h
//  WisdomTCM
//
//  Created by AaronLee on 14-11-21.
//  Copyright (c) 2014年 newzone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (UIImageViewExt)

/*
 * Tip: 旋转图片－角度旋转
 */
- (void)rotationByAngle:(CGFloat)angle Duation:(CGFloat)duation;
/*
 * Tip: 旋转图片－角度旋转
 */
- (void)rotationByAngle:(CGFloat)angle Duation:(CGFloat)duation Delay:(CGFloat)delay;
/* Tip: */
- (void)setimageWithUrl:(NSString*)url CacheToNative:(BOOL)cache Dic:(NSMutableDictionary*)dic;

@end
