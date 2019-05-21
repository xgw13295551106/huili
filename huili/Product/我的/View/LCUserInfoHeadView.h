//
//  LCUserInfoHeadView.h
//  zhuaWaWa
//
//  Created by zhongweike on 2017/11/24.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCUserInfoHeadViewDelegate <NSObject>

-(void)editUser;

-(void)clickOrder:(int)type;

-(void)clickVip;

@end

@interface LCUserInfoHeadView : UIView

/**
 刷新view
 */
- (void)reloadView;

@property(nonatomic)NSDictionary *orderDic;

@property (nonatomic,weak) id<LCUserInfoHeadViewDelegate>delegate;

@end
