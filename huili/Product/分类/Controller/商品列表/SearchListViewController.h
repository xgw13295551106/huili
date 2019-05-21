//
//  SearchListViewController.h
//  yihuo
//
//  Created by Carl on 2017/12/27.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "YHBaseViewController.h"
#import "ClassifyModel.h"

@interface SearchListViewController : YHBaseViewController

@property(nonatomic)NSString *key;

@property(nonatomic)ClassifyModel *model;

@property(nonatomic)NSString *is_special;//今日特价 1是 0否

@property(nonatomic)NSString *is_selling;//易货热卖 1是 0否

@property(nonatomic)NSString *is_new;//限购 1是 0否

@end
