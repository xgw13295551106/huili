//
//  LCExtractListwCell.h
//  shop_send
//
//  Created by zhongweike on 2017/12/7.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCExtractListwCell : UITableViewCell

/**
 获取提现记录cell
 
 @param tableView 要显示cell的tableView
 @param indexPath 坐标indexPath
 @param identifier cell标识
 @param dic cell的数据源{id,pay_id,money,updated_at}
 @return 返回cell
 */
+ (instancetype)getExtractListCell:(UITableView *)tableView
                           andIndex:(NSIndexPath *)indexPath
                      andIdentifier:(NSString *)identifier
                             andDic:(NSDictionary *)dic;


@end
