//
//  UILabel+autosize.h
//  Label_autosize
//
//  Created by 张新亚 on 16/8/17.
//  Copyright © 2016年 张新亚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (autosize)

/**自适应label宽高，yes宽不变，no高不变*/
- (void)autoSizeWithType:(BOOL)type;

@end
