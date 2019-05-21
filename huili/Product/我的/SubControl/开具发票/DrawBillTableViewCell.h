//
//  DrawBillTableViewCell.h
//  YeFu
//
//  Created by Carl on 2017/12/9.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BillArrayModel.h"

@protocol DrawBillTableViewCellDelegate <NSObject>

-(void)checkPrice;

@end

@interface DrawBillTableViewCell : UITableViewCell

@property(nonatomic)BillModel *model;

@property (nonatomic,weak) id<DrawBillTableViewCellDelegate>delegate;

@property (nonatomic,assign)BOOL noSelect;

@end
