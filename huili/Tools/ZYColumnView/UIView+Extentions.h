//
//  UIView+Extentions.h
//  西藏自治区
//
//  Created by 张宇 on 16/5/29.
//  Copyright © 2016年 成都拓尔思. All rights reserved.
//  积累的各种UIView category扩展方法，方便开发使用

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIView (UIView_CGRect)<CAAnimationDelegate>
@property (nonatomic, assign) CGFloat x;

@property (nonatomic, assign) CGFloat y;

@property (nonatomic, assign) CGFloat centerX;

@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGSize size;

@end

@interface UIView (UIView_CALayer)

/**
 * 设置圆角
 * @param raduis : 半径
 */
- (void)setCornerWithRadius:(CGFloat)radius;


/**
 * 设置边框
 * @param color : 颜色
 * @param width : 宽度
 * @param
 */
- (void)setBorderWithColor:(UIColor *)color borderWidth:(CGFloat)borderWidth;

/**
 * 设置阴影
 * @param color : 颜色
 * @param width : 宽度
 * @param
 */
- (void)setShadowWithColor:(UIColor *)color shadowOpacity:(CGFloat)shadowOpacity shadowOffset:(CGSize)shadowOffset;


/**
 * 设置渐变色
 * @param color : 颜色
 * @param width : 宽度
 * @param
 */
- (void)setGradientWithColors:(NSArray *)gradientColors gradientRect:(CGRect )gradientRect;

@end

@interface UIView (UIView_UIGestureRecognizer)

/**
 * 点击手势
 */
- (void)addTapGesture:(id)target selector:(SEL)selector;


/**
 * 拖动手势
 */
- (void)addPanGesture:(id)target selector:(SEL)selector;

/**
 * 长按手势
 */
- (void)addLongPressGesture:(id)target selector:(SEL)selector;

@end

@interface UIView  (UIView_CAAnimation)


/**
 * 类心跳振动动画
 */
- (void)animationHeartBeat;


/**
 * 线性消失动画
 */
- (void)animationCurveEaseOut;

/**
 *  顺时针旋转一个view
 *  @param view  需要旋转的view
 *  @param angle 需要旋转多少度(角度制) 正数(顺时针) 负数(逆时针)
 */
- (void)animationRotate:(UIView *)view ToAngle:(CGFloat)angle;

/**
 * 来回抖动动画
 * @param enable
 */
- (void)animationShake:(BOOL)enable;


/**
 * 旋转动画
 * @pram value
 */
- (CABasicAnimation *)animationRotate:(CGFloat)value;

@end


@interface UIView (UIView_Transform)
/**
 *  顺时针旋转一个view
 *  @param view  需要旋转的view
 *  @param angle 需要旋转多少度(角度制) 正数(顺时针) 负数(逆时针)
 */
- (void)animationRotate:(UIView *)view ToAngle:(CGFloat)angle;

@end
