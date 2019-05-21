//
//  UILabel+autosize.m
//  Label_autosize
//
//  Created by 张新亚 on 16/8/17.
//  Copyright © 2016年 张新亚. All rights reserved.
//

#import "UILabel+autosize.h"

@implementation UILabel (autosize)

- (void)autoSizeWithType:(BOOL)type{
    //
    if (self.frame.size.width==0 &&self.frame.size.height==0 ) {
        NSLog(@"label的初始frame未设置");
        return;
    }
    //
    CGFloat label_x = self.frame.origin.x;
    CGFloat label_y = self.frame.origin.y;
    CGFloat label_width = self.frame.size.width;
    CGFloat label_height = self.frame.size.height;
    //
    self.numberOfLines = 0;
    self.lineBreakMode = NSLineBreakByTruncatingTail;
    //
    CGSize maximumLabelSize;
    if (type) {
        maximumLabelSize = CGSizeMake(label_width, 9999);
        CGSize expectSize = [self sizeThatFits:maximumLabelSize];
        
        self.frame = CGRectMake(label_x, label_y, label_width, expectSize.height);
    }else{
        maximumLabelSize = CGSizeMake(9999, label_height);
        CGSize expectSize = [self sizeThatFits:maximumLabelSize];
        
        self.frame = CGRectMake(label_x, label_y, expectSize.width, label_height);
    }
    //
    

}

@end
