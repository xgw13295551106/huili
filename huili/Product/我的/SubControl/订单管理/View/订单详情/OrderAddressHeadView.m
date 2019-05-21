//
//  OrderAddressHeadView.m
//  yihuo
//
//  Created by zhongweike on 2017/12/27.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "OrderAddressHeadView.h"
#import "AddressListModel.h"
#import "LCMyOrderDetailModel.h"

@interface OrderAddressHeadView (){
    UILabel *contactLabel;     ///< 联系label
    UILabel *addressLabel;     ///< 地址label
    
    UIImageView *leftImgView;
    UIImageView *rightImgView;
    UIImageView *bottomImgView;
    
    CGFloat self_width;
    CGFloat self_height;
}


@end

@implementation OrderAddressHeadView



- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self_width = frame.size.width;
        self_height = frame.size.height;
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    //订单地址
    UIImage *addressImage = [UIImage imageNamed:@"order_icon_location"];
    leftImgView = [[UIImageView alloc]initWithFrame:CGRectMake(12, self_height/2-addressImage.size.height/2, addressImage.size.width, addressImage.size.height)];
    [leftImgView setImage:addressImage];
    [self addSubview:leftImgView];
    
    //右侧箭头图片
    UIImage *rightImage = [UIImage imageNamed:@"order_button_arrows_def"];
    rightImgView = [[UIImageView alloc]initWithImage:rightImage];
    [rightImgView sizeToFit];
    [rightImgView setFrame:CGRectMake(self_width-10-rightImgView.width, self_height/2-rightImgView.height/2, rightImgView.width, rightImgView.height)];
    [self addSubview:rightImgView];
    
    CGFloat label_x = leftImgView.maxX+10;
    CGFloat label_w = rightImgView.minX-10 -label_x;
    
    //联系方式(姓名+号码)
    contactLabel = [[UILabel alloc]initWithFrame:CGRectMake(label_x, 15, label_w, 22)];
    contactLabel.textColor = [UIColor colorWithHexString:@"242428"];
    contactLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    contactLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:contactLabel];
    
    
    //联系地址
    addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(label_x, leftImgView.minY, label_w, 20)];
    addressLabel.textColor = [UIColor colorWithHexString:@"252529"];
    addressLabel.font = [UIFont systemFontOfSize:13];
    addressLabel.numberOfLines = 0;
    [self addSubview:addressLabel];
    
    UIImage *bottomImage = [UIImage imageNamed:@"order_address_lin"];
    bottomImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self_height-1, self_width, bottomImage.size.height)];
    [bottomImgView setImage:bottomImage];
    [self addSubview:bottomImgView];
    
    
    
}



- (void)setAddressInfo:(LCMyOrderDetailModel *)model{
    contactLabel.text = [NSString stringWithFormat:@"%@    %@",model.consignee,model.mobile];
    addressLabel.text = model.detail_address;
    CGSize address_size = [addressLabel sizeThatFits:CGSizeMake(contactLabel.width, MAXFLOAT)];
    addressLabel.size = address_size;
    
    self.height = addressLabel.maxY+28;
    bottomImgView.maxY = self.maxY;
    
    leftImgView.centerY = self.height/2;
    rightImgView.centerY = leftImgView.centerY;
    
    
}

- (void)setHideRightImg:(BOOL)hideRightImg{
    _hideRightImg = hideRightImg;
    rightImgView.hidden = hideRightImg;
}








@end
