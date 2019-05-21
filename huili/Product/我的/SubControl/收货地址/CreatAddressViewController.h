//
//  CreatAddressViewController.h
//  YeFu
//
//  Created by Carl on 2017/12/11.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "YHBaseViewController.h"
#import "AddressListModel.h"

@interface CreatAddressViewController : YHBaseViewController

@property(nonatomic)BOOL isEdit;

@property(nonatomic)BOOL isBuyTo;

@property(nonatomic)AddressListModel *model;

@end
