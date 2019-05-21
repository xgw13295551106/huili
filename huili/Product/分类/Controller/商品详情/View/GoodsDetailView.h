//
//  GoodsDetailView.h
//  YeFu
//
//  Created by Carl on 2017/12/6.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GoodsDetailViewDelegate <NSObject>

-(void)showImgArray:(NSArray*)array setIndex:(int)index;

-(void)selectGuiGe;

@end

@interface GoodsDetailView : UIView

@property(nonatomic)NSDictionary *dic;

@property(nonatomic,weak)UILabel *selectValue;

@property (nonatomic,weak) id<GoodsDetailViewDelegate>delegate;

@end
