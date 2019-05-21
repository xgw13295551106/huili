//
//  LCBillDetailFouthCell.h
//  YeFu
//
//  Created by zhongweike on 2017/12/20.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LCIndetailModel;
@interface LCBillDetailFouthCell : UITableViewCell

+ (instancetype)getBillDetailFouthCell:(UITableView *)tableView
                              andIndex:(NSIndexPath *)indexPath
                         andIdentifier:(NSString *)identifier
                              andModel:(LCIndetailModel *)model;

+ (CGFloat)getBillDetailFouthCellHeight;


@end
