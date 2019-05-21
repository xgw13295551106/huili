//
//  AddressListHeadView.m
//  YeFu
//
//  Created by Carl on 2017/12/20.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "AddressListHeadView.h"

@implementation AddressListHeadView

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        UIView *searchBg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, 44)];
        [searchBg setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:searchBg];
        UISearchBar *searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(20, 7, AL_DEVICE_WIDTH-40, 30)];
        [searchBar setPlaceholder:@"选择城市、学校、小区、写字楼"];
        [searchBar.layer setBorderColor:text2Color.CGColor];
        [searchBar.layer setBorderWidth:0.5];
        [searchBar.layer setCornerRadius:3];
        searchBar.backgroundImage = [NSBundle py_imageNamed:@"clearImage"];
        [searchBg addSubview:searchBar];
        
        UIView *selectAddressBg=[[UIView alloc]initWithFrame:CGRectMake(0, searchBg.bottom+7, AL_DEVICE_WIDTH, 44)];
        [selectAddressBg setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:selectAddressBg];
        
        UIImageView *icon=[[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 44, 44)];
        [icon setContentMode:UIViewContentModeCenter];
        [icon setImage:[UIImage imageNamed:@"user_address_icon_find"]];
        [selectAddressBg addSubview:icon];
        UILabel *addressLabel=[[UILabel alloc]initWithFrame:CGRectMake(icon.right, 0, 200, 44)];
        [addressLabel setText:@"定位当前地点"];
        [addressLabel setTextColor:STYLECOLOR];
        [addressLabel setFont:[UIFont systemFontOfSize:16]];
        [selectAddressBg addSubview:addressLabel];
        
        UIImageView *row=[[UIImageView alloc]initWithFrame:CGRectMake(AL_DEVICE_WIDTH-44, 0, 44, 44)];
        [row setImage:[UIImage imageNamed:@"common_button_right_green_def"]];
        [row setContentMode:UIViewContentModeCenter];
        [selectAddressBg addSubview:row];
        
        UIButton *addressAdd=[[UIButton alloc]initWithFrame:self.frame];
        [self addSubview:addressAdd];
        _addressAdd=addressAdd;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
