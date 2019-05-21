//
//  BalanceRechargeViewController.m
//  Bee
//
//  Created by zxy on 2017/4/12.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "BalanceRechargeViewController.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>

@interface BalanceRechargeViewController ()<UITextFieldDelegate>

@property (nonatomic,assign) CGFloat discount;//折扣（9折）

@property (nonatomic,weak) UITextField *totalTF;//总额
@property (nonatomic,weak) UILabel *discountLabel;//折扣比
@property (nonatomic,weak) UILabel *discountMoneyLabel;//折扣的钱
@property (nonatomic,weak) UILabel *payLabel;//实际支付的金额

@property (nonatomic,weak) UIButton *wxBtn;
@property (nonatomic,weak) UIButton *aliBtn;
@property (nonatomic,weak) UIImageView *wxSelectImage;
@property (nonatomic,weak) UIImageView *aliSelectImage;

@property (nonatomic,copy) NSString *way;//1支付宝2微信
@property (nonatomic,copy) NSString *actualMoney;
@property (nonatomic,copy) NSString *discountMoney;
@property (nonatomic,copy) NSString *totalMoney;

@property(nonatomic,weak)UIButton *lastBtn;

@end

@implementation BalanceRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _way = @"2";
    
    
    [self configUI];
    _discount = [[UserDefaults objectForKey:@"discount"] floatValue]*10;
    _discountLabel.text = [NSString stringWithFormat:@"充值%.2f折优惠",_discount];
    
    [self setTitle:@"余额充值"];

    // Do any additional setup after loading the view.
}

- (void)configUI{
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, AL_DEVICE_HEIGHT-80)];
    [self.view addSubview:scrollView];
    [scrollView setShowsVerticalScrollIndicator:NO];
    
    
    UIView *bgView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, AL_DEVICE_WIDTH, 40+60*(int)(self.array.count/3)+60*(self.array.count%3==0?0:1))];
    [scrollView addSubview:bgView1];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 40)];
    [bgView1 addSubview:label1];
    label1.text = @"充值金额：";
    label1.textAlignment = 0;
    label1.textColor = text1Color;
    label1.font = [UIFont systemFontOfSize:16];
    
    for (int i=0; i<self.array.count; i++) {
        NSDictionary *dic=[self.array objectAtIndex:i];
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(10+((AL_DEVICE_WIDTH-30)/3+10)*(i%3), 45+(i/3)*60, (AL_DEVICE_WIDTH-30)/3, 50)];
        [btn.layer setCornerRadius:5];
        [btn setBackgroundColor:[UIColor colorWithHexString:@"d2d2d2"]];
        [scrollView addSubview:btn];
        UILabel *payMoney=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, btn.size.width, 20)];
        [payMoney setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        [payMoney setFont:[UIFont systemFontOfSize:15]];
        [payMoney setTextAlignment:NSTextAlignmentCenter];
        [payMoney setText:[NSString stringWithFormat:@"充%@元",[dic stringForKey:@"money"]]];
        [btn addSubview:payMoney];
        
        UILabel *giveMoney=[[UILabel alloc]initWithFrame:CGRectMake(0, 25, btn.size.width, 20)];
        [giveMoney setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        [giveMoney setFont:[UIFont systemFontOfSize:14]];
        if ([[dic stringForKey:@"true_money"] floatValue]<=0.0) {
            [giveMoney setHidden:YES];
            [payMoney setFrame:CGRectMake(0, 5, btn.size.width, 40)];
        }
        [giveMoney setText:[NSString stringWithFormat:@"赠送%@元",[dic stringForKey:@"true_money"]]];
        [btn addSubview:giveMoney];
        [giveMoney setTextAlignment:NSTextAlignmentCenter];
        
        [btn addTarget:self action:@selector(selectPrice:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=i;
        if (i==0) {
            _lastBtn=btn;
        }
    }
    
    
    
    [_lastBtn setBackgroundColor:STYLECOLOR];
    
    
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(20, bgView1.bottom+10, 100, 30)];
    [scrollView addSubview:label4];
    label4.text = @"支付方式";
    label4.textAlignment = 0;
    label4.textColor = text2Color;
    label4.font = [UIFont systemFontOfSize:15];
    for (int i=0; i<2; i++) {
        UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [scrollView addSubview:payBtn];
        payBtn.frame = CGRectMake(0, bgView1.bottom+50+60*i, AL_DEVICE_WIDTH, 60);
        [payBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        
        [payBtn addTarget:self action:@selector(clickPayBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *leftIcon = [[UIImageView alloc]init];
        [payBtn addSubview:leftIcon];
        leftIcon.frame = CGRectMake(20, 10, 40, 40);
        leftIcon.image = [UIImage imageNamed:(i==1?@"user_wallet_alipay":@"user_wallet_wechat")];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftIcon.right+5, 10, 100, 40)];
        [payBtn addSubview:titleLabel];
        titleLabel.text = (i==1?@"支付宝":@"微信");
        titleLabel.textAlignment = 0;
        titleLabel.textColor = text1Color;
        titleLabel.font = [UIFont systemFontOfSize:16];
        
        UIImageView *rightIcon = [[UIImageView alloc]init];
        [payBtn addSubview:rightIcon];
        rightIcon.frame = CGRectMake(AL_DEVICE_WIDTH-40, 15, 30, 30);
        rightIcon.image = [UIImage imageNamed:(i==0?@"common_product_select":@"common_product_unselect")];
        
        UIView *line0 = [[UIView alloc]initWithFrame:CGRectMake(0, 59.5, AL_DEVICE_WIDTH, 0.5)];
        [payBtn addSubview:line0];
        line0.backgroundColor = LineColor;
        
        if (i==0) {
            _aliBtn = payBtn;
            _aliSelectImage = rightIcon;
            
        }else if (i==1){
            _wxBtn = payBtn;
            _wxSelectImage = rightIcon;
        }
    }
    
    [scrollView setContentSize:CGSizeMake(AL_DEVICE_WIDTH, bgView1.bottom+50+60*2)];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:nextBtn];
    nextBtn.frame = CGRectMake(15, AL_DEVICE_HEIGHT-70-64, AL_DEVICE_WIDTH-30, 44);
    [nextBtn setTitle:@"立即充值" forState:0];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:0];
    nextBtn.cornerRadius = 3;
    [nextBtn setBackgroundImage:[UIImage imageWithColor:STYLECOLOR] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(rechargeMargin) forControlEvents:UIControlEventTouchUpInside];
    
    [self checkPrice];


}
- (void)rechargeMargin{
    //    [_totalTF resignFirstResponder];
//        if ([_totalMoney floatValue]<=0) {
//            [self toast:@"请输入充值金额"];
//            [_totalTF becomeFirstResponder];
//            return;
//        }
    
    if ([_way isEqualToString:@"1"]) {
        if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://"]]) {
            [self toast:@"未安装支付宝"];
            return;
        }
    }else if ([_way isEqualToString:@"2"]) {
        if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
            [self.view makeToast:@"未安装微信" duration:1.2 position:CSToastPositionCenter];
            return;
        }
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:TOKEN forKey:@"token"];
    [param setValue:@"2" forKey:@"type"];//1押金充值2账户充值
    [param setValue:_way forKey:@"way"];//1支付宝2微信
    [param setValue:[UserDefaults objectForKey:@"discount"] forKey:@"discount"];
//    [param setValue:_totalMoney forKey:@"total"];
//    [param setValue:_actualMoney forKey:@"money"];
    
    NSDictionary *dic=[self.array objectAtIndex:(int)_lastBtn.tag];
    [param setValue:[dic stringForKey:@"id"] forKey:@"top_id"];
    
    [self post:XYCharge withParam:param success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        int code = [responseObject intForKey:@"code"];
        if (code==1) {
            if ([_way isEqualToString:@"1"]) {
                /**
                 *  支付接口
                 *  @param orderStr       订单信息
                 *  @param schemeStr      调用支付的app注册在info.plist中的scheme
                 *  @param compltionBlock 支付结果回调Block
                 */
                [[AlipaySDK defaultService] payOrder:[responseObject stringForKey:@"data"] fromScheme:App_BundleId callback:^(NSDictionary *resultDic) {
                    int resultStatus = [resultDic intForKey:@"resultStatus"];
                    if (resultStatus == 9000) {
                        
                        
                        
                        [self successRecharge];
                    }
                }];
                
            }else if ([_way isEqualToString:@"2"]) {
                LCWeChatModel *weChatModel = [LCWeChatModel mj_objectWithKeyValues:responseObject[@"data"]];
                [[LCWeChatManager manager] weChatPayWithModel:weChatModel andBlock:^(BOOL success) {
                    [SVProgressHUD dismiss];
                    NSString *resultString = success?@"支付成功":@"支付失败";
                    if (success) {
                        //支付成功
                        [self successRecharge];
                    }else{
                        [self toast:resultString];
                    }
                    
                }];
                
            }
            
        }else{
            [self toast:[responseObject stringForKey:@"msg"]];
        }
    } failure:nil];
    
}
-(void)getInfo{
//    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
//    [param setValue:TOKEN forKey:@"token"];
//    [self postInbackground:XYInfo withParam:param success:^(id responseObject) {
//        int code=[responseObject intForKey:@"code"];
//        if (code==1) {
//            NSDictionary *dic=[responseObject objectForKey:@"data"];
//            [UserDefaults setValue:[dic stringForKey:@"bank_name"] forKey:@"bank_name"];
//            [UserDefaults setValue:[dic stringForKey:@"bank_card_no"] forKey:@"bank_card_no"];
//            [UserDefaults setValue:[dic stringForKey:@"real_balance"] forKey:@"real_balance"];
//            [UserDefaults setValue:[dic stringForKey:@"alipay_account"] forKey:@"alipay_account"];
//            [UserDefaults setValue:[dic stringForKey:@"alipay_name"] forKey:@"alipay_name"];
//            [UserDefaults setValue:[dic stringForKey:@"alipay_account_hidden"] forKey:@"alipay_account_hidden"];
//            [[DataManager shared].currentUser initWithDictionary:dic];
//            [[DataManager shared].currentUser update];
//        }
//    } failure:^(NSError *error) {
//        
//    }];
}

- (void)successRecharge{
    [self getInfo];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"钱包充值成功" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)onResp:(BaseResp *)resp{
    if ([resp isKindOfClass:[PayResp class]]) {
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg;
        
        switch (resp.errCode) {
            case WXSuccess:{
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                
                [self successRecharge];
                
                break;
            }
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                [self toast:@"支付失败"];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
}

- (void)clickPayBtn:(UIButton *)payBtn{
    if (payBtn==_aliBtn) {
        _way = @"2";
        _aliSelectImage.image = [UIImage imageNamed:@"common_product_select"];
        _wxSelectImage.image = [UIImage imageNamed:@"common_product_unselect"];
    }else if (payBtn==_wxBtn) {
        _way = @"1";
        _aliSelectImage.image = [UIImage imageNamed:@"common_product_unselect"];
        _wxSelectImage.image = [UIImage imageNamed:@"common_product_select"];
        
    }
}

- (void)reloadMoneyWithTotal:(NSString *)total{
    
    CGFloat totalMoney = [total floatValue];
    CGFloat discountMoney = totalMoney*(10-_discount)/10;
    CGFloat actualMoney = totalMoney - discountMoney;
    _totalMoney = total;
    _discountMoney = [NSString stringWithFormat:@"%.2f",discountMoney];
    _actualMoney = [NSString stringWithFormat:@"%.2f",actualMoney];
    
    _discountMoneyLabel.text = [NSString stringWithFormat:@"-￥%.2f",discountMoney];
    _payLabel.text = [NSString stringWithFormat:@"￥%.2f",actualMoney];
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _totalTF) {
        [self reloadMoneyWithTotal:_totalTF.text];
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _totalTF) {
        if (textField.text.length>10) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark--选择价格
-(void)selectPrice:(UIButton*)sender{
    [_lastBtn setBackgroundColor:[UIColor colorWithHexString:@"d2d2d2"]];
    [sender setBackgroundColor:STYLECOLOR];
    _lastBtn=sender;
    [self checkPrice];
}

#pragma mark-- 检车价格
-(void)checkPrice{
    
    int tag=(int)_lastBtn.tag;
    NSDictionary *dic=[self.array objectAtIndex:tag];
    
    NSString *title = [dic stringForKey:@"true_money"];
    _totalTF.text=title;
    
    
    [self reloadMoneyWithTotal:title];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
