//
//  AddressListTableViewCell.h
//  YeFu
//
//  Created by Carl on 2017/12/15.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressListModel.h"

@protocol AddressListTableViewCellDelegate <NSObject>

-(void)editAddress:(AddressListModel*)model;

@end

@interface AddressListTableViewCell : UITableViewCell

@property(nonatomic)AddressListModel *model;

@property (nonatomic,weak) id<AddressListTableViewCellDelegate>delegate;

@end
