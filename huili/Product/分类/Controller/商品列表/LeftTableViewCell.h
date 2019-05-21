//
//  LeftTableViewCell.h
//  yihuo
//
//  Created by Carl on 2017/12/27.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassifyModel.h"

@interface LeftTableViewCell : UITableViewCell

@property(nonatomic)ClassifyModel *model;

@property(nonatomic)BOOL current;

@end
