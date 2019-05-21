//
//  LCBalanceTableCell.h
//  shop_send
//
//  Created by zhongweike on 2017/12/7.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCBalanceTableCell : UITableViewCell

+ (instancetype)getMyPurseInfoCell:(UITableView *)tableView
                          andIndex:(NSIndexPath *)indexPath
                     andIdentifier:(NSString *)identifier;


@end
