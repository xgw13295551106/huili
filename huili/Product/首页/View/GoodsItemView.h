//
//  GoodItemView.h
//  yihuo
//
//  Created by zhongweike on 2017/12/26.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GoodsItemViewDelegate <NSObject>

- (void)touchGoodsItemView:(NSDictionary *)dic;

@end


@interface GoodsItemView : UIView


@property (nonatomic,strong)NSDictionary *infoDic;

@property (nonatomic,weak)id<GoodsItemViewDelegate>delegate;

@end
