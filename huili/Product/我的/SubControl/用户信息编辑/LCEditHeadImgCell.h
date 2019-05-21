//
//  LCEditHeadImgCell.h
//  StudioRecognition
//
//  Created by zhongweike on 2017/10/11.
//  Copyright © 2017年 zhongweike. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 编辑用户头像cell
 */
@interface LCEditHeadImgCell : UITableViewCell

+ (instancetype)getEditHeadImgCell:(UITableView *)tableView
                          andIndex:(NSIndexPath *)indexPath
                     andIdentifier:(NSString *)identifier;


@end
