//
//  BillArrayModel.h
//  YeFu
//
//  Created by Carl on 2017/12/9.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "BaseModel.h"
#import "BillModel.h"

@interface BillArrayModel : BaseModel

/** 文标题  */
@property (nonatomic, copy ) NSString *month;

@property (nonatomic ) NSMutableArray *billArray;

/**
 创建一个新的实例
 */
+(BillArrayModel *)model;
/**
 通过字典初始化数据
 */
-(instancetype)initWithDictionary:(NSDictionary *)dic;

@end
