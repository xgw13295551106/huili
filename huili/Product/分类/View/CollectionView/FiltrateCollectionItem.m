//
//  FiltrateCollectionItemCollectionViewCell.m
//  huili
//
//  Created by zhongweike on 2018/1/11.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import "FiltrateCollectionItem.h"


@interface FiltrateCollectionItem ()



@end

@implementation FiltrateCollectionItem

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    _contentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_contentButton];
    _contentButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_contentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_contentButton setTitleColor:STYLECOLOR forState:UIControlStateSelected];
    [_contentButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"F4F5F4"]] forState:UIControlStateNormal];
    [_contentButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ffffff"]] forState:UIControlStateSelected];
    _contentButton.layer.cornerRadius = 2;
    _contentButton.layer.masksToBounds = YES;
    _contentButton.layer.borderWidth= 0.8;
    _contentButton.layer.borderColor = [UIColor clearColor].CGColor;
    [_contentButton addTarget:self action:@selector(clickContentButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.contentButton.frame = CGRectMake(0, 0, self.width, self.height);
    
}


- (void)setItemDic:(NSDictionary *)itemDic
{
    _itemDic = itemDic;
    [_contentButton setTitle:[_itemDic stringForKey:@"name"] forState:UIControlStateNormal];
    [_contentButton setTitle:[_itemDic stringForKey:@"name"] forState:UIControlStateSelected];
    
}


- (void)clickContentButton:(UIButton *)button{
    button.selected = !button.selected;
    button.layer.borderColor = button.selected?[STYLECOLOR CGColor]:[UIColor clearColor].CGColor;
    
    if (self.selectBlock) {
        self.selectBlock(button.selected, self.itemDic);
    }
}


- (void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    _contentButton.selected = isSelect;
    _contentButton.layer.borderColor = _contentButton.selected?[STYLECOLOR CGColor]:[UIColor clearColor].CGColor;
}

@end
