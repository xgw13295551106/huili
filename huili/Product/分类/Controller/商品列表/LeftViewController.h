//
//  LeftViewController.h
//  yihuo
//
//  Created by Carl on 2017/12/26.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "YHBaseViewController.h"
#import "ClassifyModel.h"

typedef void(^selectClassBlock)(ClassifyModel *model);


/**
 筛选view
 */
@interface LeftViewController : YHBaseViewController

@property(nonatomic)NSArray *dataArray;

@property(nonatomic)ClassifyModel *currentModel;

@property (nonatomic,strong)selectClassBlock selectClassBlock;

@end
