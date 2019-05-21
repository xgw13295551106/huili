//
//  JifenModel.h
//  YeFu
//
//  Created by Carl on 2017/12/8.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "BaseModel.h"

@interface JifenModel : BaseModel

/** id */
@property (nonatomic,copy) NSString *id;
/** 类型 */
@property (nonatomic,copy) NSString *type;
/** 时间 */
@property (nonatomic,copy) NSString *way;
/** 支付或充值方式 */
@property (nonatomic,copy) NSString *name;
/** 支付或充值状态 */
@property (nonatomic,copy) NSString *remark;
/** 收入或支出的状态 */
@property (nonatomic,copy) NSString *flag;
/**  */
@property (nonatomic,copy) NSString *created_at;
/** 积分 */
@property (nonatomic,copy) NSString *integral;

/**
 创建一个新的实例
 */
+(JifenModel *)model;
/**
 通过字典初始化数据
 */
-(void)initWithDictionary:(NSDictionary *)dic;

@end
