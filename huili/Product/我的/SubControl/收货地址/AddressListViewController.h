//
//  AddressListViewController.h
//  YeFu
//
//  Created by Carl on 2017/12/8.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "YHBaseViewController.h"
#import "AddressListTableViewCell.h"

typedef void(^AddressListBlock)(AddressListModel *model);

@interface AddressListViewController : YHBaseViewController

@property(nonatomic)BOOL isSelectAddress;

@property (nonatomic,strong)AddressListBlock selectAddressBlock;

@end
