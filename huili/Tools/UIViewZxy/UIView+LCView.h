//
//  UIView+LCView.h
//  EduParent
//
//  Created by zhongweike on 2017/9/14.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LCView)

/** view的x点坐标 */
@property (nonatomic,assign)CGFloat minX;

/** view的y点坐标 */
@property (nonatomic,assign)CGFloat minY;

/** view的x点坐标最大值 */
@property (nonatomic,assign)CGFloat maxX;

/** view的y点坐标最大值 */
@property (nonatomic,assign) CGFloat maxY;

/** view的中心点x的坐标 */
@property (nonatomic,assign) CGFloat centerX;

/** view的中心点y的坐标 */
@property (nonatomic,assign) CGFloat centerY;

/** view的宽度 */
@property (nonatomic,assign) CGFloat width;

/** view的高度 */
@property (nonatomic,assign) CGFloat height;

/** view的尺寸 */
@property (nonatomic,assign) CGSize size;

/** view的坐标 */
@property (nonatomic,assign) CGPoint origin;



@end
