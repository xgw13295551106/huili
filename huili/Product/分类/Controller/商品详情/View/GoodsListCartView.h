//
//  GoodsListCartView.h
//  YeFu
//
//  Created by Carl on 2017/12/22.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GoodsListCartViewDelegate <NSObject>

-(void)goToOrder;
-(void)gotoCart;

@end

@interface GoodsListCartView : UIView

@property(nonatomic)UIButton *addCart;

-(void)getCartNumber;

@property (nonatomic,weak) id<GoodsListCartViewDelegate>delegate;

@end
