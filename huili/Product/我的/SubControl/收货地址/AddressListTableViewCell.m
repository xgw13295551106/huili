//
//  AddressListTableViewCell.m
//  YeFu
//
//  Created by Carl on 2017/12/15.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "AddressListTableViewCell.h"

@interface AddressListTableViewCell ()

@property (nonatomic,weak)UIImageView *deaflet;
@property (nonatomic,weak)UILabel *name;
@property (nonatomic,weak)UILabel *phone;
@property (nonatomic,weak)UILabel *address;
@property (nonatomic,weak)UILabel *defaultLabel;

@end

@implementation AddressListTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *deaflet=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 80)];
        [deaflet setImage:[UIImage imageNamed:@"common_icon_choose"]];
        [self addSubview:deaflet];
        [deaflet setContentMode:UIViewContentModeCenter];
        _deaflet=deaflet;
//        [deaflet setHidden:YES];
        
        UILabel *name=[[UILabel alloc]initWithFrame:CGRectMake(15, 5, 100, 25)];
        [name setTextColor:text1Color];
        [name setFont:[UIFont boldSystemFontOfSize:18]];
        [self addSubview:name];
        _name=name;
        
        UILabel *phone=[[UILabel alloc]initWithFrame:CGRectMake(120, 5, 150, 25)];
        [phone setTextColor:text1Color];
        [phone setFont:[UIFont boldSystemFontOfSize:18]];
        [self addSubview:phone];
        _phone=phone;
        
        UILabel *defaultLabel=[[UILabel alloc]initWithFrame:CGRectMake(275, 7.5, 45, 20)];
        [defaultLabel setText:@"默认"];
        _defaultLabel=defaultLabel;
        [defaultLabel setTextColor:STYLECOLOR];
        [defaultLabel setFont:[UIFont systemFontOfSize:12]];
        [defaultLabel.layer setCornerRadius:3];
        [defaultLabel.layer setBorderWidth:1];
        [defaultLabel.layer setMasksToBounds:YES];
        [self addSubview:defaultLabel];
        [defaultLabel setTextAlignment:NSTextAlignmentCenter];
        [defaultLabel.layer setBorderColor:STYLECOLOR.CGColor];
        
        UILabel *address=[[UILabel alloc]initWithFrame:CGRectMake(15, 30, AL_DEVICE_WIDTH-65, 45)];
        [address setTextColor:text1Color];
        [address setFont:[UIFont systemFontOfSize:15]];
        [address setNumberOfLines:2];
        [self addSubview:address];
        _address=address;
        
        UIButton *editBtn=[[UIButton alloc]initWithFrame:CGRectMake(AL_DEVICE_WIDTH-50, 0, 50, 80)];
        [editBtn setImage:[UIImage imageNamed:@"user_button_address_edit"] forState:UIControlStateNormal];
        [self addSubview:editBtn];
        [editBtn addTarget:self action:@selector(editCilck) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

-(void)setModel:(AddressListModel *)model{
    _model=model;
    if ([_model.is_default isEqualToString:@"1"]) {
        [_deaflet setHidden:NO];
        [_name setFrame:CGRectMake(40, 5, 100, 25)];
        [_phone setFrame:CGRectMake(145, 5, 150, 25)];
        [_address setFrame:CGRectMake(40, 30, AL_DEVICE_WIDTH-90, 45)];
        [_defaultLabel setHidden:NO];
    }else{
        [_deaflet setHidden:YES];
        [_name setFrame:CGRectMake(15, 5, 100, 25)];
        [_phone setFrame:CGRectMake(120, 5, 150, 25)];
        [_address setFrame:CGRectMake(15, 30, AL_DEVICE_WIDTH-115, 45)];
        [_defaultLabel setHidden:YES];
    }
    [_name setText:model.consignee];
    [_phone setText:model.mobile];
    [_address setText:[NSString stringWithFormat:@"%@%@%@  %@ %@",model.province,model.city,model.district,model.build_no,model.address]];
}


-(void)editCilck{
    if ([self.delegate respondsToSelector:@selector(editAddress:)]) {
        [self.delegate editAddress:_model];
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
