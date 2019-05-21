//
//  LCHomeTableViewCell.h
//  huili
//
//  Created by zhongweike on 2018/1/5.
//  Copyright © 2018年 zwk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HomeCellBlock)(NSDictionary *goodsDic);

/**
 今日特价商品cell
 */
@interface LCHomeTableViewCell : UITableViewCell

/**
 获取今日特价商品cell

 @param tableView tableView
 @param identifier 标识符
 @param indexPath 坐标
 @param dic 内容
 @return cell
 */
+ (instancetype)getHomeCell:(UITableView *)tableView
              andIdentifier:(NSString *)identifier
                   andIndex:(NSIndexPath *)indexPath
                     andDic:(NSDictionary *)dic
                   andBlock:(HomeCellBlock)block;

+ (CGFloat)getHomeCellHeight;




@end
