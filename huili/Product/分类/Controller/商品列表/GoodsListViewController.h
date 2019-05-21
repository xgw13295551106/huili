//
//  GoodsListViewController.h
//  yihuo
//
//  Created by Carl on 2017/12/25.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "YHBaseViewController.h"
#import "ClassifyModel.h"

@interface GoodsListViewController : YHBaseViewController

@property(nonatomic)ClassifyModel *model;

@property(nonatomic)NSArray *listArray;


-(void)searchClick;

@end
