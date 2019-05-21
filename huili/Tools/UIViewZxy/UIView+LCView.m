//
//  UIView+LCView.m
//  EduParent
//
//  Created by zhongweike on 2017/9/14.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "UIView+LCView.h"

@implementation UIView (LCView)

- (void)setMinX:(CGFloat)minX{
    CGRect frame = self.frame;
    frame.origin.x = minX;
    self.frame = frame;
}

- (CGFloat)minX{
    return self.frame.origin.x;
}

-(void)setMinY:(CGFloat)minY{
    CGRect frame = self.frame;
    frame.origin.y = minY;
    self.frame = frame;
}

- (CGFloat)minY{
    return self.frame.origin.y;
}

- (void)setMaxX:(CGFloat)maxX{
    CGRect frame = self.frame;
    if (maxX > frame.origin.x + frame.size.width) {
        frame.origin.x = frame.origin.x + (maxX - (frame.size.width + frame.origin.x));
    }else if(maxX < frame.origin.x + frame.size.width){
        frame.origin.x = frame.origin.x-((frame.origin.x+frame.size.width)-maxX);
    }else{
        //maxX = x+width的情况
        frame.origin.x  = self.frame.origin.x;
    }
    self.frame = frame;
}

- (CGFloat)maxX{
    return CGRectGetMaxX(self.frame);
}

- (void)setMaxY:(CGFloat)maxY{
    CGRect frame = self.frame;
    if (maxY > frame.origin.y + frame.size.height) {
        frame.origin.y = frame.origin.y + (maxY - (frame.origin.y + frame.size.height));
    }else if (maxY < frame.origin.y + frame.size.height){
        frame.origin.y = frame.origin.y -((frame.origin.y + frame.size.height)-maxY);
    }else{
        //maxY = y+height的情况
        frame.origin.y = self.frame.origin.y;
    }
    self.frame = frame;
}

- (CGFloat)maxY{
    return CGRectGetMaxY(self.frame);
}

- (void)setCenterX:(CGFloat)centerX{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY{
    return self.center.y;
}

- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width{
    return self.bounds.size.width;
}

- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height{
    return self.bounds.size.height;
}

- (void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin{
    return self.frame.origin;
}


@end
