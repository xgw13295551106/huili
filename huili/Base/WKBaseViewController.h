//
//  WKBaseViewController.h
//  Bee
//
//  Created by zxy on 2017/3/20.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "YHBaseViewController.h"
#import "YeFuListModel.h"
//#import <UIKit/UIKit.h>

@interface WKBaseViewController : YHBaseViewController

// The main and only UIProgressView
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic,copy) NSString *url;

@property (nonatomic, strong) UIColor *tintColor;

@property(nonatomic)YeFuListModel *model;

@end
