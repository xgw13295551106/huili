//
//  FiltrateCollectionHeadView.m
//  huili
//
//  Created by zhongweike on 2018/1/11.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import "FiltrateCollectionHeadView.h"

@interface FiltrateCollectionHeadView ()

@property (nonatomic,strong)UILabel *titleLabel;

@end

@implementation FiltrateCollectionHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"3A3B3A"];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_titleLabel];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _titleLabel.minX = 15;
    _titleLabel.centerY = self.height/2;
    _titleLabel.width = self.width - 15*2;
    _titleLabel.height = 20;
}

- (void)setName:(NSString *)name{
    _name = name;
    _titleLabel.text = name;
}

@end
