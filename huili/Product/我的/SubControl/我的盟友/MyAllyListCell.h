//
//  MyAllyListCell.h
//  huili
//
//  Created by zhongweike on 2018/1/16.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAllyListCell : UITableViewCell

+ (instancetype)getAllyListCell:(UITableView *)tableView
                       andIndex:(NSIndexPath *)indexPath
                  andIdentifier:(NSString *)identifier
                         andDic:(NSDictionary *)dic;

+ (CGFloat)getAllyListCellHeight;


@end

