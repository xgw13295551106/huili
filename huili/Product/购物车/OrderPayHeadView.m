//
//  OrderPayHeadView.m
//  YeFu
//
//  Created by Carl on 2017/12/19.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "OrderPayHeadView.h"

@interface OrderPayHeadView (){
    UIImageView *bottomImgView;
}

@property(nonatomic,weak)UILabel *addressLabel;
@property(nonatomic,weak)UILabel *consigneeLabel;
@property(nonatomic,weak)UIImageView *locationIcon;
@property(nonatomic,weak)UILabel *addressLabel1;


@end

@implementation OrderPayHeadView

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        UIImageView *locationIcon=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 60)];
        _locationIcon=locationIcon;
        [locationIcon setImage:[UIImage imageNamed:@"order_icon_location"]];
        [locationIcon setContentMode:UIViewContentModeCenter];
        [self addSubview:locationIcon];
        UILabel *addressLabel=[[UILabel alloc]initWithFrame:CGRectMake(locationIcon.right, 0, AL_DEVICE_WIDTH-locationIcon.right-50, 70)];
        [addressLabel setNumberOfLines:2];
        [addressLabel setTextColor:[UIColor whiteColor]];
        [addressLabel setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:addressLabel];
        _addressLabel=addressLabel;
        
        UIImageView *row=[[UIImageView alloc]initWithFrame:CGRectMake(AL_DEVICE_WIDTH-50, 0, 50, 70)];
        [row setImage:[UIImage imageNamed:@"order_button_arrows_def"]];
        [row setContentMode:UIViewContentModeCenter];
        [self addSubview:row];
        
        UILabel *consigneeLabel=[[UILabel alloc]initWithFrame:CGRectMake(addressLabel.left, addressLabel.bottom-5, AL_DEVICE_WIDTH-50, 20)];
        [consigneeLabel setNumberOfLines:2];
        [consigneeLabel setTextColor:[UIColor whiteColor]];
        [consigneeLabel setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:consigneeLabel];
        _consigneeLabel=consigneeLabel;
        
        UILabel *addressLabel1=[[UILabel alloc]initWithFrame:CGRectMake((AL_DEVICE_WIDTH-180)/2, 15, 180, 30)];
        [addressLabel1 setText:@"+ 新建收货地址"];
        _addressLabel1=addressLabel1;
        [addressLabel1 setTextAlignment:NSTextAlignmentCenter];
        [addressLabel1 setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        [addressLabel1 setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:addressLabel1];
        [addressLabel1 setBorderColor:[UIColor colorWithHexString:@"ffffff"]];
        [addressLabel1.layer setCornerRadius:15];
        [addressLabel1 setBorderWidth:1];
        [addressLabel1.layer setMasksToBounds:YES];
        [addressLabel1 setHidden:YES];
        
        
        UIImage *bottomImage = [UIImage imageNamed:@"order_address_lin"];
        bottomImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.height-1, self.width, bottomImage.size.height)];
        [bottomImgView setImage:bottomImage];
        [self addSubview:bottomImgView];
        
    }
    return self;
}

-(void)setModel:(AddressListModel *)model{
    if (model.address_id.length>0 && model.address_id.intValue != 0) {
        [_addressLabel setText:[NSString stringWithFormat:@"%@%@%@  %@ %@",model.province,model.city,model.district,model.build_no,model.address]];
        [_consigneeLabel setText:[NSString stringWithFormat:@"%@  %@",model.consignee,model.mobile]];
        [_locationIcon setHidden:NO];
        [_addressLabel setHidden:NO];
        [_consigneeLabel setHidden:NO];
        [_addressLabel1 setHidden:YES];
        bottomImgView.hidden = YES;
    }else{
        [_locationIcon setHidden:YES];
        [_addressLabel setHidden:YES];
        [_consigneeLabel setHidden:YES];
        [_addressLabel1 setHidden:NO];
        bottomImgView.hidden = NO;
    }
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
