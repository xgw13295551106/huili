//
//  GoPayViewController.m
//  YeFu
//
//  Created by Carl on 2017/12/19.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "GoPayViewController.h"
#import "SendTypeTableViewCell.h"
#import "OrderPayHeadView.h"
#import "OrderPayFootView.h"
#import "AddressListViewController.h"
#import "CustormPayView.h"
#import "PaySuccessViewController.h"
#import "LCOrderDetailGoodsCell.h"
#import "LCMyOrderGoodsModel.h"
#import "WKBaseViewController.h"
#import "BalanceRechargeViewController.h"

@interface GoPayViewController ()<UITableViewDelegate,UITableViewDataSource,OrderPayFootViewDelegate>
@property (nonatomic,strong)UILabel *payMoneyLabel;

@property(nonatomic)UITableView *myTableView;

@property(nonatomic)NSMutableArray *dataArray;

@property(nonatomic)NSMutableArray *timeArray;

@property(nonatomic)NSMutableArray *selectArray;

@property(nonatomic)OrderPayHeadView *headView;

@property(nonatomic)OrderPayFootView *footView;

@property(nonatomic,weak)UILabel *sumPrice;

@property(nonatomic)NSString *sendeFeeValue;

@property(nonatomic)NSString *shipping_id;

@property(nonatomic)NSString *address_id;

@property(nonatomic)BOOL jifenPay;

@end

@implementation GoPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"确认订单"];
    
    [self.view addSubview:self.myTableView];

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.footView.balanceValue = [UserInfoManager currentUser].balance;
}

-(void)setDicData:(NSDictionary *)dicData{
    if (!_payMoneyLabel) {
        [self creatBottom];
    }
    _dicData=dicData;
    
    NSArray *array=[dicData objectForKey:@"goods"];
    [self.dataArray removeAllObjects];
    self.dataArray = [LCMyOrderGoodsModel mj_objectArrayWithKeyValuesArray:array];
    
    [self.myTableView reloadData];
    NSDictionary *addressDic=[dicData objectForKey:@"address"];
    AddressListModel *addressModel=[AddressListModel model];
    [addressModel initWithDictionary:addressDic];
    self.address_id=addressModel.address_id;
    [self.headView setModel:addressModel];
    NSLog(@"%@",dicData);
    
    if (self.dataArray.count == 1 && self.push_type == 1) {
        LCMyOrderGoodsModel *model = self.dataArray[0];
        self.footView.numValue = model.number;
        self.footView.editNum = YES;
    }else{
        self.footView.editNum = NO;
    }
    self.footView.scoreValue = [_dicData stringForKey:@"user_integral"];
    self.footView.balanceValue = [_dicData stringForKey:@"user_balance"];
    
    //现金合计金额
    _payMoneyLabel.attributedText = [self setAttributedStringStyleWithFirst:[dicData stringForKey:@"order_amount"]];
    
}
-(NSMutableArray*)dataArray{
    if (_dataArray==nil) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    return _dataArray;
}

-(OrderPayHeadView*)headView{
    if (_headView==nil) {
        _headView=[[OrderPayHeadView alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, 100)];
        [_headView setBackgroundColor:STYLECOLOR];
        [_headView addTarget:self action:@selector(clickAddress) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headView;
}
-(OrderPayFootView*)footView{
    if (_footView==nil) {
        _footView=[[OrderPayFootView alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, 210)];
        [_footView setBackgroundColor:[UIColor colorWithHexString:@"f7f7f7"]];
        [_footView setDelegate:self];
    }
    return _footView;
}

#pragma mark UITableView初始化
/******************************UITableView初始化开始**************************************/
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, AL_DEVICE_HEIGHT-50-KIsiPhoneXNavHAndB) style:UITableViewStylePlain];
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        _myTableView.tableHeaderView=self.headView;
        _myTableView.tableFooterView=self.footView;
        
        _myTableView.showsVerticalScrollIndicator = NO;
    }
    return _myTableView;
}
/******************************UITableView初始化结束**************************************/

#pragma mark UITableView代理
/******************************UITableView代理开始**************************************/

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"  ";
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LCMyOrderGoodsModel *model = self.dataArray[indexPath.row];
    return [LCOrderDetailGoodsCell getOrderDetailGoodsCell:tableView andIndex:indexPath andIdentifier:@"orderGoodsCell" andModel:model andBlock:^(LCMyOrderGoodsModel *goodsModel) {
        
    } andType:NO];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

/******************************UITableView代理结束**************************************/
-(void)creatBottom{
    UIView *bottomBg=[[UIView alloc]initWithFrame:CGRectMake(0, AL_DEVICE_HEIGHT-KIsiPhoneXNavHAndB-50, AL_DEVICE_WIDTH, 50)];
    [bottomBg setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bottomBg];
    
    UIButton *sumbit=[[UIButton alloc]initWithFrame:CGRectMake(AL_DEVICE_WIDTH-130, 0, 130, 50)];
    [sumbit setBackgroundColor:STYLECOLOR];
    [sumbit setTitle:@"支付" forState:UIControlStateNormal];
    [sumbit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sumbit.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [bottomBg addSubview:sumbit];
    [sumbit addTarget:self action:@selector(payClick) forControlEvents:UIControlEventTouchUpInside];
    
    _payMoneyLabel = [self getOrderPriceLabel:CGRectMake(15, sumbit.minY, sumbit.minX-8-15, sumbit.height) andTextAlignment:NSTextAlignmentLeft andText:@""];
    _payMoneyLabel.attributedText = [self setAttributedStringStyleWithFirst:@"0.00"];
    [bottomBg addSubview:_payMoneyLabel];
}

//TODO:获取订单总价的label
- (UILabel *)getOrderPriceLabel:(CGRect)frame andTextAlignment:(NSTextAlignment)textAlignment andText:(NSString *)text{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.textColor = [UIColor colorWithHexString:@"242428"];
    label.font = [UIFont systemFontOfSize:14];
    label.text = text;
    label.textAlignment = textAlignment;
    
    return label;
}

/**
 创建富文本对象并返回
 
 @param string1 第一段文字
 @return 返回创建好的富文本
 */
- (NSMutableAttributedString *)setAttributedStringStyleWithFirst:(NSString *)string1
{
    NSString *title = @"合计:";
    NSString *first_string = [NSString stringWithFormat:@"￥%@",string1];
    
    NSString *totalString = [NSString stringWithFormat:@"%@%@", title,first_string];
    //找到各个string在总字符串中的位置
    NSRange title_range = [totalString rangeOfString:title];
    NSRange first_range = [totalString rangeOfString:first_string];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:totalString];
    //合计的格式
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:title_range];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:title_range];
    //金额的格式
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"F23939"] range:first_range];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:first_range];
    
    return str;
}

/****************************选择地址**************************************/
-(void)clickAddress{
    AddressListViewController *vc=[[AddressListViewController alloc]init];
    [vc setIsSelectAddress:YES];
    [self.navigationController pushViewController:vc animated:YES];
    YHWeakSelf
    [vc setSelectAddressBlock:^(AddressListModel *model) {
        weakSelf.address_id=model.address_id;
        [weakSelf.headView setModel:model];
    }];
}
/****************************选择地址**************************************/


/****************************去支付**************************************/
-(void)payClick{
    if (self.footView.numValue.intValue == 0 && self.push_type == 1) {
        [self.view makeToast:@"购买数量不能为0" duration:1.2 position:CSToastPositionCenter];
        return;
    }
    //支付类型1 支付宝 2微信 3余额
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"token"] = TOKEN;
    para[@"supplier_id"] = [UserDefaults stringForKey:@"supplier_id"];
    
    para[@"address_id"] = self.address_id;
    para[@"type"] = [NSString stringWithFormat:@"%i",self.push_type];
    if (self.push_type == 1) {
        LCMyOrderGoodsModel *model = self.dataArray.count==1?self.dataArray[0]:nil;
        para[@"ids"]=[NSString stringWithFormat:@"%@_%@_%@",model.id,model.attr_ids,_footView.numValue];
    }else if (self.push_type == 2){
        para[@"ids"] = self.cart_id;
    }else if (self.push_type == 3){
        para[@"ids"] = self.order_id;
    }
    if (self.footView.coinSwitch.on) {
        para[@"is_integral"] = @"1";
    }else{
        para[@"is_integral"] = @"0";
    }
    [CustormPayView shareCustormPayView:^(CustormPayType payType, UIButton *payButton)
     {
         if (payType == AlipayType){  //支付宝支付
             para[@"pay_type"] = @"1";
         }else if (payType == WechatPayType){ //微信支付
             para[@"pay_type"] = @"2";
         }else{  //余额支付
             para[@"pay_type"] = @"3";
             if ([UserInfoManager currentUser].balance.floatValue < [_dicData stringForKey:@"order_amount"].floatValue) {
                 [self.view makeToast:@"余额不足!" duration:1.2 position:CSToastPositionCenter];
                 [CustormPayView dismiss];
                 return ;
             }
         }
         [self requestPayOrderNet:para];
     }];
    
}

//TODO:检查余额是否充足 返回NO代表余额不足
- (BOOL)requestCheckBalance{
    if (self.footView.coinSwitch.on == NO) {
        return YES;
    }
    float amount = [_dicData stringForKey:@"order_amount"].floatValue;
//    float balance = [_dicData stringForKey:@"user_balance"].floatValue;
    float balance = [UserInfoManager currentUser].balance.floatValue;
    if (balance < amount) {
        NSString *message = [NSString stringWithFormat:@"余额不足(当前可用￥%.2f)，请充值",balance];
        ScottAlertView *alertView = [ScottAlertView alertViewWithTitle:App_Name message:message];
        [alertView addAction:[ScottAlertAction actionWithTitle:@"取消" style:ScottAlertActionStyleCancel handler:^(ScottAlertAction *action) {
            
        }]];
        [alertView addAction:[ScottAlertAction actionWithTitle:@"前往充值" style:ScottAlertActionStyleDestructive handler:^(ScottAlertAction *action) {
            BalanceRechargeViewController *vc = [[BalanceRechargeViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }]];
        ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:alertView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleDropDown];
        alertController.tapBackgroundDismissEnable = NO;
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        return NO;
    }
    return YES;
}

/****************************去支付**************************************/


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/****************************footView代理**************************************/
#pragma mark footView 代理事件
//TODO:点击查看手续费说明
- (void)clickHandFeeButton{
    WKBaseViewController *vc=[[WKBaseViewController alloc]init];
    [vc setTitle:@"手续费说明"];
    [vc setUrl:[CommonConfig shared].feeRules];
    [self.navigationController pushViewController:vc animated:YES];
}
//TODO:更改商品数量
- (void)changeBuyNum{
    [self requestUpdateBuyInfoWith:nil];
}

//TODO:选择支付类型
- (void)clickSwitchAction:(UISwitch *)button{
    if (button.on) {
        _payMoneyLabel.attributedText = [self setAttributedStringStyleWithFirst:[_dicData stringForKey:@"order_amount"]];
    }else{
        _payMoneyLabel.attributedText = [self setAttributedStringStyleWithFirst:[_dicData stringForKey:@"order_amount"]];
    }
}

/****************************footView代理**************************************/

#pragma mark 网络请求
//当显示立即购买的订单时会用到该方法
- (void)requestUpdateBuyInfoWith:(NSMutableDictionary *)para{
    if (para == nil) {
        para = [NSMutableDictionary dictionary];
    }
    para[@"token"] = TOKEN;
    [para setValue:[UserDefaults stringForKey:@"supplier_id"] forKey:@"supplier_id"];
    para[@"type"] = @"1";
    LCMyOrderGoodsModel *model = self.dataArray.count==1?self.dataArray[0]:nil;
    para[@"ids"]=[NSString stringWithFormat:@"%@_%@_%@",model.id,model.attr_ids,_footView.numValue];
    [self postInbackground:GoOrderInfo withParam:para success:^(id responseObject) {
        NSDictionary *dic = responseObject;
        if ([dic[@"code"] intValue] == 1) {
            [self setDicData:dic[@"data"]];
        }else{
            [self.view makeToast:dic[@"msg"] duration:1.2 position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
        
    }];
}

/****************************支付定单**************************************/
//TODO:订单支付
- (void)requestPayOrderNet:(NSMutableDictionary *)para{
    [SVProgressHUD showWithStatus:@"正在发起支付..."];
    [self postInbackground:YHOrderPay withParam:para success:^(id responseObject) {
        [CustormPayView dismiss];
        NSDictionary *dic = responseObject;
        
        if ([dic[@"code"] intValue] == 1) {
            if ([para[@"pay_type"] isEqualToString:@"3"]) {
                [SVProgressHUD dismiss];
                [self payOrderSuccess:[responseObject objectForKey:@"data"]];
            }else if ([para[@"pay_type"] isEqualToString:@"1"]){
                //支付宝支付
                NSDictionary *dataDic = dic[@"data"];
                [[LCAlipayManager manager]AliPayWithOrderString:dataDic[@"alinfo"] andBlock:^(NSDictionary *resultDic) {
                    [SVProgressHUD dismiss];
                    NSString *resultString = nil;
                    int code = [resultDic[@"resultStatus"] intValue];
                    switch (code) {
                        case 9000:
                            resultString = @"订单支付成功!";
                            break;
                        case 8000:
                            resultString = @"正在处理中，请稍后";
                            break;
                        case 4000:
                            resultString = @"订单支付失败!";
                            break;
                        case 6001:
                            resultString = @"用户中途取消";
                            break;
                        case 6002:
                            resultString = @"网络连接出错";
                            break;
                        default:
                            break;
                    }
                    if (code == 9000) {
                        //支付成功后，刷新页面
                        [self payOrderSuccess:[responseObject objectForKey:@"data"]];
                    }else{
                        [SVProgressHUDHelp SVProgressHUDFail:@"支付失败"];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }];
                
            }else if([para[@"pay_type"] isEqualToString:@"2"]){
                //微信支付
                NSDictionary *data=[dic objectForKey:@"data"];
                NSDictionary *wxinfo=data[@"wxinfo"];
                LCWeChatModel *weChatModel = [LCWeChatModel mj_objectWithKeyValues:wxinfo];
                [[LCWeChatManager manager] weChatPayWithModel:weChatModel andBlock:^(BOOL success) {
                    [SVProgressHUD dismiss];
                    if (success) {
                        //支付成功
                        [self payOrderSuccess:[responseObject objectForKey:@"data"]];
                    }else{
                        [SVProgressHUDHelp SVProgressHUDFail:@"支付失败"];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    //                    [self addUIAlertControlWithString:resultString withActionBlock:nil];
                }];
            }else{//积分支付
                [self payOrderSuccess:[responseObject objectForKey:@"data"]];
            }
            
        }else{
            [SVProgressHUD dismiss];
            [self.view makeToast:dic[@"msg"] duration:1.2 position:CSToastPositionCenter];
            
        }
    } failure:^(NSError *error) {
        [CustormPayView dismiss];
        //        [self addUIAlertControlWithString:Network_Error withActionBlock:nil];
    }];
    
}

-(void)payOrderSuccess:(NSDictionary*)dic{
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    dict[@"order_id"] = [dic stringForKey:@"order_id"];
    dict[@"pay_amount"] = [dic stringForKey:@"pay_amount"];
    //dict[@"integral"]=[dic stringForKey:@"integral"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Notifi_CartChange object:nil userInfo:nil];
    
    [self.view makeToast:@"成功" duration:1.2 position:CSToastPositionCenter];
    PaySuccessViewController *vc=[[PaySuccessViewController alloc]init];
    [vc setDic:dict];
    [self.navigationController pushViewController:vc animated:YES];
}

/****************************支付定单**************************************/

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notifi_CartChange object:nil userInfo:nil];
}

@end
