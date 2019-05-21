//
//  AmapAddressModel.h
//  YeFu
//
//  Created by Carl on 2017/12/12.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "BaseModel.h"

@interface AmapAddressModel : BaseModel

///name
@property (nonatomic, copy) NSString     *name;

///格式化地址
@property (nonatomic, copy) NSString     *formattedAddress;
///所在省/直辖市
@property (nonatomic, copy) NSString     *province;
///城市名
@property (nonatomic, copy) NSString     *city;

@property (nonatomic, copy) NSString     *district;

@property(nonatomic,copy)NSString *lat;

@property(nonatomic,copy)NSString *lng;

@end
