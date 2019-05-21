//
//  AddressListModel.m
//  YeFu
//
//  Created by Carl on 2017/12/15.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "AddressListModel.h"

@implementation AddressListModel

+(AddressListModel *)model
{
    return [[AddressListModel alloc] init];
}


- (void)initWithDictionary:(NSDictionary*)dic {
    
    self.address_id = [dic stringForKey:@"id"];
    self.user_id = [dic stringForKey:@"user_id"];
    self.supplier_id = [dic stringForKey:@"supplier_id"];
    self.consignee = [dic stringForKey:@"consignee"];
    self.mobile = [dic stringForKey:@"mobile"];
    self.province = [dic stringForKey:@"province"];
    self.city = [dic stringForKey:@"city"];
    self.district = [dic stringForKey:@"district"];
    self.address = [dic stringForKey:@"address"];
    self.build_no = [dic stringForKey:@"build_no"];
    self.is_default = [dic stringForKey:@"is_default"];
    self.lat = [dic stringForKey:@"lat"];
    self.lng = [dic stringForKey:@"lng"];
    self.is_del = [dic stringForKey:@"is_del"];
    self.created_at = [dic stringForKey:@"created_at"];
    self.updated_at = [dic stringForKey:@"updated_at"];
    
}

@end
