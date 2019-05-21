//
//  LCMyOrderAddressModel.h
//  YeFu
//
//  Created by zhongweike on 2017/12/15.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCMyOrderAddressModel : NSObject

/** 收货地址id */
@property (nonatomic,copy) NSString *id;
/** user_id */
@property (nonatomic,copy) NSString *user_id;
/** supplier_id */
@property (nonatomic,copy) NSString *supplier_id;
/** 收货人 */
@property (nonatomic,copy) NSString *consignee;
/** 联系电话 */
@property (nonatomic,copy) NSString *mobile;
/** 省份 */
@property (nonatomic,copy) NSString *province;
/** 城市 */
@property (nonatomic,copy) NSString *city;
/** 区域 */
@property (nonatomic,copy) NSString *district;
/** 地址 */
@property (nonatomic,copy) NSString *address;
/** 纬度 */
@property (nonatomic,copy) NSString *lat;
/** 经度 */
@property (nonatomic,copy) NSString *lng;
/** 楼牌号 */
@property (nonatomic,copy) NSString *build_no;






@end
