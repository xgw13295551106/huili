//
//  ClassifyModel.h
//  YeFu
//
//  Created by Carl on 2017/12/5.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "BaseModel.h"

@interface ClassifyModel : BaseModel

/** 文标题  */
@property (nonatomic, copy ) NSString *name;

@property (nonatomic, copy ) NSString *img;

@property (nonatomic, copy ) NSString *sub_id;

@property (nonatomic, copy ) NSString *cat_id;

/** 筛选的条件（数组） */
@property (nonatomic,strong) NSArray<NSString *> *filterArray;


/**
 创建一个新的实例
 */
+(ClassifyModel *)model;
/**
 通过字典初始化数据
 */
-(void)initWithDictionary:(NSDictionary *)dic;

@end
