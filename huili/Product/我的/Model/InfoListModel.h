//
//  InfoListModel.h
//  YeFu
//
//  Created by Carl on 2017/12/4.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "BaseModel.h"

@interface InfoListModel : BaseModel

/** 文标题  */
@property (nonatomic, copy ) NSString *name;

@property (nonatomic, copy ) NSString *img;

@property (nonatomic ) int cat_id;

/**
 创建一个新的实例
 */
+(InfoListModel *)model;
/**
 通过字典初始化数据
 */
-(void)initWithDictionary:(NSDictionary *)dic;

@end
