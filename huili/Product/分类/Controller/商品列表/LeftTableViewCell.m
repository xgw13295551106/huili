//
//  LeftTableViewCell.m
//  yihuo
//
//  Created by Carl on 2017/12/27.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "LeftTableViewCell.h"

@interface LeftTableViewCell ()

@property(nonatomic,weak)UIImageView *img;

@end

@implementation LeftTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(AL_DEVICE_WIDTH * 0.75-60, 0, 60, 44)];
        [img setImage:[UIImage imageNamed:@"common_icon_choose"]];
        [img setContentMode:UIViewContentModeCenter];
        [self addSubview:img];
        _img=img;
        [img setHidden:YES];
    }
    return self;
}


-(void)setModel:(ClassifyModel *)model{
    _model=model;
    [self.textLabel setText:model.name];
    [self.textLabel setTextColor:text1Color];
    if (self.current) {
        [_img setHidden:NO];
        [self.textLabel setTextColor:STYLECOLOR];
    }else{
        [_img setHidden:YES];
        [self.textLabel setTextColor:text1Color];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
