//
//  UserInfoModel.h
//  ConsumerProject
//
//  Created by John on 2017/8/11.
//  Copyright © 2017年 John.peng. All rights reserved.
//

#import "BaseModel.h"

@interface UserInfoModel : BaseModel<NSCoding>

@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *login;
@property(nonatomic,strong)NSString *city;
@property(nonatomic,strong)NSString *created_at;
@property(nonatomic,strong)NSString *district;
@property(nonatomic,strong)NSString *email;
@property(nonatomic,strong)NSString *img;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *province;
@property(nonatomic,strong)NSString *pwd;
@property(nonatomic,strong)NSString *token;
@property(nonatomic,strong)NSString *updated_at;
@property(nonatomic,strong)NSString *balance;
@property(nonatomic,strong)NSString *is_sign;
@property(nonatomic,strong)NSString *integral;
@property(nonatomic,strong)NSString *roung_token;
@property(nonatomic,strong)NSString *roung_user;
@property(nonatomic,strong)NSString *gender;

@property(nonatomic,strong)NSString *hidlogin;
/** 可提现金额 */
@property (nonatomic,copy) NSString *money;
/** 可提现积分 */
@property (nonatomic,copy) NSString *ints;
/** 会员等级  0普通 1铜 2银 3金 4钻  */
@property (nonatomic,copy) NSString *type;
/** 自己邀请码 */
@property (nonatomic,copy) NSString *code;
/** 上级邀请码 */
@property (nonatomic,copy) NSString *invite_code;
/** 会员到期时间 */
@property (nonatomic,copy) NSString *end_time;







/** 阿里账号 */
@property (nonatomic,copy) NSString *alipay_account;
/** 阿里账号绑定名称 */
@property (nonatomic,copy) NSString *alipay_realname;


/**
 通过字典获取UserModel

 @param dic 字典
 @return usermodel
 */
+ (instancetype)getUserModel:(NSDictionary *)dic;


@end
