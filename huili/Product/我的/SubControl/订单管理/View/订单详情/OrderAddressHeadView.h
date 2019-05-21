//
//  OrderAddressHeadView.h
//  yihuo
//
//  Created by zhongweike on 2017/12/27.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddressListModel;
@class LCMyOrderDetailModel;

@interface OrderAddressHeadView : UIView

//通过字典赋值
- (void)setAddressInfo:(LCMyOrderDetailModel *)model;

@property (nonatomic,assign)BOOL hideRightImg;

@end
