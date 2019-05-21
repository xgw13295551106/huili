//
//  LCMyOrderStatusView.h
//  YeFu
//
//  Created by zhongweike on 2017/12/11.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyOrderStatusBlock)(int selectIndex);

/**
 选择我的订单状态view 全部、已下单、配送中、待评价、已评价
 */
@interface LCMyOrderStatusView : UIView

/**
 获取我的订单状态选择view

 @param frame 尺寸大小
 @param statusBlock 返回点击选择的状态
 @return view
 */
+ (instancetype)getMyOrderStatusView:(CGRect)frame
                            andBlock:(MyOrderStatusBlock)statusBlock;
//选中的状态
@property (nonatomic,assign)int selectIndex;

@end
