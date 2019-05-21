//
//  LCIncomeListCell.h
//  shop_send
//
//  Created by zhongweike on 2017/12/7.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 收入明细列表cell
 */
@interface LCIncomeListCell : UITableViewCell

+ (instancetype)getIncomeListCell:(UITableView *)tableView
                    andIndex:(NSIndexPath *)indexPath
                    andIdentifier:(NSString *)identifier
                           andDic:(NSDictionary *)dic;


@end
