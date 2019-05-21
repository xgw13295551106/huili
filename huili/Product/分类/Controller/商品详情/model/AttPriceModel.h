//
//  AttPriceModel.h
//  yihuo
//
//  Created by Carl on 2017/12/27.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "BaseModel.h"

@interface AttPriceModel : BaseModel

@property(nonatomic,strong)NSString *attribute_id;
@property(nonatomic,strong)NSString *attr_ids;
@property(nonatomic,strong)NSString *attr_names;
@property(nonatomic,strong)NSString *price;
@property(nonatomic,strong)NSString *inventory;

/**
 创建一个新的实例
 */
+(AttPriceModel *)model;
/**
 通过字典初始化数据
 */
-(void)initWithDictionary:(NSDictionary *)dic;

@end
