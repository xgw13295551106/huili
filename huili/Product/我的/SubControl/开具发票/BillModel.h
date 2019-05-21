//
//  BillModel.h
//  YeFu
//
//  Created by Carl on 2017/12/9.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "BaseModel.h"

@interface BillModel : BaseModel

/** 文标题  */
@property (nonatomic, copy ) NSString *order_id;

@property (nonatomic, copy ) NSString *time;

@property(nonatomic,copy)NSString *price;

@property(nonatomic)int amount;

@property(nonatomic,copy)NSString *order_sn;

@property(nonatomic)NSArray *imgArr;

@property(nonatomic)BOOL isSelect;

/**
 创建一个新的实例
 */
+(BillModel *)model;
/**
 通过字典初始化数据
 */
-(void)initWithDictionary:(NSDictionary *)dic;

@end
