//
//  CartTableViewCell.h
//  yihuo
//
//  Created by Carl on 2017/12/25.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartListModel.h"

@protocol CartTableViewCellDelegate <NSObject>

-(void)checkPrice;

-(void)delectCell:(CartListModel*)model;

@end

@interface CartTableViewCell : UITableViewCell

@property(nonatomic)CartListModel *model;

@property (nonatomic,weak) id<CartTableViewCellDelegate>delegate;

@end
