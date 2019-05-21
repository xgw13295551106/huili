//
//  MapAddressTableViewCell.m
//  YeFu
//
//  Created by Carl on 2017/12/12.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "MapAddressTableViewCell.h"

@interface MapAddressTableViewCell ()

@property (nonatomic,weak)UIImageView *icon;
@property (nonatomic,weak)UILabel *name;
@property (nonatomic,weak)UILabel *current;
@property (nonatomic,weak)UILabel *address;

@end

@implementation MapAddressTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *icon=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 60)];
        [icon setImage:[UIImage imageNamed:@"user_address_icon_location_def"]];
        [self addSubview:icon];
        _icon=icon;
        [icon setContentMode:UIViewContentModeCenter];
        
        UILabel *name=[[UILabel alloc]initWithFrame:CGRectMake(40, 5, AL_DEVICE_WIDTH-60, 25)];
        _name=name;
        [name setTextColor:text1Color];
        [name setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:name];
        [name sizeToFit];
        [name setFrame:CGRectMake(40, 5, name.width, 25)];
        
        UILabel *current=[[UILabel alloc]initWithFrame:CGRectMake(name.right+10, 7.5, 100, 20)];
        [current setText:@"当前"];
        [current setHidden:YES];
        _current=current;
        [current setTextColor:[UIColor whiteColor]];
        [current setFont:[UIFont systemFontOfSize:14]];
        [current setTextAlignment:NSTextAlignmentCenter];
        [current.layer setCornerRadius:3];
        [current setBackgroundColor:[UIColor colorWithHexString:@"35c5bf"]];
        [self addSubview:current];
        [current.layer setMasksToBounds:YES];
        [current sizeToFit];
        [current setFrame:CGRectMake(name.right+5, 5, current.width+5, 25)];
        
        UILabel *address=[[UILabel alloc]initWithFrame:CGRectMake(40, 30, AL_DEVICE_WIDTH-60, 25)];
        [address setTextColor:text2Color];
        [address setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:address];
        _address=address;
    }
    return self;
}

-(void)setModel:(AmapAddressModel *)model{
    _model=model;
    [_icon setImage:[UIImage imageNamed:@"user_address_icon_location_def"]];
    [_current setHidden:YES];
    [_name setText:model.name];
    [_address setText:model.formattedAddress];
    [_name sizeToFit];
    [_name setFrame:CGRectMake(40, 5, _name.width, 25)];
    [_current setFrame:CGRectMake(_name.right+5, 7.5, _current.width, 20)];
}

-(void)setCurrent{
    [_icon setImage:[UIImage imageNamed:@"user_address_icon_location_sel"]];
    [_current setHidden:NO];
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
