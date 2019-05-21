//
//  UIView+Extentions.m
//  西藏自治区
//
//  Created by 张宇 on 16/5/29.
//  Copyright © 2016年 成都拓尔思. All rights reserved.
//

#import "UIView+Extentions.h"

@implementation UIView (UIView_CGRect)

/***************** 设置坐标 宽高 尺寸等  ********************/
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}
/***************** 设置坐标 宽高 尺寸等  ********************/

@end

@implementation UIView (UIView_Transform)

/**
 *  顺时针旋转一个view
 *  @param view  需要旋转的view
 *  @param angle 需要旋转多少度(角度制) 正数(顺时针) 负数(逆时针)
 */
- (void)animationRotate:(UIView *)view ToAngle:(CGFloat)angle
{
    [UIView animateWithDuration:0.5 animations:^{
        view.transform = CGAffineTransformRotate(view.transform, -angle/180.0*M_PI);
    }];
}

@end

@implementation UIView (UIView_CALayer)

/**
 * 设置圆角
 * @param raduis : 半径
 */
- (void)setCornerWithRadius:(CGFloat)radius {
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius  = radius;
}


/**
 * 设置边框
 * @param color : 颜色
 * @param width : 宽度
 * @param
 */
- (void)setBorderWithColor:(UIColor *)color borderWidth:(CGFloat)borderWidth {
    
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = borderWidth;
}

/**
 * 设置阴影
 * @param color : 颜色
 * @param width : 宽度
 * @param
 */
- (void)setShadowWithColor:(UIColor *)color shadowOpacity:(CGFloat)shadowOpacity shadowOffset:(CGSize)shadowOffset {
    
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOpacity = shadowOpacity;
    self.layer.shadowOffset  = shadowOffset;
}


/**
 * 设置渐变色
 * @param color : 颜色
 * @param width : 宽度
 * @param
 */
- (void)setGradientWithColors:(NSArray *)gradientColors gradientRect:(CGRect )gradientRect {
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = gradientRect;
    gradient.colors = gradientColors;
    [self.layer insertSublayer:gradient atIndex:0];
}

@end

#pragma mark -
@implementation UIView (UIView_UIGestureRecognizer)

/**
 * 点击手势
 */
- (void)addTapGesture:(id)target selector:(SEL)selector {
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
    [self addGestureRecognizer:recognizer];
}

/**
 * 拖动手势
 */
- (void)addPanGesture:(id)target selector:(SEL)selector {
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:target action:selector];
    [self addGestureRecognizer:recognizer];
}

/**
 * 长按手势
 */
- (void)addLongPressGesture:(id)target selector:(SEL)selector {
    
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:selector];
    recognizer.minimumPressDuration = 0.3;
    [self addGestureRecognizer:recognizer];
}

@end


#pragma mark -
@implementation UIView (UIView_CAAnimation)

/** 顺时针旋转一个view angle 代表需要传入的角度 需要逆时针，请传入负数 */
- (void)animationRotate:(UIView *)view ToAngle:(CGFloat)angle
{
    [UIView animateWithDuration:0.5 animations:^{
        view.transform = CGAffineTransformRotate(view.transform, angle/180.0*M_PI);
    }];
}

/**
 * 类心跳振动动画
 */
- (void)animationHeartBeat {
    
    [UIView animateWithDuration:0.1
                     animations:^{
                         self.transform = CGAffineTransformMakeScale(1.01f, 1.01f);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1
                                          animations:^{
                                              self.transform = CGAffineTransformMakeScale(0.99f, 0.99f);
                                          }
                                          completion:^(BOOL finished) {
                                              self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                                          }];
                     }];
}

/**
 * 线性消失动画
 */
- (void)animationCurveEaseOut {
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

/**
 * 设置图层来回抖动
 * @param enable
 */
- (void)animationShake:(BOOL)enable {
    
    if(enable) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.fromValue = [NSNumber numberWithFloat:-0.05];
        animation.toValue = [NSNumber numberWithFloat:+0.05];
        animation.duration = 0.1;
        animation.autoreverses = YES; //是否重复
        animation.repeatCount = MAXFLOAT;
        [self.layer addAnimation:animation forKey:@"shake"];
    }
    else {
        [self.layer removeAnimationForKey:@"shake"];
    }
}

/**
 * 旋转动画
 * @pram value
 */
- (CABasicAnimation *)animationRotate:(CGFloat)value {
    
    CABasicAnimation* rotate =  [CABasicAnimation animationWithKeyPath: @"transform.rotation.z"];
    rotate.toValue = [NSNumber numberWithFloat:M_PI*2];
    rotate.repeatCount = MAXFLOAT;
    rotate.duration = 10; //动画整体时间为0.05s * 60 = 3s
    rotate.cumulative = YES;
    rotate.delegate = self;
    [self.layer addAnimation:rotate forKey:@"rotateAnimation"];
    return rotate;
}

@end
