//
//  LCStatusProgressView.h
//  ConsumerProject
//
//  Created by zhongweike on 2017/8/30.
//  Copyright © 2017年 John.peng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCStatusProgressView : UIView


/**
 获取状态进度条O——O——O——O这种样式

 @param frame frame尺寸大小
 @param items 要显示的状态(上行显示key,下行显示value)
 @param selectImage 选中状态的image
 @param unSelectImage 未选中状态的image
 @return 返回LCStatusProgressView
 */
+ (instancetype)getStatusProgressView:(CGRect)frame
                             andItems:(NSArray<NSDictionary *> *)items
                       andSelectImage:(UIImage *)selectImage
                     andUnSelectImage:(UIImage *)unSelectImage
                       andSelectColor:(UIColor *)selectColor
                     andUnSelectColor:(UIColor *)unSelectColor;

/** 选中当前状态 0为全未选中 */
@property (nonatomic,assign)int selectIndex;

@end
