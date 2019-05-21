//
//  SendTypeTableViewCell.m
//  YeFu
//
//  Created by Carl on 2017/12/19.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "SendTypeTableViewCell.h"

@interface SendTypeTableViewCell ()

@property(nonatomic,weak)UIImageView *selectImg;
@property(nonatomic,weak)UILabel *consigneeLabel;
@property(nonatomic,weak)UILabel *timeLabel;

@end

@implementation SendTypeTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *selectImg=[[UIImageView alloc]initWithFrame:CGRectMake(AL_DEVICE_WIDTH-44, 0, 44, 44)];
        _selectImg=selectImg;
        [selectImg setContentMode:UIViewContentModeCenter];
        [self addSubview:selectImg];
        
        UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(AL_DEVICE_WIDTH-200, 0, 160, 44)];
        [timeLabel setTextColor:STYLECOLOR];
        [timeLabel setTextAlignment:NSTextAlignmentRight];
        [timeLabel setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:timeLabel];
        _timeLabel=timeLabel;
    }
    return self;
}

-(void)setModel:(SelectTimeModel *)model{
    _model=model;
    [self.textLabel setText:model.timeLeft];
    [_timeLabel setText:model.time];
    if (_model.isSelect) {
        [_timeLabel setHidden:NO];
        [_selectImg setImage:[UIImage imageNamed:@"login_xuanze"]];
    }else{
        [_timeLabel setHidden:YES];
        [_selectImg setImage:[UIImage imageNamed:@"login_weixuan"]];
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
