//
//  SelectAreaViewController.h
//  YeFu
//
//  Created by Carl on 2017/12/7.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "YHBaseViewController.h"

@protocol SelectAreaViewControllerDelegate <NSObject>

-(void)sl_currentCity:(NSString*)city supplier_id:(NSInteger)supplier_id;

@end

@interface SelectAreaViewController : YHBaseViewController

@property(nonatomic)NSString *city;

/** 代理 */
@property (weak, nonatomic) id<SelectAreaViewControllerDelegate> delegate;

@end
