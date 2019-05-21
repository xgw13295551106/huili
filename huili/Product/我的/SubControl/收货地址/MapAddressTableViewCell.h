//
//  MapAddressTableViewCell.h
//  YeFu
//
//  Created by Carl on 2017/12/12.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AmapAddressModel.h"

@interface MapAddressTableViewCell : UITableViewCell

@property(nonatomic)AmapAddressModel *model;

-(void)setCurrent;

@end
