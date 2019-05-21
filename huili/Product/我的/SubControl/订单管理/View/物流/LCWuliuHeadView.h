//
//  LCWuliuHeadView.h
//  huili
//
//  Created by zhongweike on 2018/1/12.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 物流信息头部head
 */
@interface LCWuliuHeadView : UIView

+ (instancetype)getWuliuHeadView:(CGRect)frame
                          andDic:(NSDictionary *)dic;

@property (nonatomic,copy)NSString *order_goods_img;

@end
