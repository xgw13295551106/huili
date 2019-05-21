//
//  LCUserInfoHeadView.m
//  zhuaWaWa
//
//  Created by zhongweike on 2017/11/24.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "LCUserInfoHeadView.h"

@interface LCUserInfoHeadView ()

@property (nonatomic,strong)UIImageView *headImgView;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *phoneLabel;
@property (nonatomic,strong)UIImageView *vipLevelImgView; ///< 会员等级image

@property(nonatomic,weak)UIButton *singBtn;

@property(nonatomic)NSMutableArray *notificationHubArr;

@end

@implementation LCUserInfoHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor colorWithHexString:@"f8f8f8"]];
        [self setUpControls];
    }
    return self;
}

-(NSMutableArray*)notificationHubArr{
    if (_notificationHubArr==nil) {
        _notificationHubArr=[[NSMutableArray alloc]init];
    }
    return _notificationHubArr;
}

- (void)setUpControls{
    
    UIView *topBg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, 120)];
    [topBg setBackgroundColor:STYLECOLOR];
    [self addSubview:topBg];
    //头像
    CGFloat img_w = 90;
    CGFloat img_h = 90;
    CGFloat img_x = 20;
    CGFloat img_y = 0;
    _headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(img_x, img_y, img_w, img_h)];
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:[UserInfoManager currentUser].img] placeholderImage:DefaultsImg];
    [topBg addSubview:_headImgView];
    _headImgView.layer.cornerRadius = img_h /2 ;
    _headImgView.layer.masksToBounds = YES;
    
    //会员专区ge
    UIImage *vipAreaImg = [UIImage imageNamed:@"user_vip1"];
    UIImageView *vipImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.width-20-vipAreaImg.size.width, topBg.height-vipAreaImg.size.height, vipAreaImg.size.width, vipAreaImg.size.height)];
    [vipImgView setImage:vipAreaImg];
    vipImgView.userInteractionEnabled = YES;
    [topBg addSubview:vipImgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchVipImgView)];
    [vipImgView addGestureRecognizer:tap];
    
    //昵称
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_headImgView.right+10, _headImgView.top+15, 120, 20)];
    _nameLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    _nameLabel.font = [UIFont boldSystemFontOfSize:16];
    _nameLabel.text = [UserInfoManager currentUser].name;
    _nameLabel.text=@"小胖子";
    [topBg addSubview:_nameLabel];
    
    //会员图片
    _vipLevelImgView = [[UIImageView alloc]initWithFrame:CGRectMake(_nameLabel.maxX+8, _nameLabel.minY, _nameLabel.height, _nameLabel.height)];
    _vipLevelImgView.contentMode = UIViewContentModeScaleAspectFit;
    [topBg addSubview:_vipLevelImgView];
    
    //手机号
    _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(_headImgView.right+10, _nameLabel.bottom+15, 120, 20)];
    _phoneLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    _phoneLabel.font = [UIFont boldSystemFontOfSize:16];
    _phoneLabel.text = [UserInfoManager currentUser].hidlogin;
    [topBg addSubview:_phoneLabel];
    
    UIButton *singBtn=[[UIButton alloc]initWithFrame:CGRectMake(AL_DEVICE_WIDTH-80, (topBg.height-35)/2, 115, 35)];
    [singBtn.layer setCornerRadius:17.5];
    [singBtn.layer setMasksToBounds:YES];
    [topBg addSubview:singBtn];
    [singBtn setBackgroundColor:[UIColor colorWithHexString:@"9be3e0"]];
    [singBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [singBtn setTitle:@" 签到      " forState:UIControlStateNormal];
    [singBtn setImage:[UIImage imageNamed:@"user_qiandao"] forState:UIControlStateNormal];
    [singBtn addTarget:self action:@selector(signClick) forControlEvents:UIControlEventTouchUpInside];
    _singBtn=singBtn;
    _singBtn.hidden = YES;
    
    UIView *bottomBg=[[UIView alloc]initWithFrame:CGRectMake(0, topBg.bottom+10, AL_DEVICE_WIDTH, 110)];
    [bottomBg setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:bottomBg];
    
    UIButton *allBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, 44)];
    allBtn.tag=0;
    [allBtn addTarget:self action:@selector(orderClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBg addSubview:allBtn];
    UILabel *allLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 120, 44)];
    [allLabel setText:@"订单管理"];
    [allLabel setTextColor:text1Color];
    [allLabel setFont:[UIFont systemFontOfSize:16]];
    [allBtn addSubview:allLabel];
    
    UIImageView *row=[[UIImageView alloc]initWithFrame:CGRectMake(AL_DEVICE_WIDTH-30, 0, 30, 44)];
    [row setContentMode:UIViewContentModeCenter];
    [row setImage:[UIImage imageNamed:@"next"]];
    [allBtn addSubview:row];
    
    UILabel *allLabel2=[[UILabel alloc]initWithFrame:CGRectMake(AL_DEVICE_WIDTH-150, 0, 120, 44)];
    [allLabel2 setText:@"查看全部订单"];
    [allLabel2 setTextColor:text2Color];
    [allLabel2 setFont:[UIFont systemFontOfSize:15]];
    [allLabel2 setTextAlignment:NSTextAlignmentRight];
    [allBtn addSubview:allLabel2];
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, allLabel2.bottom, AL_DEVICE_WIDTH, 0.5)];
    [line setBackgroundColor:LineColor];
    [allBtn addSubview:line];
    
    [self.notificationHubArr removeAllObjects];
    NSArray *imgArray=[[NSArray alloc]initWithObjects:@"user_order_unpay",@"user_order_undeliver",@"user_order_unreceive",@"user_order_finish", @"user_order_aftermarket", nil];
    NSArray *nameArray=[[NSArray alloc]initWithObjects:@"待付款",@"待发货",@"待收货",@"已完成",@"售后订单", nil];
    for (int i =0; i<imgArray.count; i++) {
        UIButton *order=[[UIButton alloc]initWithFrame:CGRectMake(i*AL_DEVICE_WIDTH/5+(AL_DEVICE_WIDTH/5-40)/2, 48, 40, 40)];
        [order setImage:[UIImage imageNamed:[imgArray objectAtIndex:i]] forState:UIControlStateNormal];
        [bottomBg addSubview:order];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(i*AL_DEVICE_WIDTH/5, order.bottom-5, AL_DEVICE_WIDTH/5, 25)];
        [label setText:[nameArray objectAtIndex:i]];
        [label setFont:[UIFont systemFontOfSize:15]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:text1Color];
        [bottomBg addSubview:label];
        RKNotificationHub* hub = [[RKNotificationHub alloc]initWithView:order];
        [hub setCircleAtFrame:CGRectMake(order.width-15, 0, 20, 20)];
        hub.count=0;
        [self.notificationHubArr addObject:hub];
        [order addTarget:self action:@selector(orderClick:) forControlEvents:UIControlEventTouchUpInside];
        order.tag=i+1;
    }
    
    
    UIButton *editButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 240, 120)];
    [editButton setBackgroundColor:[UIColor clearColor]];
    [topBg addSubview:editButton];
    [editButton addTarget:self action:@selector(clickEditButton) forControlEvents:UIControlEventTouchUpInside];
//    //编辑
//    UIImage *editImg = [UIImage imageNamed:@"common_button_edit_def"];
//    UIImage *editImg_pre = [UIImage imageNamed:@"common_button_edit_pre"];
//    _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_editButton setFrame:CGRectMake(_nameLabel.maxX, _nameLabel.centerY-editImg.size.height/2, editImg.size.width, editImg.size.height)];
//    [_editButton setImage:editImg forState:UIControlStateNormal];
//    [_editButton setImage:editImg_pre forState:UIControlStateHighlighted];
//    [topBg addSubview:_editButton];
//    [_editButton addTarget:self action:@selector(clickEditButton) forControlEvents:UIControlEventTouchUpInside];
    
    //右侧箭头图片
    UIImage *rightImage = [UIImage imageNamed:@"user_next_white"];
    UIImageView *rightImgView = [[UIImageView alloc]initWithImage:rightImage];
    [rightImgView sizeToFit];
    [rightImgView setFrame:CGRectMake(win_width-10-rightImgView.width, 90/2-rightImgView.height/2, rightImgView.width, rightImgView.height)];
    [self addSubview:rightImgView];
    
}

-(void)clickEditButton{
    if ([self.delegate respondsToSelector:@selector(editUser)]) {
        [self.delegate editUser];
    }
}

- (void)reloadView{
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:[UserInfoManager currentUser].img] placeholderImage:[UIImage imageWithColor:LineColor]];
    _nameLabel.text = [UserInfoManager currentUser].name;
    _phoneLabel.text = [UserInfoManager currentUser].hidlogin;
    if ([[UserInfoManager currentUser].is_sign isEqualToString:@"1"]) {
        [_singBtn setTitle:@" 已签到       " forState:UIControlStateNormal];
        [_singBtn setEnabled:NO];
    }else{
        [_singBtn setEnabled:YES];
        [_singBtn setTitle:@" 签到      " forState:UIControlStateNormal];
    }
    [_nameLabel sizeToFit];
    _nameLabel.size = CGSizeMake(_nameLabel.width, 20);
    _vipLevelImgView.minX = _nameLabel.maxX+8;
    NSString *vipImageName = [NSString stringWithFormat:@"user_vip_level%i",[UserInfoManager currentUser].type.intValue];
    if ([UserInfoManager currentUser].type.intValue>0) {
        [_vipLevelImgView setImage:[UIImage imageNamed:vipImageName]];
    }else{
        [_vipLevelImgView setImage:[UIImage imageWithColor:[UIColor clearColor]]];
    }
}
/**************************签到****************************************/
-(void)signClick{
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:TOKEN forKey:@"token"];
    [[XAClient sharedClient] postInBackground:[NSString stringWithFormat:@"%@%@",YH_REQUEST_DOMAIN,USERSIGN] withParam:param success:^(id responseObject) {
        int code=[responseObject intForKey:@"code"];
        if (code==1) {
            [SVProgressHUDHelp SVProgressHUDSuccess:[NSString stringWithFormat:@"签到成功+%@积分",[CommonConfig shared].sign]];
            [_singBtn setTitle:@" 已签到       " forState:UIControlStateNormal];
        }else{
            [SVProgressHUDHelp SVProgressHUDFail:[responseObject stringForKey:@"msg"]];
        }
    } failure:nil];
}
/**************************签到****************************************/

/**************************订单点击****************************************/
-(void)orderClick:(UIButton*)sender{
    int tag=(int)sender.tag;
    if ([self.delegate respondsToSelector:@selector(clickOrder:)]) {
        [self.delegate clickOrder:tag];
    }
}
/**************************订单点击****************************************/


-(void)setOrderDic:(NSDictionary *)orderDic{
    _orderDic=orderDic;
    for (int i=0; i<self.notificationHubArr.count; i++) {
        RKNotificationHub* hub=[self.notificationHubArr objectAtIndex:i];
        if (i==0) {
            [hub setCount:[orderDic intForKey:@"dfk_order"]];
        }else if (i==1){
            [hub setCount:[orderDic intForKey:@"dfh_order"]];
        }else if (i==2){
            [hub setCount:[orderDic intForKey:@"dsh_order"]];
        }else if (i==3){
            [hub setCount:[orderDic intForKey:@"ywc_order"]];
        }else if (i==4){
            [hub setCount:[orderDic intForKey:@"sh_order"]];
        }
    }
}

//TODO:点击vip会员专区
- (void)touchVipImgView{
    if ([self.delegate respondsToSelector:@selector(clickVip)]) {
        [self.delegate clickVip];
    }
}

@end
