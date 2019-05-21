//
//  DrawBillModel.h
//  YeFu
//
//  Created by Carl on 2017/12/9.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "BaseModel.h"

@interface DrawBillModel : BaseModel

/** 发票id  */
@property (nonatomic, copy ) NSString *order_id;

@property (nonatomic, copy ) NSString *time;

@property(nonatomic,copy)NSString *price;

@property(nonatomic)int amount;

@property(nonatomic,copy)NSString *order_sn;
/**1电子 2纸质*/
@property(nonatomic,copy)NSString *type;

@property(nonatomic)BOOL isSelect;

/** 状态，是否已开票 0待开，1已开，2已发出 */
@property (nonatomic,copy) NSString *status;


/**
 创建一个新的实例
 */
+(DrawBillModel *)model;
/**
 通过字典初始化数据
 */
-(instancetype)initWithDictionary:(NSDictionary *)dic;

@end
