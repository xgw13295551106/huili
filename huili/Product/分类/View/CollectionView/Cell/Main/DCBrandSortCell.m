//
//  DCBrandSortCell.m
//  CDDMall
//
//  Created by apple on 2017/6/8.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCBrandSortCell.h"

@interface DCBrandSortCell ()

/* imageView */
@property (strong , nonatomic)UIImageView *brandImageView;

@end

@implementation DCBrandSortCell

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

#pragma mark - UI
- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    _brandImageView = [[UIImageView alloc] init];
    _brandImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_brandImageView];
    
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [_brandImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width - 20, self.frame.size.height - 25));
    }];
}

#pragma mark - Setter Getter Methods
- (void)setSubItem:(CatModel *)subItem
{
    _subItem = subItem;
    [_brandImageView sd_setImageWithURL:[NSURL URLWithString:subItem.img]];
}

@end
