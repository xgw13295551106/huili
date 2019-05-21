//
//  LCOrderDetailFootView.h
//  yihuo
//
//  Created by zhongweike on 2017/12/26.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCMyOrderDetailModel.h"


typedef void(^OrderDetailFootBlock)(LCMyOrderDetailModel *detailModel,OrderButtonEvent orderEvent);

/**
 订单详情底部foot
 */
@interface LCOrderDetailFootView : UIView

+ (instancetype)getOrderDetailFootView:(CGRect)frame
                              andModel:(LCMyOrderDetailModel *)detailModel
                              andBlock:(OrderDetailFootBlock)footBlock;



//赋值更新view
- (void)setInfoWith:(LCMyOrderDetailModel *)detailModel;

@end
