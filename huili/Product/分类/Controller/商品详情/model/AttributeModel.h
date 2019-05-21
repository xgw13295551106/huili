//
//  AttributesModel.h
//  yihuo
//
//  Created by Carl on 2017/12/27.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "BaseModel.h"

@interface AttributeModel : BaseModel

@property(nonatomic,strong)NSString *attribute_id;
@property(nonatomic,strong)NSString *name;
@property(nonatomic)BOOL isSelect;

/**
 创建一个新的实例
 */
+(AttributeModel *)model;
/**
 通过字典初始化数据
 */
-(void)initWithDictionary:(NSDictionary *)dic;

@end
