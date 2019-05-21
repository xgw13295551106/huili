//
//  ZYSparesButton.h
//  西藏自治区
//
//  Created by 张宇 on 16/5/30.
//  Copyright © 2016年 成都拓尔思. All rights reserved.
//  下拉展开后备选的按钮

#import <UIKit/UIKit.h>
@class ZYSparesButton;

typedef void(^delCallback)(UIButton *delButton);

@interface ZYSparesButton : UIButton

/** 记录按钮宽度的属性(便于以后扩展不规则排布,目前暂时不支持.) */
@property (nonatomic, assign) CGFloat         buttonW;

/** 是否是固定栏目分类 */
@property (nonatomic, assign) BOOL            isFixed;
/** 删除叉叉图标按钮点击回调 */
@property (nonatomic, copy  ) delCallback     delCallback;

@end
