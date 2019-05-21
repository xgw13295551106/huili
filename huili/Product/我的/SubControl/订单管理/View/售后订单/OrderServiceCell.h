//
//  OrderServiceCell.h
//  huili
//
//  Created by zhongweike on 2018/1/12.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LCMyOrderDetailModel;

@interface OrderServiceCell : UITableViewCell

+ (instancetype)getOrderServiceCell:(UITableView *)tableView
                      andIdentifier:(NSString *)identifier
                           andIndex:(NSIndexPath *)indexPath
                           andModel:(LCMyOrderDetailModel *)model;


+ (CGFloat)getOrderServiceCellHeight;

@end
