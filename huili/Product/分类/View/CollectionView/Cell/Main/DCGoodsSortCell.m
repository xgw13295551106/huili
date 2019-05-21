//
//  DCGoodsSortCell.m
//  CDDMall
//
//  Created by apple on 2017/6/8.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCGoodsSortCell.h"


@interface DCGoodsSortCell ()

/* imageView */
@property (strong , nonatomic)UIImageView *goodsImageView;
/* label */
@property (strong , nonatomic)UILabel *goodsTitleLabel;
@end

@implementation DCGoodsSortCell

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
    _goodsImageView = [[UIImageView alloc] init];
    _goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_goodsImageView.layer setMasksToBounds:YES];
    [self addSubview:_goodsImageView];
    
    _goodsTitleLabel = [[UILabel alloc] init];
    _goodsTitleLabel.font = PFR13Font;
    _goodsTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_goodsTitleLabel];
    
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        [make.top.mas_equalTo(self)setOffset:5];
        make.size.mas_equalTo(CGSizeMake(self.width * 0.85, self.width * 0.85));
    }];
    
    [_goodsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.top.mas_equalTo(_goodsImageView.mas_bottom)setOffset:5];
        make.width.mas_equalTo(_goodsImageView);
        make.centerX.mas_equalTo(self);
    }];
}


#pragma mark - Setter Getter Methods
- (void)setSubItem:(ClassifyModel *)subItem
{
    _subItem = subItem;
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:subItem.img] placeholderImage:DefaultsImg];
    _goodsTitleLabel.text = subItem.name;
}

@end
