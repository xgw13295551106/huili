//
//  LCBalanceHeadView.m
//  shop_send
//
//  Created by zhongweike on 2017/12/7.
//  Copyright © 2017年 zwk. All rights reserved.
//

#import "LCBalanceHeadView.h"

@interface LCBalanceHeadView (){
    UILabel *balanceLabel;  //余额
    UILabel *scoreLabel;  ///< 当前积分
    
    CGFloat self_width;
    CGFloat self_height;
}


@end

@implementation LCBalanceHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self_width = frame.size.width;
        self_height = frame.size.height;
        [self setBackgroundColor:STYLECOLOR];
        [self setUpControls:frame];
    }
    return self;
}

- (void)setUpControls:(CGRect)frame{
    //金额label
    CGFloat balanceL_x = 0;
    CGFloat balanceL_y = 30;
    CGFloat balanceL_w = self_width/2;
    CGFloat balanceL_h = 40;
    balanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(balanceL_x, balanceL_y, balanceL_w, balanceL_h)];
    balanceLabel.textColor = [UIColor whiteColor];
    balanceLabel.font = [UIFont systemFontOfSize:30];
    balanceLabel.textAlignment = NSTextAlignmentCenter;
    balanceLabel.text = [UserInfoManager currentUser].balance;
    [self addSubview:balanceLabel];
    
    UILabel *titleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(balanceLabel.minX, balanceLabel.maxY+10, balanceLabel.width, 25)];
    titleLabel1.text = @"账户余额(元)";
    titleLabel1.textColor = [UIColor whiteColor];
    titleLabel1.font = [UIFont systemFontOfSize:15];
    titleLabel1.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel1];
    
    //当前积分
    scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(balanceLabel.maxX, balanceLabel.minY, self_width/2, balanceLabel.height)];
    scoreLabel.textColor = [UIColor whiteColor];
    scoreLabel.font = [UIFont systemFontOfSize:30];
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:scoreLabel];
    
    UILabel *titleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(scoreLabel.minX, titleLabel1.minY, scoreLabel.width, titleLabel1.height)];
    titleLabel2.textColor = [UIColor colorWithHexString:@"ffffff"];
    titleLabel2.font = [UIFont systemFontOfSize:15];
    titleLabel2.text = @"当前积分";
    titleLabel2.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel2];
    
    
    self.height = titleLabel1.maxY + 25;
}


/**
 刷新headview
 
 @param dic  alipay_account alipay_mobile alipay_realname balance extract income pay
 */
- (void)reloadHeadView{
    UserInfoModel *userInfo = [UserInfoManager currentUser];
    balanceLabel.text = userInfo.balance;
    scoreLabel.text = userInfo.integral;
}

@end
