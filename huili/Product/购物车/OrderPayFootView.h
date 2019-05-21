//
//  OrderPayFootView.h
//  YeFu
//
//  Created by Carl on 2017/12/19.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderPayFootViewDelegate <NSObject>

@optional
-(void)changeBuyNum;
-(void)clickHandFeeButton;
-(void)clickSwitchAction:(UISwitch *)button;

@end

@interface OrderPayFootView : UIView


/** 购买数量 */
@property (nonatomic,copy) NSString *numValue;

/** 商品金额 */
@property (nonatomic,copy) NSString *coinValue;

/**使用易货币余额支付订单选择框*/
@property (nonatomic,strong) UISwitch *coinSwitch;

/** 可用积分 */
@property (nonatomic,copy) NSString *scoreValue;

/** 账户余额 */
@property (nonatomic,copy) NSString *balanceValue;




/**
 YES表示可以编辑数量，为NO表示不可以
 */
@property (nonatomic,assign)BOOL editNum;


@property (nonatomic,weak) id<OrderPayFootViewDelegate>delegate;

@end
