//
//  ZYSparesButton.m
//  西藏自治区
//
//  Created by 张宇 on 16/5/30.
//  Copyright © 2016年 成都拓尔思. All rights reserved.
//

#import "ZYSparesButton.h"
#import "ZYDefinition.h"
#import "UIView+Extentions.h"

@interface ZYSparesButton ()

@property (nonatomic, weak  ) UIButton        *delButton;

@end

@implementation ZYSparesButton

- (instancetype)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.titleLabel.font = [UIFont systemFontOfSize:kSparesBtnFont];
    [self setTitleColor:kSparesBtnColorNor forState:UIControlStateNormal];
    [self setTitleColor:kSparesBtnColorSel forState:UIControlStateSelected];
    self.backgroundColor = [UIColor whiteColor];
    [self addDeleteButton];
}

- (void)setIsFixed:(BOOL)isFixed
{
    _isFixed = isFixed;
    if (isFixed) {   // 是固定的按钮 重新写一种按钮的样式
        [self.delButton removeFromSuperview];
    }
}

- (void)addDeleteButton
{
    // 添加隐藏的小'x' LOG
    UIButton *delButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    self.delButton = delButton;
    delButton.center = CGPointMake(4, 2);
    [delButton setBackgroundImage:[UIImage imageNamed:@"columnView_edit_delete"] forState:UIControlStateNormal];
    [delButton addTarget:self action:@selector(delButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    delButton.hidden = YES;
    [self addSubview:delButton];
    [self bringSubviewToFront:delButton];
    
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.delButton.hidden = !selected;
}

- (void)drawBorder
{
    UIView *top = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 1)];
    top.backgroundColor = ZYRGBColor(128, 128, 128);
    UIView *left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, self.height)];
    left.backgroundColor = ZYRGBColor(128, 128, 128);
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-1, self.width, 1)];
    bottom.backgroundColor = ZYRGBColor(128, 128, 128);
    UIView *right = [[UIView alloc] initWithFrame:CGRectMake(self.width - 1, 0, 1, self.height)];
    right.backgroundColor = ZYRGBColor(128, 128, 128);
    [self addSubview:top];
    [self addSubview:left];
    [self addSubview:bottom];
    [self addSubview:right];
}

/** 删除图标点击事件 */
- (void)delButtonDidClick:(UIButton *)button
{
    if (self.delCallback) {
        self.delCallback(button);
    }
}

@end
