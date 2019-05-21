//
//  AttributesModel.h
//  yihuo
//
//  Created by Carl on 2017/12/27.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "BaseModel.h"
#import "AttributeModel.h"

@interface AttributesModel : BaseModel

@property(nonatomic)NSMutableArray *array;
@property(nonatomic)NSString *attributesModel_id;
@property(nonatomic)NSString *name;

/**
 创建一个新的实例
 */
+(AttributesModel *)model;
/**
 通过字典初始化数据
 */
-(void)initWithDictionary:(NSDictionary *)dic;

@end
