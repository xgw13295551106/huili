//
//  LCOrderStatusListCell.h
//  YeFu
//
//  Created by zhongweike on 2017/12/12.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LCMyOrderDetailModel;
typedef void(^OrderStatusListCellBlock)(BOOL isTel,LCMyOrderDetailModel *model);

@interface LCOrderStatusListCell : UITableViewCell

+ (instancetype)getOrderStatusListCell:(UITableView *)tableView
                              andIndex:(NSIndexPath *)indexPath
                         andIdentifier:(NSString *)identifier
                              andModel:(LCMyOrderDetailModel *)model
                               andList:(NSArray *)statusList
                              andBlock:(OrderStatusListCellBlock)block;

+ (CGFloat)getOrderStatusListCellHeight;

@end
