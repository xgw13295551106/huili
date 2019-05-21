//
//  YHHomeHeadView.h
//  yihuo
//
//  Created by zhongweike on 2017/12/25.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    clickBanner,     ///< 点击banner
    clickClassify,  ///< 点击分类
    clickGoods, ///< 点击商品
    clickKill,  ///< 点击秒杀专场
}ClickHeadType;

typedef void(^HomeHeadBlock)(NSDictionary *info ,ClickHeadType clickType);

@interface YHHomeHeadView : UIView

+ (instancetype)getHomeHeadView:(CGRect)frame
                       andBlock:(HomeHeadBlock)headBlock;

- (void)reloadHeadViewWith:(NSDictionary *)dic;

@end
