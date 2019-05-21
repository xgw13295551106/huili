//
//  YeFuListModel.h
//  YeFu
//
//  Created by Carl on 2017/12/14.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "BaseModel.h"

@interface YeFuListModel : BaseModel

@property(nonatomic,strong)NSString *yefu_id;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *img;
@property(nonatomic,strong)NSString *cat_name;
@property(nonatomic,strong)NSString *count;
@property(nonatomic,strong)NSString *created_at;
@property(nonatomic,strong)NSString *url;//规格

/**
 创建一个新的实例
 */
+(YeFuListModel *)model;
/**
 通过字典初始化数据
 */
-(void)initWithDictionary:(NSDictionary *)dic;


@end
