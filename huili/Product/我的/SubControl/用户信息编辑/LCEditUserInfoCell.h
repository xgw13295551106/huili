//
//  LCEditUserInfoCell.h
//  StudioRecognition
//
//  Created by zhongweike on 2017/10/11.
//  Copyright © 2017年 zhongweike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCEditUserInfoCell : UITableViewCell

+ (instancetype)getEditUserInfoCell:(UITableView *)tableView
                           andIndex:(NSIndexPath *)indexPath
                      andIdentifier:(NSString *)identifier;


@end
