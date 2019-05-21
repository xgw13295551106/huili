//
//  LCWuliuCell.h
//  huili
//
//  Created by zhongweike on 2018/1/12.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 物流信息cell
 */
@interface LCWuliuCell : UITableViewCell

+ (instancetype)getWuliuCell:(UITableView *)tableView
                    andIndex:(NSIndexPath *)indexPath
               andIdentifier:(NSString *)identifier
                      andDic:(NSDictionary *)dic;

+ (CGFloat)getWuliuCellHeightWith:(NSDictionary *)dic;

@end
