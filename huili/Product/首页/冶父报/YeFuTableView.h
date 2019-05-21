//
//  YeFuTableView.h
//  YeFu
//
//  Created by Carl on 2017/12/7.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YeFuListTableViewCell.h"

@protocol YeFuTableViewDelegate <NSObject>

-(void)lookDetail:(YeFuListModel*)model;

@end

@interface YeFuTableView : UIView

@property(nonatomic)NSString *name;

@property(nonatomic)NSString *cat_id;

@property (nonatomic,weak) id<YeFuTableViewDelegate>delegate;

@end
