//
//  UIView+resetFrame.m
//  Label_autosize
//
//  Created by zxy on 16/8/31.
//  Copyright © 2016年 CPIC. All rights reserved.
//

#import "UIView+resetFrame.h"

@implementation UIView (resetFrame)
/**1-left 2-top 3-wid 4-height*/
- (void)resetFrameWithType:(NSInteger)type andValue:(CGFloat)value{
    switch (type) {
        case 1:
        {
            self.frame = CGRectMake(value, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        }
            break;
        case 2:
        {
            self.frame = CGRectMake(self.frame.origin.x, value, self.frame.size.width, self.frame.size.height);
        }
            break;
        case 3:
        {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, value, self.frame.size.height);
        }
            break;
        case 4:
        {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, value);
        }
            break;
            
        default:
            break;
    }
}

@end
