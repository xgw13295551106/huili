//
//  LCUserInfoCell.h
//  zhuaWaWa
//
//  Created by zhongweike on 2017/11/24.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UserInfoCellBlock)(BOOL isRecharge);  ///< 充值时调用该block

@interface LCUserInfoCell : UITableViewCell

+ (instancetype)getUserInfoCell:(UITableView *)tableView
                       andIndex:(NSIndexPath *)indexPath
                  andIdentifier:(NSString *)identifier
                       andArray:(NSArray *)dataArray
                       andBlock:(UserInfoCellBlock)block;

@end
