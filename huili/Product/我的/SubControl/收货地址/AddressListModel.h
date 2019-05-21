//
//  AddressListModel.h
//  YeFu
//
//  Created by Carl on 2017/12/15.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "BaseModel.h"

@interface AddressListModel : BaseModel

@property (nonatomic, copy ) NSString *address_id;
@property (nonatomic, copy ) NSString *user_id;
@property (nonatomic, copy ) NSString *supplier_id;
@property (nonatomic, copy ) NSString *consignee;
@property (nonatomic, copy ) NSString *mobile;
@property (nonatomic, copy ) NSString *province;
@property (nonatomic, copy ) NSString *city;
@property (nonatomic, copy ) NSString *district;
@property (nonatomic, copy ) NSString *address;
@property (nonatomic, copy ) NSString *build_no;
@property (nonatomic, copy ) NSString *is_default;
@property (nonatomic, copy ) NSString *lat;
@property (nonatomic, copy ) NSString *lng;
@property (nonatomic, copy ) NSString *is_del;
@property (nonatomic, copy ) NSString *created_at;
@property (nonatomic, copy ) NSString *updated_at;


/**
 创建一个新的实例
 */
+(AddressListModel *)model;
/**
 通过字典初始化数据
 */
-(void)initWithDictionary:(NSDictionary *)dic;

@end
