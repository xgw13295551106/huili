//
//  MessageModel.h
//  YeFu
//
//  Created by Carl on 2017/12/8.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "BaseModel.h"

@interface MessageModel : BaseModel

/** 文标题  */
@property (nonatomic, copy ) NSString *message_id;

@property (nonatomic, copy ) NSString *title;

@property(nonatomic,copy)NSString *img;

@property(nonatomic,copy)NSString *url;

@property(nonatomic,copy)NSString *time;

/**
 创建一个新的实例
 */
+(MessageModel *)model;
/**
 通过字典初始化数据
 */
-(void)initWithDictionary:(NSDictionary *)dic;

@end
