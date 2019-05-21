//
//  UIView+resetFrame.h
//  Label_autosize
//
//  Created by zxy on 16/8/31.
//  Copyright © 2016年 CPIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (resetFrame)

/**type为1-4分别表示 1-left 2-top 3-wid 4-height,value 为rect对应的值*/
- (void)resetFrameWithType:(NSInteger)type andValue:(CGFloat)value;

@end
