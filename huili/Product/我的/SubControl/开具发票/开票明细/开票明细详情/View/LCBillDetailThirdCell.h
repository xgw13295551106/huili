//
//  LCBillDetailThirdCell.h
//  YeFu
//
//  Created by zhongweike on 2017/12/20.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LCIndetailModel;

@interface LCBillDetailThirdCell : UITableViewCell

+ (instancetype)getBillDetailThirdCell:(UITableView *)tableView
                              andIndex:(NSIndexPath *)indexPath
                         andIdentifier:(NSString *)identifier
                              andModel:(LCIndetailModel *)model;

+ (CGFloat)getBillDetailThirdCellHeight:(LCIndetailModel *)model;

@end
