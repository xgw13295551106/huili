//
//  LCMyOrderListCell.h
//  YeFu
//
//  Created by zhongweike on 2017/12/11.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LCMyOrderDetailModel;




///订单列表事件操作反馈block
typedef void(^MyOrderListBlock)(OrderButtonEvent orderEvent,LCMyOrderDetailModel *model);

/**
 我的订单列表
 */
@interface LCMyOrderListCell : UITableViewCell

/**
 获取订单列表cell

 @param tableView 要显示cell的tableview
 @param indexPath cell的indexpath
 @param model 显示cell用到的数据
 @param orderBlock 点击cell中控件的一些事件反馈
 @return 订单列表cell
 */
+ (instancetype)getMyOrderListCell:(UITableView *)tableView
                          andIndex:(NSIndexPath *)indexPath
                         andModel:(LCMyOrderDetailModel *)model
                         andBlock:(MyOrderListBlock)orderBlock;


/**
 获取订单列表cell的高度

 @param tableView 要显示cell的tableview
 @param indexPath cell的indexpath
 @param model 显示cell用到的数据
 @return 订单列表cell的高度
 */
+ (CGFloat)getMyOrderListCellHeight:(UITableView *)tableView
                           andIndex:(NSIndexPath *)indexPath
                           andModel:(LCMyOrderDetailModel *)model;

@end
